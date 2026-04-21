import Foundation
import XCTest
@testable import Main

final class DiscoListInteractorTests: XCTestCase {
    func test_loadDiscos_requests_loading_and_executes_useCase() {
        let (sut, presenter, getDiscosUseCase, _, _, _) = makeSUT()

        sut.loadDiscos()

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(getDiscosUseCase.receivedMessages, [.load(.init())])
    }

    func test_loadDiscos_onSuccess_presents_loaded_discos() {
        let (sut, presenter, getDiscosUseCase, _, _, _) = makeSUT()
        let discos = [
            DiscoSummary(id: UUID(), name: "One", coverImage: Data("1".utf8)),
            DiscoSummary(id: UUID(), name: "Two", coverImage: Data("2".utf8))
        ]

        sut.loadDiscos()
        getDiscosUseCase.completeLoad(with: .success(discos))

        wait(until: { presenter.receivedMessages.count == 2 })
        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadedDiscos(discos.map { (disco: $0, references: [AlbumReference]()) })]
        )
    }

    func test_loadDiscos_onFailure_presents_load_error() {
        let (sut, presenter, getDiscosUseCase, _, _, _) = makeSUT()
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "any-error"])

        sut.loadDiscos()
        getDiscosUseCase.completeLoad(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadDiscoError(error.localizedDescription)]
        )
    }

    func test_createDisco_rejects_empty_name() {
        let (sut, presenter, _, createDiscoUseCase, _, _) = makeSUT()

        sut.createDisco(name: "", description: nil, image: Data("image".utf8))

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
        let (sut, presenter, _, createDiscoUseCase, _, _) = makeSUT()

        sut.createDisco(name: "Any", description: nil, image: Data())

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
        let (sut, presenter, _, createDiscoUseCase, _, _) = makeSUT()
        let image = Data("valid-image".utf8)
        let expectedDisco = try XCTUnwrap(try? Disco(name: "Any", description: nil, image: image))

        sut.createDisco(name: "Any", description: nil, image: image)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(createDiscoUseCase.receivedMessages, [.create(expectedDisco)])
    }

    func test_createDisco_onSuccess_presents_created_disco() {
        let (sut, presenter, _, createDiscoUseCase, _, _) = makeSUT()
        let createdDisco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))

        sut.createDisco(name: createdDisco.name, description: nil, image: createdDisco.coverImage)
        createDiscoUseCase.completeCreate(with: .success(createdDisco))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentCreatedDisco(createdDisco)]
        )
    }

    func test_createDisco_onFailure_presents_create_failure() {
        let (sut, presenter, _, createDiscoUseCase, _, _) = makeSUT()
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "create-error"])

        sut.createDisco(name: "Any", description: nil, image: Data("cover".utf8))
        createDiscoUseCase.completeCreate(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentCreateDiscoFailure(error.localizedDescription)]
        )
    }

    func test_showProfile_routes_with_disco_summary() {
        let (sut, _, _, _, router, _) = makeSUT()
        let disco = DiscoListViewEntity(id: UUID(), name: "Any", coverImage: Data("cover".utf8), entityType: .disco)

        sut.showProfile(of: disco)

        XCTAssertEqual(router.receivedMessages, [.showProfile(disco.toSummary())])
    }

    func test_deleteDisco_calls_use_case_with_correct_input() {
        let (sut, _, _, _, _, deleteDiscoUseCase) = makeSUT()
        let disco = DiscoListViewEntity(id: UUID(), name: "Any", coverImage: Data("cover".utf8), entityType: .disco)

        sut.deleteDisco(disco)

        XCTAssertEqual(deleteDiscoUseCase.receivedMessages, [.delete(.init(disco: disco.toSummary()))])
    }

    func test_deleteDisco_onSuccess_presents_deleted_disco() {
        let (sut, presenter, _, _, _, deleteDiscoUseCase) = makeSUT()
        let disco = DiscoListViewEntity(id: UUID(), name: "Any", coverImage: Data("cover".utf8), entityType: .disco)

        sut.deleteDisco(disco)
        deleteDiscoUseCase.completeDelete(with: .success(disco.toSummary()))

        XCTAssertEqual(presenter.receivedMessages, [.presentDeletedDisco(disco.toSummary())])
    }

    func test_deleteDisco_onFailure_presents_delete_error() {
        let (sut, presenter, _, _, _, deleteDiscoUseCase) = makeSUT()
        let disco = DiscoListViewEntity(id: UUID(), name: "Any", coverImage: Data("cover".utf8), entityType: .disco)
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "delete-error"])

        sut.deleteDisco(disco)
        deleteDiscoUseCase.completeDelete(with: .failure(error))

        XCTAssertEqual(presenter.receivedMessages, [.presentDeleteDiscoError(error.localizedDescription)])
    }
}

extension DiscoListInteractorTests {
    typealias SutAndDoubles = (
        sut: DiscoListInteractor,
        presenter: DiscoListPresenterSpy,
        getDiscosUseCase: GetDiscosUseCaseSpy,
        createDiscoUseCase: CreateNewDiscoUseCaseSpy,
        router: DiscoListRouterSpy,
        deleteDiscoUseCase: DeleteDiscoUseCaseSpy
    )

    private func makeSUT() -> SutAndDoubles {
        let getDiscosUseCase = GetDiscosUseCaseSpy()
        let createDiscoUseCase = CreateNewDiscoUseCaseSpy()
        let deleteDiscoUseCase = DeleteDiscoUseCaseSpy()
        let getDiscoReferencesUseCase = GetDiscoReferencesUseCaseSpy()
        let presenter = DiscoListPresenterSpy()
        let router = DiscoListRouterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createDiscoUseCase,
            deleteDiscoUseCase: deleteDiscoUseCase,
            getDiscoReferencesUseCase: getDiscoReferencesUseCase
        )
        sut.presenter = presenter
        sut.router = router
        return (sut, presenter, getDiscosUseCase, createDiscoUseCase, router, deleteDiscoUseCase)
    }
}
