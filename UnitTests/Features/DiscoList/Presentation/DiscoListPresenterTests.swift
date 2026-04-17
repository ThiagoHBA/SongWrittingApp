import Foundation
import XCTest
@testable import Main

final class DiscoListPresenterTests: XCTestCase {
    func test_presentLoading_starts_loading_on_view() {
        let (sut, view, _, _) = makeSUT()

        sut.presentLoading()

        XCTAssertEqual(view.receivedMessages, [.startLoading])
    }

    func test_presentCreateDiscoError_hides_overlay_then_shows_error() {
        let (sut, view, _, _) = makeSUT()

        sut.presentCreateDiscoError(.emptyName)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideOverlays,
                .createDiscoError(
                    DiscoListError.CreateDiscoError.errorTitle,
                    DiscoListError.CreateDiscoError.emptyName.localizedDescription
                )
            ]
        )
    }

    func test_createUseCase_success_hides_loading_and_shows_new_disco() {
        let (_, view, repository, createDiscoUseCase) = makeSUT()
        let createdDisco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))

        createDiscoUseCase.input = .init(name: "Any", image: createdDisco.coverImage)
        createDiscoUseCase.execute()
        repository.createDiscoCompletion?(.success(createdDisco))
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .showNewDisco(DiscoListViewEntity(from: createdDisco))
            ]
        )
    }

    func test_getDiscos_success_hides_loading_and_shows_discos() {
        let (sut, view, _, _) = makeSUT()
        let discos = [
            DiscoSummary(id: UUID(), name: "One", coverImage: Data("1".utf8)),
            DiscoSummary(id: UUID(), name: "Two", coverImage: Data("2".utf8))
        ]

        sut.presentLoadedDiscos(discos)

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .showDiscos(discos.map(DiscoListViewEntity.init(from:)))
            ]
        )
    }

    func test_getDiscos_failure_hides_loading_and_shows_error() {
        let (sut, view, _, _) = makeSUT()
        let expectedError = NSError(domain: "any", code: 0)

        sut.presentLoadDiscoError(expectedError)

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .loadDiscoError(
                    DiscoListError.LoadDiscoError.errorTitle,
                    expectedError.localizedDescription
                )
            ]
        )
    }

    private func makeSUT() -> (
        sut: DiscoListPresenter,
        view: DiscoListViewSpy,
        repository: DiscoListRepositorySpy,
        createDiscoUseCase: CreateNewDiscoUseCase
    ) {
        let repository = DiscoListRepositorySpy()
        let createDiscoUseCase = CreateNewDiscoUseCase(repository: repository)
        let view = DiscoListViewSpy()
        let sut = DiscoListPresenter()

        createDiscoUseCase.output = [sut]
        sut.view = view

        return (sut, view, repository, createDiscoUseCase)
    }
}

private final class DiscoListViewSpy: DiscoListDisplayLogic {
    enum Message: Equatable {
        case startLoading
        case hideLoading
        case hideOverlays
        case showDiscos([DiscoListViewEntity])
        case showNewDisco(DiscoListViewEntity)
        case createDiscoError(String, String)
        case loadDiscoError(String, String)
    }

    private(set) var receivedMessages: [Message] = []
    var hideOverlaysCompletion: (() -> Void)?

    func startLoading() {
        receivedMessages.append(.startLoading)
    }

    func hideLoading() {
        receivedMessages.append(.hideLoading)
    }

    func hideOverlays(completion: (() -> Void)?) {
        receivedMessages.append(.hideOverlays)
        hideOverlaysCompletion = completion
    }

    func showDiscos(_ discos: [DiscoListViewEntity]) {
        receivedMessages.append(.showDiscos(discos))
    }

    func showNewDisco(_ disco: DiscoListViewEntity) {
        receivedMessages.append(.showNewDisco(disco))
    }

    func createDiscoError(_ title: String, _ description: String) {
        receivedMessages.append(.createDiscoError(title, description))
    }

    func loadDiscoError(_ title: String, _ description: String) {
        receivedMessages.append(.loadDiscoError(title, description))
    }
}
