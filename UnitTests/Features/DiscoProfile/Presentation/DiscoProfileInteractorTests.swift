import Foundation
import XCTest
@testable import Main

final class DiscoProfileInteractorTests: XCTestCase {
    func test_loadSearchProviders_presents_all_providers_with_default_selection() {
        let (sut, presenter, _, _, _, _, _) = makeSUT()
        let providers = ReferenceProvider.allCases.map(SearchReferenceViewEntity.init(from:))
        let selectedProvider = SearchReferenceViewEntity(from: .spotify)

        sut.loadSearchProviders()

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentSearchProviders(providers, selectedProvider)]
        )
    }

    func test_searchNewReferences_requests_loading_and_executes_useCase() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()

        sut.searchNewReferences(keywords: "any")

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [.search(.init(keywords: "any", pageSize: 10))]
        )
    }

    func test_searchNewReferences_onSuccess_presents_found_references() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let references = makeSearchOutput(references: [makeReference()])

        sut.searchNewReferences(keywords: "any")
        searchUseCase.completeSearch(with: .success(references))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentFoundReferences(references)]
        )
    }

    func test_searchNewReferences_onFailure_presents_error() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let error = NSError(domain: "search", code: 0, userInfo: [NSLocalizedDescriptionKey: "search"])

        sut.searchNewReferences(keywords: "any")
        searchUseCase.completeSearch(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentFindReferencesError(error.localizedDescription)]
        )
    }

    func test_selectReferenceProvider_resets_search_reloads_providers_and_uses_selected_provider_on_next_search() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let selectedProvider = SearchReferenceViewEntity(from: .lastFM)

        sut.searchNewReferences(keywords: "spotify")
        sut.selectReferenceProvider(selectedProvider)
        sut.searchNewReferences(keywords: "lastfm")

        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [
                .search(.init(keywords: "spotify", pageSize: 10)),
                .reset,
                .search(.init(keywords: "lastfm", pageSize: 10, provider: .lastFM))
            ]
        )
        XCTAssertEqual(
            presenter.receivedMessages,
            [
                .presentLoading,
                .presentSearchProviders(
                    ReferenceProvider.allCases.map(SearchReferenceViewEntity.init(from:)),
                    selectedProvider
                ),
                .presentLoading
            ]
        )
    }

    func test_selectReferenceProvider_doesNotChange_state_for_invalid_provider_id() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let invalidProvider = SearchReferenceViewEntity(id: 999, title: "Unknown", imagePath: "missing")

        sut.selectReferenceProvider(invalidProvider)
        sut.searchNewReferences(keywords: "any")

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading]
        )
        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [.search(.init(keywords: "any", pageSize: 10))]
        )
    }

    func test_loadMoreReferences_requests_next_page_without_presenting_global_loading() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let firstPage = makeSearchOutput(
            references: [makeReference(name: "A"), makeReference(name: "B")],
            hasMore: true
        )

        sut.searchNewReferences(keywords: "any")
        searchUseCase.completeSearch(with: .success(firstPage))
        sut.loadMoreReferences()

        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [
                .search(.init(keywords: "any", pageSize: 10)),
                .loadMore
            ]
        )
        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentFoundReferences(firstPage)]
        )
    }

    func test_loadMoreReferences_onSuccess_accumulates_results() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let firstPage = makeSearchOutput(
            references: [makeReference(name: "A"), makeReference(name: "B")],
            hasMore: true
        )
        let secondPage = makeSearchOutput(
            references: [makeReference(name: "C")],
            hasMore: false
        )

        sut.searchNewReferences(keywords: "any")
        searchUseCase.completeSearch(with: .success(firstPage))
        sut.loadMoreReferences()
        searchUseCase.completeLoadMore(with: .success(secondPage))

        XCTAssertEqual(
            presenter.receivedMessages,
            [
                .presentLoading,
                .presentFoundReferences(firstPage),
                .presentFoundReferences(
                    makeSearchOutput(
                        references: [
                            makeReference(name: "A"),
                            makeReference(name: "B"),
                            makeReference(name: "C")
                        ]
                    )
                )
            ]
        )
    }

    func test_loadMoreReferences_doesNotRequest_whenSearchIsInFlight() {
        let (sut, _, searchUseCase, _, _, _, _) = makeSUT()

        sut.searchNewReferences(keywords: "any")
        sut.loadMoreReferences()

        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [.search(.init(keywords: "any", pageSize: 10))]
        )
    }

    func test_loadMoreReferences_doesNotRequest_whenThereIsNoActiveSearch() {
        let (sut, _, searchUseCase, _, _, _, _) = makeSUT()

        sut.loadMoreReferences()

        XCTAssertEqual(searchUseCase.receivedMessages, [])
    }

    func test_resetReferenceSearch_prevents_loading_more_for_previous_query() {
        let (sut, _, searchUseCase, _, _, _, _) = makeSUT()

        sut.searchNewReferences(keywords: "any")
        sut.resetReferenceSearch()
        sut.loadMoreReferences()

        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [.search(.init(keywords: "any", pageSize: 10)), .reset]
        )
    }

    func test_searchNewReferences_ignores_stale_completion_from_previous_query() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let oldResult = makeSearchOutput(references: [makeReference(name: "Old")])
        let newResult = makeSearchOutput(references: [makeReference(name: "New")])

        sut.searchNewReferences(keywords: "old")
        sut.searchNewReferences(keywords: "new")
        searchUseCase.completeSearch(with: .success(oldResult))
        searchUseCase.completeSearch(with: .success(newResult), at: 1)

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoading, .presentFoundReferences(newResult)]
        )
    }

    func test_loadMoreReferences_onFailure_keeps_state_for_retry() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let firstPage = makeSearchOutput(
            references: [makeReference(name: "A"), makeReference(name: "B")],
            hasMore: true
        )
        let error = NSError(domain: "search-next-page", code: 0)

        sut.searchNewReferences(keywords: "any")
        searchUseCase.completeSearch(with: .success(firstPage))
        sut.loadMoreReferences()
        searchUseCase.completeLoadMore(with: .failure(error))
        sut.loadMoreReferences()

        XCTAssertEqual(
            presenter.receivedMessages,
            [
                .presentLoading,
                .presentFoundReferences(firstPage),
                .presentFindReferencesError(error.localizedDescription)
            ]
        )
        XCTAssertEqual(
            searchUseCase.receivedMessages,
            [
                .search(.init(keywords: "any", pageSize: 10)),
                .loadMore,
                .loadMore
            ]
        )
    }

    func test_loadProfile_requests_loading_and_executes_useCase() {
        let (sut, presenter, _, loadUseCase, _, _, _) = makeSUT()
        let disco = makeDisco()

        sut.loadProfile(for: disco)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(loadUseCase.receivedMessages, [.load(disco)])
    }

    func test_loadProfile_onSuccess_presents_profile() {
        let (sut, presenter, _, loadUseCase, _, _, _) = makeSUT()
        let profile = makeProfile()

        sut.loadProfile(for: profile.disco)
        loadUseCase.completeLoad(with: .success(profile))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadedProfile(profile)]
        )
    }

    func test_loadProfile_onFailure_presents_error() {
        let (sut, presenter, _, loadUseCase, _, _, _) = makeSUT()
        let disco = makeDisco()
        let error = NSError(domain: "load-profile", code: 0)

        sut.loadProfile(for: disco)
        loadUseCase.completeLoad(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentLoadProfileError(error.localizedDescription)]
        )
    }

    func test_addNewReferences_requests_loading_and_maps_entities() {
        let (sut, presenter, _, _, addReferencesUseCase, _, _) = makeSUT()
        let disco = makeDisco()
        let references = [
            AlbumReferenceViewEntity(
                name: "Album",
                artist: "Artist",
                releaseDate: "2024-01-01",
                coverImage: URL(string: "https://example.com/image")
            )
        ]

        sut.addNewReferences(for: disco, references: references)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(
            addReferencesUseCase.receivedMessages,
            [.addReferences(.init(disco: disco, newReferences: references.map { $0.mapToDomain() }))]
        )
    }

    func test_addNewReferences_onSuccess_presents_updated_profile() {
        let (sut, presenter, _, _, addReferencesUseCase, _, _) = makeSUT()
        let profile = makeProfile(references: [makeReference()])

        sut.addNewReferences(for: profile.disco, references: [])
        addReferencesUseCase.completeAddReferences(with: .success(profile))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentAddedReferences(profile)]
        )
    }

    func test_addNewReferences_onFailure_presents_error() {
        let (sut, presenter, _, _, addReferencesUseCase, _, _) = makeSUT()
        let disco = makeDisco()
        let error = NSError(domain: "add-reference", code: 0)

        sut.addNewReferences(for: disco, references: [])
        addReferencesUseCase.completeAddReferences(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentAddReferencesError(error.localizedDescription)]
        )
    }

    func test_addNewSection_rejects_empty_name() {
        let (sut, presenter, _, _, _, addSectionUseCase, _) = makeSUT()

        sut.addNewSection(
            for: makeDisco(),
            section: SectionViewEntity(identifer: "", records: [])
        )

        XCTAssertEqual(
            presenter.receivedMessages,
            [
                .presentLoading,
                .presentCreateSectionError(
                    DiscoProfileError.CreateSectionError.emptyName.localizedDescription
                )
            ]
        )
        XCTAssertEqual(addSectionUseCase.receivedMessages, [])
    }

    func test_addNewSection_executes_useCase_for_valid_input() throws {
        let (sut, presenter, _, _, _, addSectionUseCase, _) = makeSUT()
        let disco = makeDisco()
        let section = SectionViewEntity(identifer: "Verse", records: [])

        sut.addNewSection(for: disco, section: section)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(
            addSectionUseCase.receivedMessages,
            [.addSection(.init(disco: disco, section: try section.mapToDomain()))]
        )
    }

    func test_addNewSection_onSuccess_presents_updated_profile() throws {
        let (sut, presenter, _, _, _, addSectionUseCase, _) = makeSUT()
        let profile = makeProfile(sections: [try Section(identifer: "Verse", records: [])])

        sut.addNewSection(
            for: profile.disco,
            section: SectionViewEntity(identifer: "Verse", records: [])
        )
        addSectionUseCase.completeAddSection(with: .success(profile))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentAddedSection(profile)]
        )
    }

    func test_addNewSection_onFailure_presents_error() {
        let (sut, presenter, _, _, _, addSectionUseCase, _) = makeSUT()
        let disco = makeDisco()
        let error = NSError(domain: "add-section", code: 0)

        sut.addNewSection(
            for: disco,
            section: SectionViewEntity(identifer: "Verse", records: [])
        )
        addSectionUseCase.completeAddSection(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentAddSectionError(error.localizedDescription)]
        )
    }

    func test_addNewRecord_executes_useCase() throws {
        let (sut, presenter, _, _, _, _, addRecordUseCase) = makeSUT()
        let disco = makeDisco()
        let section = SectionViewEntity(
            identifer: "Verse",
            records: [.init(tag: .bass, audio: URL(string: "https://example.com/audio")!)]
        )

        sut.addNewRecord(in: disco, to: section)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(
            addRecordUseCase.receivedMessages,
            [.addRecord(.init(disco: disco, section: try section.mapToDomain()))]
        )
    }

    func test_addNewRecord_onSuccess_presents_updated_profile() throws {
        let (sut, presenter, _, _, _, _, addRecordUseCase) = makeSUT()
        let profile = makeProfile(sections: [try Section(identifer: "Verse", records: [])])

        sut.addNewRecord(
            in: profile.disco,
            to: SectionViewEntity(identifer: "Verse", records: [])
        )
        addRecordUseCase.completeAddRecord(with: .success(profile))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentAddedRecord(profile)]
        )
    }

    func test_addNewRecord_onFailure_presents_error() {
        let (sut, presenter, _, _, _, _, addRecordUseCase) = makeSUT()
        let disco = makeDisco()
        let error = NSError(domain: "add-record", code: 0)

        sut.addNewRecord(
            in: disco,
            to: SectionViewEntity(identifer: "Verse", records: [])
        )
        addRecordUseCase.completeAddRecord(with: .failure(error))

        XCTAssertEqual(
            presenter.receivedMessages,
            [.presentLoading, .presentAddRecordError(error.localizedDescription)]
        )
    }
}

extension DiscoProfileInteractorTests {
    typealias SutAndDoubles = (
        sut: DiscoProfileInteractor,
        presenter: DiscoProfilePresenterSpy,
        searchUseCase: SearchReferencesUseCaseSpy,
        loadUseCase: GetDiscoProfileUseCaseSpy,
        addReferencesUseCase: AddDiscoNewReferenceUseCaseSpy,
        addSectionUseCase: AddNewSectionToDiscoUseCaseSpy,
        addRecordUseCase: AddNewRecordToSessionUseCaseSpy
    )

    private func makeSUT() -> SutAndDoubles {
        let searchUseCase = SearchReferencesUseCaseSpy()
        let loadUseCase = GetDiscoProfileUseCaseSpy()
        let addReferencesUseCase = AddDiscoNewReferenceUseCaseSpy()
        let addSectionUseCase = AddNewSectionToDiscoUseCaseSpy()
        let addRecordUseCase = AddNewRecordToSessionUseCaseSpy()
        let presenter = DiscoProfilePresenterSpy()

        let sut = DiscoProfileInteractor(
            searchReferencesUseCase: searchUseCase,
            getDiscoProfileUseCase: loadUseCase,
            addDiscoNewReferenceUseCase: addReferencesUseCase,
            addNewSectionToDiscoUseCase: addSectionUseCase,
            addNewRecordToSessionUseCase: addRecordUseCase
        )
        sut.presenter = presenter
        return (
            sut,
            presenter,
            searchUseCase,
            loadUseCase,
            addReferencesUseCase,
            addSectionUseCase,
            addRecordUseCase
        )
    }

    private func makeDisco() -> DiscoSummary {
        DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))
    }

    private func makeReference(name: String = "Album") -> AlbumReference {
        AlbumReference(
            name: name,
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

    private func makeSearchOutput(
        references: [AlbumReference] = [],
        hasMore: Bool = false
    ) -> SearchReferencesPage {
        SearchReferencesPage(
            references: references,
            hasMore: hasMore
        )
    }
}
