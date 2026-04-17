import Foundation
import XCTest
@testable import Main

final class DiscoProfileInteractorTests: XCTestCase {
    func test_searchNewReferences_requests_loading_and_executes_useCase() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()

        sut.searchNewReferences(keywords: "any")

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(searchUseCase.receivedMessages, [.search(.init("any"))])
    }

    func test_searchNewReferences_onSuccess_presents_found_references() {
        let (sut, presenter, searchUseCase, _, _, _, _) = makeSUT()
        let references = [makeReference()]

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

    private func makeSUT() -> (
        sut: DiscoProfileInteractor,
        presenter: DiscoProfilePresenterSpy,
        searchUseCase: SearchReferencesUseCaseSpy,
        loadUseCase: GetDiscoProfileUseCaseSpy,
        addReferencesUseCase: AddDiscoNewReferenceUseCaseSpy,
        addSectionUseCase: AddNewSectionToDiscoUseCaseSpy,
        addRecordUseCase: AddNewRecordToSessionUseCaseSpy
    ) {
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

private final class DiscoProfilePresenterSpy: DiscoProfilePresentationLogic {
    enum Message: Equatable {
        case presentLoading
        case presentFoundReferences([AlbumReference])
        case presentFindReferencesError(String)
        case presentLoadedProfile(DiscoProfile)
        case presentLoadProfileError(String)
        case presentAddedReferences(DiscoProfile)
        case presentAddReferencesError(String)
        case presentAddedSection(DiscoProfile)
        case presentAddSectionError(String)
        case presentAddedRecord(DiscoProfile)
        case presentAddRecordError(String)
        case presentCreateSectionError(String)
    }

    private(set) var receivedMessages: [Message] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentFoundReferences(_ references: [AlbumReference]) {
        receivedMessages.append(.presentFoundReferences(references))
    }

    func presentFindReferencesError(_ error: Error) {
        receivedMessages.append(.presentFindReferencesError(error.localizedDescription))
    }

    func presentLoadedProfile(_ profile: DiscoProfile) {
        receivedMessages.append(.presentLoadedProfile(profile))
    }

    func presentLoadProfileError(_ error: Error) {
        receivedMessages.append(.presentLoadProfileError(error.localizedDescription))
    }

    func presentAddedReferences(_ profile: DiscoProfile) {
        receivedMessages.append(.presentAddedReferences(profile))
    }

    func presentAddReferencesError(_ error: Error) {
        receivedMessages.append(.presentAddReferencesError(error.localizedDescription))
    }

    func presentAddedSection(_ profile: DiscoProfile) {
        receivedMessages.append(.presentAddedSection(profile))
    }

    func presentAddSectionError(_ error: Error) {
        receivedMessages.append(.presentAddSectionError(error.localizedDescription))
    }

    func presentAddedRecord(_ profile: DiscoProfile) {
        receivedMessages.append(.presentAddedRecord(profile))
    }

    func presentAddRecordError(_ error: Error) {
        receivedMessages.append(.presentAddRecordError(error.localizedDescription))
    }

    func presentCreateSectionError(_ error: Error) {
        receivedMessages.append(.presentCreateSectionError(error.localizedDescription))
    }
}

private final class SearchReferencesUseCaseSpy: SearchReferencesUseCase {
    enum Message: Equatable {
        case search(SearchReferencesUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<SearchReferencesUseCaseOutput, Error>) -> Void)?

    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.search(input))
        self.completion = completion
    }

    func completeSearch(with result: Result<SearchReferencesUseCaseOutput, Error>) {
        completion?(result)
    }
}

private final class GetDiscoProfileUseCaseSpy: GetDiscoProfileUseCase {
    enum Message: Equatable {
        case load(GetDiscoProfileUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<GetDiscoProfileUseCaseOutput, Error>) -> Void)?

    func load(
        _ input: GetDiscoProfileUseCaseInput,
        completion: @escaping (Result<GetDiscoProfileUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.load(input))
        self.completion = completion
    }

    func completeLoad(with result: Result<GetDiscoProfileUseCaseOutput, Error>) {
        completion?(result)
    }
}

private final class AddDiscoNewReferenceUseCaseSpy: AddDiscoNewReferenceUseCase {
    enum Message: Equatable {
        case addReferences(AddDiscoNewReferenceUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void)?

    func addReferences(
        _ input: AddDiscoNewReferenceUseCaseInput,
        completion: @escaping (Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addReferences(input))
        self.completion = completion
    }

    func completeAddReferences(with result: Result<AddDiscoNewReferenceUseCaseOutput, Error>) {
        completion?(result)
    }
}

private final class AddNewSectionToDiscoUseCaseSpy: AddNewSectionToDiscoUseCase {
    enum Message: Equatable {
        case addSection(AddNewSectionToDiscoUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void)?

    func addSection(
        _ input: AddNewSectionToDiscoUseCaseInput,
        completion: @escaping (Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addSection(input))
        self.completion = completion
    }

    func completeAddSection(with result: Result<AddNewSectionToDiscoUseCaseOutput, Error>) {
        completion?(result)
    }
}

private final class AddNewRecordToSessionUseCaseSpy: AddNewRecordToSessionUseCase {
    enum Message: Equatable {
        case addRecord(AddNewRecordToSessionUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void)?

    func addRecord(
        _ input: AddNewRecordToSessionUseCaseInput,
        completion: @escaping (Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addRecord(input))
        self.completion = completion
    }

    func completeAddRecord(with result: Result<AddNewRecordToSessionUseCaseOutput, Error>) {
        completion?(result)
    }
}
