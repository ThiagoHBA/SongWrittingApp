import Foundation
import XCTest
@testable import Main

final class DiscoListInteractorTests: XCTestCase {
    func test_loadDiscos_requests_loading_and_executes_useCase() {
        let (sut, presenter, repository, _) = makeSUT()

        sut.loadDiscos()

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(repository.receivedMessages, [.execute(.init())])
    }

    func test_loadDiscos_onSuccess_presents_loaded_discos() {
        let (sut, presenter, repository, _) = makeSUT()
        let discos = [
            DiscoSummary(id: UUID(), name: "One", coverImage: Data("1".utf8)),
            DiscoSummary(id: UUID(), name: "Two", coverImage: Data("2".utf8))
        ]

        sut.loadDiscos()
        repository.completeLoadDiscos(with: .success(discos))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadedDiscos(discos)]
        )
    }

    func test_loadDiscos_onFailure_presents_load_error() {
        let (sut, presenter, repository, _) = makeSUT()
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "any-error"])

        sut.loadDiscos()
        repository.completeLoadDiscos(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadDiscoError(error.localizedDescription)]
        )
    }

    func test_createDisco_rejects_empty_name() {
        let (sut, presenter, repository, _) = makeSUT()

        sut.createDisco(name: "", image: Data("image".utf8))

        XCTAssertEqual(presenter.receivedMessages, [.presentCreateDiscoError(.emptyName)])
        XCTAssertEqual(repository.receivedMessages, [])
    }

    func test_createDisco_rejects_empty_image() {
        let (sut, presenter, repository, _) = makeSUT()

        sut.createDisco(name: "Any", image: Data())

        XCTAssertEqual(presenter.receivedMessages, [.presentCreateDiscoError(.emptyImage)])
        XCTAssertEqual(repository.receivedMessages, [])
    }

    func test_createDisco_requests_loading_and_repository_when_input_is_valid() {
        let (sut, presenter, repository, _) = makeSUT()
        let image = Data("valid-image".utf8)

        sut.createDisco(name: "Any", image: image)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(repository.receivedMessages, [.createDisco("Any", image)])
    }

    func test_showProfile_routes_with_disco_summary() {
        let (sut, _, _, router) = makeSUT()
        let disco = DiscoListViewEntity(id: UUID(), name: "Any", coverImage: Data("cover".utf8))

        sut.showProfile(of: disco)

        XCTAssertEqual(router.receivedMessages, [.showProfile(disco.toSummary())])
    }

    private func makeSUT() -> (
        sut: DiscoListInteractor,
        presenter: DiscoListPresenterSpy,
        repository: DiscoListRepositorySpy,
        router: DiscoListRouterSpy
    ) {
        let repository = DiscoListRepositorySpy()
        let createNewDiscoUseCase = CreateNewDiscoUseCase(repository: repository)
        let presenter = DiscoListPresenterSpy()
        let router = DiscoListRouterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: repository,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        sut.presenter = presenter
        sut.router = router
        return (sut, presenter, repository, router)
    }
}

private final class DiscoListPresenterSpy: DiscoListPresentationLogic {
    enum Message: Equatable {
        case presentLoading
        case presentLoadedDiscos([DiscoSummary])
        case presentLoadDiscoError(String)
        case presentCreateDiscoError(DiscoListError.CreateDiscoError)
    }

    private(set) var receivedMessages: [Message] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentLoadedDiscos(_ discos: [DiscoSummary]) {
        receivedMessages.append(.presentLoadedDiscos(discos))
    }

    func presentLoadDiscoError(_ error: Error) {
        receivedMessages.append(.presentLoadDiscoError(error.localizedDescription))
    }

    func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError) {
        receivedMessages.append(.presentCreateDiscoError(error))
    }
}

private final class DiscoListRouterSpy: DiscoListRouting {
    enum Message: Equatable {
        case showProfile(DiscoSummary)
    }

    private(set) var receivedMessages: [Message] = []

    func showProfile(of disco: DiscoSummary) {
        receivedMessages.append(.showProfile(disco))
    }
}

final class DiscoListRepositorySpy: DiscoListRepository, GetDiscosUseCase {
    enum Message: Equatable {
        case execute(GetDiscosUseCaseInput)
        case getDiscos
        case createDisco(String, Data)
        case deleteDisco(DiscoSummary)
    }

    private(set) var receivedMessages: [Message] = []

    var executeCompletion: ((Result<GetDiscosUseCaseOutput, Error>) -> Void)?
    var getDiscosCompletion: ((Result<[DiscoSummary], Error>) -> Void)?
    var createDiscoCompletion: ((Result<DiscoSummary, Error>) -> Void)?
    var deleteDiscoCompletion: ((Result<Void, Error>) -> Void)?

    func load(
        _ input: GetDiscosUseCaseInput,
        completion: @escaping (Result<GetDiscosUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.execute(input))
        executeCompletion = completion
    }

    func completeLoadDiscos(with result: Result<GetDiscosUseCaseOutput, Error>) {
        executeCompletion?(result)
    }

    func getDiscos(completion: @escaping (Result<[DiscoSummary], Error>) -> Void) {
        receivedMessages.append(.getDiscos)
        getDiscosCompletion = completion
    }

    func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<DiscoSummary, Error>) -> Void
    ) {
        receivedMessages.append(.createDisco(name, image))
        createDiscoCompletion = completion
    }

    func deleteDisco(
        _ disco: DiscoSummary,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        receivedMessages.append(.deleteDisco(disco))
        deleteDiscoCompletion = completion
    }
}
