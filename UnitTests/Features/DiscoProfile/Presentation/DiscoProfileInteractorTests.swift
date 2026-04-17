import Foundation
import XCTest
@testable import Main

final class DiscoProfileInteractorTests: XCTestCase {
    func test_searchNewReferences_requests_loading_and_executes_useCase() {
        let (sut, presenter, profileRepository, referencesRepository) = makeSUT()

        sut.searchNewReferences(keywords: "any")

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(profileRepository.receivedMessages, [])
        XCTAssertEqual(referencesRepository.receivedMessages, [.searchReferences("any")])
    }

    func test_loadProfile_requests_loading_and_profile_repository() {
        let (sut, presenter, profileRepository, _) = makeSUT()
        let disco = makeDisco()

        sut.loadProfile(for: disco)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(profileRepository.receivedMessages, [.loadProfile(disco)])
    }

    func test_addNewReferences_requests_loading_and_maps_entities() {
        let (sut, presenter, profileRepository, _) = makeSUT()
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
            profileRepository.receivedMessages,
            [.addReferences(disco, references.map { $0.mapToDomain() })]
        )
    }

    func test_addNewSection_rejects_empty_name() {
        let (sut, presenter, profileRepository, _) = makeSUT()

        sut.addNewSection(
            for: makeDisco(),
            section: SectionViewEntity(identifer: "", records: [])
        )

        XCTAssertEqual(presenter.receivedMessages, [.presentCreateSectionError(.emptyName)])
        XCTAssertEqual(profileRepository.receivedMessages, [])
    }

    func test_addNewSection_executes_useCase_for_valid_input() {
        let (sut, presenter, profileRepository, _) = makeSUT()
        let disco = makeDisco()
        let section = SectionViewEntity(identifer: "Verse", records: [])

        sut.addNewSection(for: disco, section: section)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(profileRepository.receivedMessages, [.addSection(disco, section.mapToDomain())])
    }

    func test_addNewRecord_executes_useCase() {
        let (sut, presenter, profileRepository, _) = makeSUT()
        let disco = makeDisco()
        let section = SectionViewEntity(
            identifer: "Verse",
            records: [.init(tag: .bass, audio: URL(string: "https://example.com/audio")!)]
        )

        sut.addNewRecord(in: disco, to: section)

        XCTAssertEqual(presenter.receivedMessages, [.presentLoading])
        XCTAssertEqual(profileRepository.receivedMessages, [.addRecord(disco, section.mapToDomain())])
    }

    private func makeSUT() -> (
        sut: DiscoProfileInteractor,
        presenter: DiscoProfilePresenterSpy,
        profileRepository: DiscoProfileRepositorySpy,
        referencesRepository: ReferenceSearchRepositorySpy
    ) {
        let profileRepository = DiscoProfileRepositorySpy()
        let referencesRepository = ReferenceSearchRepositorySpy()
        let presenter = DiscoProfilePresenterSpy()

        let sut = DiscoProfileInteractor(
            searchReferencesUseCase: SearchReferencesUseCase(repository: referencesRepository),
            getDiscoProfileUseCase: GetDiscoProfileUseCase(repository: profileRepository),
            addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase(repository: profileRepository),
            addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase(repository: profileRepository),
            addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase(repository: profileRepository)
        )
        sut.presenter = presenter
        return (sut, presenter, profileRepository, referencesRepository)
    }

    private func makeDisco() -> DiscoSummary {
        DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))
    }
}

private final class DiscoProfilePresenterSpy: DiscoProfilePresentationLogic {
    enum Message: Equatable {
        case presentLoading
        case presentCreateSectionError(DiscoProfileError.CreateSectionError)
    }

    private(set) var receivedMessages: [Message] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentCreateSectionError(_ error: DiscoProfileError.CreateSectionError) {
        receivedMessages.append(.presentCreateSectionError(error))
    }
}

final class DiscoProfileRepositorySpy: DiscoProfileRepository {
    enum Message: Equatable {
        case loadProfile(DiscoSummary)
        case addReferences(DiscoSummary, [AlbumReference])
        case addSection(DiscoSummary, Section)
        case addRecord(DiscoSummary, Section)
    }

    private(set) var receivedMessages: [Message] = []

    var loadProfileCompletion: ((Result<DiscoProfile, Error>) -> Void)?
    var addReferencesCompletion: ((Result<DiscoProfile, Error>) -> Void)?
    var addSectionCompletion: ((Result<DiscoProfile, Error>) -> Void)?
    var addRecordCompletion: ((Result<DiscoProfile, Error>) -> Void)?

    func loadProfile(
        for disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        receivedMessages.append(.loadProfile(disco))
        loadProfileCompletion = completion
    }

    func addReferences(
        _ references: [AlbumReference],
        to disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        receivedMessages.append(.addReferences(disco, references))
        addReferencesCompletion = completion
    }

    func addSection(
        _ section: Section,
        to disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        receivedMessages.append(.addSection(disco, section))
        addSectionCompletion = completion
    }

    func addRecord(
        in disco: DiscoSummary,
        to section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        receivedMessages.append(.addRecord(disco, section))
        addRecordCompletion = completion
    }
}

final class ReferenceSearchRepositorySpy: ReferenceSearchRepository {
    enum Message: Equatable {
        case searchReferences(String)
    }

    private(set) var receivedMessages: [Message] = []
    var searchReferencesCompletion: ((Result<[AlbumReference], Error>) -> Void)?

    func searchReferences(
        matching keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    ) {
        receivedMessages.append(.searchReferences(keywords))
        searchReferencesCompletion = completion
    }
}
