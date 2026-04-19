import Foundation
import XCTest
@testable import Main

final class DiscoProfilePresenterTests: XCTestCase {
    func test_presentLoading_starts_loading_on_view() {
        let (sut, view) = makeSUT()

        sut.presentLoading()

        XCTAssertEqual(view.receivedMessages, [.startLoading])
    }

    func test_presentCreateSectionError_hides_overlay_then_shows_error() {
        let (sut, view) = makeSUT()

        sut.presentCreateSectionError(DiscoProfileError.CreateSectionError.emptyName)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideOverlays,
                .addingSectionError(
                    DiscoProfileError.CreateSectionError.errorTitle,
                    DiscoProfileError.CreateSectionError.emptyName.localizedDescription
                )
            ]
        )
    }

    func test_presentFoundReferences_hides_loading_and_shows_references() {
        let (sut, view) = makeSUT()
        let references = [makeReference()]

        sut.presentFoundReferences(references)

        XCTAssertEqual(
            view.receivedMessages,
            [.hideLoading, .showReferences(references.map(AlbumReferenceViewEntity.init(from:)))]
        )
    }

    func test_presentFindReferencesError_hides_loading_and_shows_error() {
        let (sut, view) = makeSUT()
        let expectedError = NSError(domain: "find-reference", code: 0)

        sut.presentFindReferencesError(expectedError)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingReferencesError(
                    DiscoProfileError.LoadReferencesError.errorTitle,
                    expectedError.localizedDescription
                )
            ]
        )
    }

    func test_presentLoadedProfile_hides_loading_and_shows_profile() {
        let (sut, view) = makeSUT()
        let profile = makeProfile()

        sut.presentLoadedProfile(profile)

        XCTAssertEqual(
            view.receivedMessages,
            [.hideLoading, .showProfile(DiscoProfileViewEntity(from: profile))]
        )
    }

    func test_presentLoadProfileError_hides_loading_and_shows_error() {
        let (sut, view) = makeSUT()
        let expectedError = NSError(domain: "load-profile", code: 0)

        sut.presentLoadProfileError(expectedError)

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .loadingProfileError(
                    DiscoProfileError.LoadingProfileError.errorTitle,
                    expectedError.localizedDescription
                )
            ]
        )
    }

    func test_presentAddedReferences_hides_loading_and_updates_references() {
        let (sut, view) = makeSUT()
        let profile = makeProfile(references: [makeReference()])

        sut.presentAddedReferences(profile)

        XCTAssertEqual(
            view.receivedMessages,
            [.hideLoading, .updateReferences(profile.references.map(AlbumReferenceViewEntity.init(from:)))]
        )
    }

    func test_presentAddReferencesError_hides_loading_and_shows_error() {
        let (sut, view) = makeSUT()
        let expectedError = NSError(domain: "add-reference", code: 0)

        sut.presentAddReferencesError(expectedError)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingReferencesError(
                    DiscoProfileError.LoadReferencesError.errorTitle,
                    expectedError.localizedDescription
                )
            ]
        )
    }

    func test_presentAddedSection_hides_overlays_and_updates_sections() throws {
        let (sut, view) = makeSUT()
        let section = try Section(identifer: "Verse", records: [])
        let profile = makeProfile(sections: [section])

        sut.presentAddedSection(profile)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .updateSections([SectionViewEntity(from: section)])
            ]
        )
    }

    func test_presentAddSectionError_hides_overlays_and_shows_error() {
        let (sut, view) = makeSUT()
        let expectedError = NSError(domain: "add-section", code: 0)

        sut.presentAddSectionError(expectedError)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingSectionError(
                    DiscoProfileError.AddingSectionsError.errorTitle,
                    expectedError.localizedDescription
                )
            ]
        )
    }

    func test_presentAddedRecord_hides_overlays_and_updates_sections() throws {
        let (sut, view) = makeSUT()
        let section = try Section(identifer: "Verse", records: [])
        let profile = makeProfile(sections: [section])

        sut.presentAddedRecord(profile)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .updateSections([SectionViewEntity(from: section)])
            ]
        )
    }

    func test_presentAddRecordError_hides_overlays_and_shows_error() {
        let (sut, view) = makeSUT()
        let expectedError = NSError(domain: "add-record", code: 0)

        sut.presentAddRecordError(expectedError)
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingRecordsError(
                    DiscoProfileError.AddingRecordsError.errorTitle,
                    expectedError.localizedDescription
                )
            ]
        )
    }
}

extension DiscoProfilePresenterTests {
    typealias SutAndDoubles = (
        sut: DiscoProfilePresenter,
        view: DiscoProfileViewSpy
    )

    private func makeSUT() -> SutAndDoubles {
        let view = DiscoProfileViewSpy()
        let sut = DiscoProfilePresenter()

        sut.view = view

        return (sut, view)
    }

    private func makeDisco() -> DiscoSummary {
        DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))
    }

    private func makeReference() -> AlbumReference {
        AlbumReference(
            name: "Album",
            artist: "Artist",
            releaseDate: "2024-01-01",
            coverImage: "https://example.com/image"
        )
    }

    private func makeProfile(
        references: [AlbumReference] = [],
        sections: [Section] = []
    ) -> DiscoProfile {
        DiscoProfile(disco: makeDisco(), references: references, section: sections)
    }
}
