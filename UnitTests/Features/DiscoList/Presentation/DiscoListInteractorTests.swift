import Foundation
import XCTest
@testable import Main

final class DiscoListInteractorTests: XCTestCase {
    func test_loadDiscos_requests_loading_and_executes_useCase() {
        let (sut, presenter, getDiscosUseCase, _, _) = makeSUT()

        sut.loadDiscos()

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(getDiscosUseCase.receivedMessages, [.load(.init())])
    }

    func test_loadDiscos_onSuccess_presents_loaded_discos() {
        let (sut, presenter, getDiscosUseCase, _, _) = makeSUT()
        let discos = [
            DiscoSummary(id: UUID(), name: "One", coverImage: Data("1".utf8)),
            DiscoSummary(id: UUID(), name: "Two", coverImage: Data("2".utf8))
        ]

        sut.loadDiscos()
        getDiscosUseCase.completeLoad(with: .success(discos))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadedDiscos(discos)]
        )
    }

    func test_loadDiscos_onFailure_presents_load_error() {
        let (sut, presenter, getDiscosUseCase, _, _) = makeSUT()
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "any-error"])

        sut.loadDiscos()
        getDiscosUseCase.completeLoad(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadDiscoError(error.localizedDescription)]
        )
    }

    func test_createDisco_rejects_empty_name() {
        let (sut, presenter, _, createDiscoUseCase, _) = makeSUT()

        sut.createDisco(name: "", image: Data("image".utf8))

        XCTAssertEqual(
            presenter.receivedMessages,
            [
                .presentLoading,
                .presentCreateDiscoError(
                    DiscoListError.CreateDiscoError.emptyName.localizedDescription
                )
            ]
        )
        XCTAssertEqual(createDiscoUseCase.receivedMessages, [])
    }

    func test_createDisco_rejects_empty_image() {
        let (sut, presenter, _, createDiscoUseCase, _) = makeSUT()

        sut.createDisco(name: "Any", image: Data())

        XCTAssertEqual(
            presenter.receivedMessages,
            [
                .presentLoading,
                .presentCreateDiscoError(
                    DiscoListError.CreateDiscoError.emptyImage.localizedDescription
                )
            ]
        )
        XCTAssertEqual(createDiscoUseCase.receivedMessages, [])
    }

    func test_createDisco_requests_loading_and_executes_useCase_when_input_is_valid() throws {
        let (sut, presenter, _, createDiscoUseCase, _) = makeSUT()
        let image = Data("valid-image".utf8)
        let expectedDisco = try XCTUnwrap(try? Disco(name: "Any", image: image))

        sut.createDisco(name: "Any", image: image)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(createDiscoUseCase.receivedMessages, [.create(expectedDisco)])
    }

    func test_createDisco_onSuccess_presents_created_disco() {
        let (sut, presenter, _, createDiscoUseCase, _) = makeSUT()
        let createdDisco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))

        sut.createDisco(name: createdDisco.name, image: createdDisco.coverImage)
        createDiscoUseCase.completeCreate(with: .success(createdDisco))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentCreatedDisco(createdDisco)]
        )
    }

    func test_createDisco_onFailure_presents_create_failure() {
        let (sut, presenter, _, createDiscoUseCase, _) = makeSUT()
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "create-error"])

        sut.createDisco(name: "Any", image: Data("cover".utf8))
        createDiscoUseCase.completeCreate(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentCreateDiscoFailure(error.localizedDescription)]
        )
    }

    func test_showProfile_routes_with_disco_summary() {
        let (sut, _, _, _, router) = makeSUT()
        let disco = DiscoListViewEntity(id: UUID(), name: "Any", coverImage: Data("cover".utf8), entityType: .disco)

        sut.showProfile(of: disco)

        XCTAssertEqual(router.receivedMessages, [.showProfile(disco.toSummary())])
    }

    private func makeSUT() -> (
        sut: DiscoListInteractor,
        presenter: DiscoListPresenterSpy,
        getDiscosUseCase: GetDiscosUseCaseSpy,
        createDiscoUseCase: CreateNewDiscoUseCaseSpy,
        router: DiscoListRouterSpy
    ) {
        let getDiscosUseCase = GetDiscosUseCaseSpy()
        let createDiscoUseCase = CreateNewDiscoUseCaseSpy()
        let presenter = DiscoListPresenterSpy()
        let router = DiscoListRouterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createDiscoUseCase
        )
        sut.presenter = presenter
        sut.router = router
        return (sut, presenter, getDiscosUseCase, createDiscoUseCase, router)
    }
}

private final class DiscoListPresenterSpy: DiscoListPresentationLogic {
    enum Message: Equatable {
        case presentLoading
        case presentLoadedDiscos([DiscoSummary])
        case presentLoadDiscoError(String)
        case presentCreatedDisco(DiscoSummary)
        case presentCreateDiscoFailure(String)
        case presentCreateDiscoError(String)
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

    func presentCreatedDisco(_ disco: DiscoSummary) {
        receivedMessages.append(.presentCreatedDisco(disco))
    }

    func presentCreateDiscoFailure(_ error: Error) {
        receivedMessages.append(.presentCreateDiscoFailure(error.localizedDescription))
    }

    func presentCreateDiscoError(_ error: Error) {
        receivedMessages.append(.presentCreateDiscoError(error.localizedDescription))
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

private final class GetDiscosUseCaseSpy: GetDiscosUseCase {
    enum Message: Equatable {
        case load(GetDiscosUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<GetDiscosUseCaseOutput, Error>) -> Void)?

    func load(
        _ input: GetDiscosUseCaseInput,
        completion: @escaping (Result<GetDiscosUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.load(input))
        self.completion = completion
    }

    func completeLoad(with result: Result<GetDiscosUseCaseOutput, Error>) {
        completion?(result)
    }
}

private final class CreateNewDiscoUseCaseSpy: CreateNewDiscoUseCase {
    enum Message: Equatable {
        case create(CreateNewDiscoUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<CreateNewDiscoUseCaseOutput, Error>) -> Void)?

    func create(
        _ input: CreateNewDiscoUseCaseInput,
        completion: @escaping (Result<CreateNewDiscoUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.create(input))
        self.completion = completion
    }

    func completeCreate(with result: Result<CreateNewDiscoUseCaseOutput, Error>) {
        completion?(result)
    }
}
