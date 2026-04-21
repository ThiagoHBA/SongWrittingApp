import Foundation
import XCTest
@testable import Main

final class DiscoListPresenterTests: XCTestCase {
    func test_presentLoading_starts_loading_on_view() {
        let (sut, view) = makeSUT()

        sut.presentLoading()

        XCTAssertEqual(view.receivedMessages, [.startLoading])
    }

    func test_presentCreateDiscoError_hides_overlay_then_shows_error() {
        let (sut, view) = makeSUT()

        sut.presentCreateDiscoError(DiscoListError.CreateDiscoError.emptyName)
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

    func test_presentCreatedDisco_hides_loading_and_shows_new_disco() {
        let (sut, view) = makeSUT()
        let createdDisco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))

        sut.presentCreatedDisco(createdDisco)
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

    func test_presentCreateDiscoFailure_hides_loading_and_shows_error() {
        let (sut, view) = makeSUT()
        let error = NSError(domain: "any", code: 0)

        sut.presentCreateDiscoFailure(error)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .createDiscoError(
                    DiscoListError.CreateDiscoError.errorTitle,
                    error.localizedDescription
                )
            ]
        )
    }

    func test_getDiscos_success_hides_loading_and_shows_discos() {
        let (sut, view) = makeSUT()
        let discos = [
            DiscoSummary(id: UUID(), name: "One", coverImage: Data("1".utf8)),
            DiscoSummary(id: UUID(), name: "Two", coverImage: Data("2".utf8))
        ]
        let loadedDiscos = discos.map { (disco: $0, references: [AlbumReference]()) }

        sut.presentLoadedDiscos(loadedDiscos)

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .showDiscos(loadedDiscos.map { DiscoListViewEntity(from: $0.disco, references: $0.references) })
            ]
        )
    }

    func test_getDiscos_failure_hides_loading_and_shows_error() {
        let (sut, view) = makeSUT()
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

    func test_presentDeletedDisco_removes_disco_from_view() {
        let (sut, view) = makeSUT()
        let disco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))

        sut.presentDeletedDisco(disco)

        XCTAssertEqual(view.receivedMessages, [.removeDisco(DiscoListViewEntity(from: disco))])
    }

    func test_presentDeleteDiscoError_shows_error_on_view() {
        let (sut, view) = makeSUT()
        let error = NSError(domain: "any", code: 0, userInfo: [NSLocalizedDescriptionKey: "delete-error"])

        sut.presentDeleteDiscoError(error)

        XCTAssertEqual(
            view.receivedMessages,
            [
                .deleteDiscoError(
                    DiscoListError.DeleteDiscoError.errorTitle,
                    error.localizedDescription
                )
            ]
        )
    }
}

extension DiscoListPresenterTests {
    typealias SutAndDoubles = (
        sut: DiscoListPresenter,
        view: DiscoListViewSpy
    )

    private func makeSUT() -> SutAndDoubles {
        let view = DiscoListViewSpy()
        let sut = DiscoListPresenter()

        sut.view = view

        return (sut, view)
    }
}
