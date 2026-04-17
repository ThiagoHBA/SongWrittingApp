import Foundation
import XCTest
@testable import Main

final class DiscoListInteractorTests: XCTestCase {
    func test_loadDiscos_requests_loading_and_executes_useCase() {
        let (sut, presenter, repository, _) = makeSUT()

        sut.loadDiscos()

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(repository.receivedMessages, [.getDiscos])
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
        let getDiscosUseCase = GetDiscosUseCase(repository: repository)
        let createNewDiscoUseCase = CreateNewDiscoUseCase(repository: repository)
        let presenter = DiscoListPresenterSpy()
        let router = DiscoListRouterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
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
        case presentCreateDiscoError(DiscoListError.CreateDiscoError)
    }

    private(set) var receivedMessages: [Message] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
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

final class DiscoListRepositorySpy: DiscoListRepository {
    enum Message: Equatable {
        case getDiscos
        case createDisco(String, Data)
        case deleteDisco(DiscoSummary)
    }

    private(set) var receivedMessages: [Message] = []

    var getDiscosCompletion: ((Result<[DiscoSummary], Error>) -> Void)?
    var createDiscoCompletion: ((Result<DiscoSummary, Error>) -> Void)?
    var deleteDiscoCompletion: ((Result<Void, Error>) -> Void)?

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
