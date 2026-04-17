import Foundation
import XCTest
@testable import Main

final class DiscoProfilePresenterTests: XCTestCase {
    func test_presentLoading_starts_loading_on_view() {
        let (sut, view, _, _) = makeSUT()

        sut.presentLoading()

        XCTAssertEqual(view.receivedMessages, [.startLoading])
    }

    func test_presentCreateSectionError_hides_overlay_then_shows_error() {
        let (sut, view, _, _) = makeSUT()

        sut.presentCreateSectionError(.emptyName)
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

    func test_searchReferences_success_hides_loading_and_shows_references() {
        let (_, view, repositories, useCases) = makeSUT()
        let references = [
            AlbumReference(
                name: "Album",
                artist: "Artist",
                releaseDate: "2024-01-01",
                coverImage: "https://example.com/image"
            )
        ]

        useCases.search.input = .init(keywords: "any")
        useCases.search.execute()
        repositories.references.searchReferencesCompletion?(.success(references))

        XCTAssertEqual(
            view.receivedMessages,
            [.hideLoading, .showReferences(references.map(AlbumReferenceViewEntity.init(from:)))]
        )
    }

    func test_loadProfile_success_hides_loading_and_shows_profile() {
        let (_, view, repositories, useCases) = makeSUT()
        let profile = makeProfile()

        useCases.load.input = .init(disco: profile.disco)
        useCases.load.execute()
        repositories.profile.loadProfileCompletion?(.success(profile))

        XCTAssertEqual(
            view.receivedMessages,
            [.hideLoading, .showProfile(DiscoProfileViewEntity(from: profile))]
        )
    }

    func test_addReferences_failure_hides_loading_and_shows_error() {
        let (_, view, repositories, useCases) = makeSUT()
        let expectedError = NSError(domain: "add-reference", code: 0)

        useCases.addReferences.input = .init(disco: makeDisco(), newReferences: [])
        useCases.addReferences.execute()
        repositories.profile.addReferencesCompletion?(.failure(expectedError))
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

    func test_addSection_success_hides_overlays_and_updates_sections() {
        let (_, view, repositories, useCases) = makeSUT()
        let profile = makeProfile()
        let inputSection = Section(identifer: "Verse", records: [])
        let updatedProfile = DiscoProfile(
            disco: profile.disco,
            references: profile.references,
            section: [inputSection]
        )

        useCases.addSection.input = .init(disco: profile.disco, section: inputSection)
        useCases.addSection.execute()
        repositories.profile.addSectionCompletion?(.success(updatedProfile))
        view.hideOverlaysCompletion?()

        XCTAssertEqual(
            view.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .updateSections([SectionViewEntity(from: inputSection)])
            ]
        )
    }

    func test_addRecord_failure_hides_overlays_and_shows_error() {
        let (_, view, repositories, useCases) = makeSUT()
        let expectedError = NSError(domain: "add-record", code: 0)
        let inputSection = Section(
            identifer: "Verse",
            records: [.init(tag: .bass, audio: URL(string: "https://example.com/audio")!)]
        )

        useCases.addRecord.input = .init(disco: makeDisco(), section: inputSection)
        useCases.addRecord.execute()
        repositories.profile.addRecordCompletion?(.failure(expectedError))
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

    private func makeSUT() -> (
        sut: DiscoProfilePresenter,
        view: DiscoProfileViewSpy,
        repositories: (profile: DiscoProfileRepositorySpy, references: ReferenceSearchRepositorySpy),
        useCases: (
            search: SearchReferencesUseCase,
            load: GetDiscoProfileUseCase,
            addReferences: AddDiscoNewReferenceUseCase,
            addSection: AddNewSectionToDiscoUseCase,
            addRecord: AddNewRecordToSessionUseCase
        )
    ) {
        let profileRepository = DiscoProfileRepositorySpy()
        let referencesRepository = ReferenceSearchRepositorySpy()
        let view = DiscoProfileViewSpy()
        let sut = DiscoProfilePresenter()

        let searchUseCase = SearchReferencesUseCase(repository: referencesRepository)
        let loadUseCase = GetDiscoProfileUseCase(repository: profileRepository)
        let addReferencesUseCase = AddDiscoNewReferenceUseCase(repository: profileRepository)
        let addSectionUseCase = AddNewSectionToDiscoUseCase(repository: profileRepository)
        let addRecordUseCase = AddNewRecordToSessionUseCase(repository: profileRepository)

        searchUseCase.output = [sut]
        loadUseCase.output = [sut]
        addReferencesUseCase.output = [sut]
        addSectionUseCase.output = [sut]
        addRecordUseCase.output = [sut]
        sut.view = view

        return (
            sut,
            view,
            (profileRepository, referencesRepository),
            (searchUseCase, loadUseCase, addReferencesUseCase, addSectionUseCase, addRecordUseCase)
        )
    }

    private func makeDisco() -> DiscoSummary {
        DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))
    }

    private func makeProfile() -> DiscoProfile {
        DiscoProfile(disco: makeDisco(), references: [], section: [])
    }
}

private final class DiscoProfileViewSpy: DiscoProfileDisplayLogic {
    enum Message: Equatable {
        case startLoading
        case hideLoading
        case hideOverlays
        case showReferences([AlbumReferenceViewEntity])
        case showProfile(DiscoProfileViewEntity)
        case updateReferences([AlbumReferenceViewEntity])
        case updateSections([SectionViewEntity])
        case addingReferencesError(String, String)
        case addingSectionError(String, String)
        case loadingProfileError(String, String)
        case addingRecordsError(String, String)
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

    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        receivedMessages.append(.showReferences(references))
    }

    func showProfile(_ profile: DiscoProfileViewEntity) {
        receivedMessages.append(.showProfile(profile))
    }

    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        receivedMessages.append(.updateReferences(references))
    }

    func updateSections(_ sections: [SectionViewEntity]) {
        receivedMessages.append(.updateSections(sections))
    }

    func addingReferencesError(_ title: String, description: String) {
        receivedMessages.append(.addingReferencesError(title, description))
    }

    func addingSectionError(_ title: String, description: String) {
        receivedMessages.append(.addingSectionError(title, description))
    }

    func loadingProfileError(_ title: String, description: String) {
        receivedMessages.append(.loadingProfileError(title, description))
    }

    func addingRecordsError(_ title: String, description: String) {
        receivedMessages.append(.addingRecordsError(title, description))
    }
}
