//
//  DiscoProfileInteractorTests.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import XCTest
import Domain
@testable import Presentation

final class DiscoProfileInteractorTests: XCTestCase {
    func test_searchNewReferences_should_call_loading_on_presenter() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        sut.searchNewReferences(keywords: "any")
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    
    func test_searchNewReferences_should_call_use_case_correctly() {
        let (sut, (_, _, referenceServiceSpy)) = makeSUT()
        let inputedKeywords = "any"
        sut.searchNewReferences(keywords: inputedKeywords)
        referenceServiceSpy.loadReferencesCompletion?(.success([]))
        
        XCTAssertEqual(
            referenceServiceSpy.receivedMessages,
            [.loadReferences(inputedKeywords)]
        )
    }
    
    func test_loadProfile_should_call_loading_on_presenter() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        sut.loadProfile(for: .init(id: UUID(), name: "any", coverImage: Data()))
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    
    func test_loadProfile_should_call_use_case_correctly() {
        let (sut, (_, discoServiceSpy, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(id: UUID(), name: "any", coverImage: Data())
        let expectedProfile: DiscoProfile = .init(disco: inputedEntity.mapToDomain(), references: [], section: [])
        sut.loadProfile(for: inputedEntity)
        discoServiceSpy.loadProfileCompletion?(.success(expectedProfile))
        
        XCTAssertEqual(
            discoServiceSpy.receivedMessages,
            [.loadProfile(inputedEntity.mapToDomain())]
        )
    }
    
    func test_addNewReferences_should_call_loading_on_presenter() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        sut.addNewReferences(for: inputedEntity, references: [])
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    
    func test_addNewReferences_should_call_use_case_correctly() {
        let (sut, (_, discoServiceSpy, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        let inputedReferences = [AlbumReferenceViewEntity(name: "", artist: "", releaseDate: "", coverImage: nil)]
        let expectedReferences = inputedReferences.map { $0.mapToDomain() }
        
        let inputedProfile: DiscoProfile = .init(
            disco: inputedEntity.mapToDomain(),
            references: expectedReferences,
            section: []
        )
        sut.addNewReferences(for: inputedEntity, references: inputedReferences)
        
        discoServiceSpy.updateDiscoReferencesCompletion?(.success(inputedProfile))
        XCTAssertEqual(
            discoServiceSpy.receivedMessages,
            [
                .updateDiscoReferences(
                    inputedEntity.mapToDomain(),
                    expectedReferences
                )
            ]
        )
    }
    
    func test_addNewSection_should_call_loading_on_presenter() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        let inputedSection: SectionViewEntity = .init(
            identifer: "any",
            records: []
        )
        sut.addNewSection(for: inputedEntity, section: inputedSection)
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    
    func test_addNewSection_should_call_error_on_presenter_when_section_invalid() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        let inputedSection: SectionViewEntity = .init(
            identifer: "",
            records: []
        )
        sut.addNewSection(for: inputedEntity, section: inputedSection)
        XCTAssertEqual(
            presenterSpy.receivedMessages,
            [
                .presentCreateSectionError(.emptyName)
            ]
        )
    }
    
    func test_addNewSection_when_valid_section_should_call_use_case_correctly() {
        let (sut, (_, discoServiceSpy, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        let inputedSection: SectionViewEntity = .init(
            identifer: "any",
            records: []
        )
        sut.addNewSection(for: inputedEntity, section: inputedSection)
        discoServiceSpy.addNewSectionCompletion?(
            .success(
                .init(
                    disco: inputedEntity.mapToDomain(),
                    references: [],
                    section: [inputedSection.mapToDomain()]
                )
            )
        )
        XCTAssertEqual(
            discoServiceSpy.receivedMessages,
            [
                .addNewSection(
                    inputedEntity.mapToDomain(),
                    inputedSection.mapToDomain()
                )
            ]
        )
    }
    
    func test_addNewRecord_should_call_loading_on_presenter() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        let inputedSection: SectionViewEntity = .init(
            identifer: "any",
            records: []
        )
        sut.addNewRecord(in: inputedEntity, to: inputedSection)
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    func test_addNewRecord_should_call_use_case_correctly() {
        let (sut, (_, discoServiceSpy, _)) = makeSUT()
        let inputedEntity: DiscoListViewEntity = .init(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        let inputedSection: SectionViewEntity = .init(
            identifer: "any",
            records: []
        )
        sut.addNewRecord(in: inputedEntity, to: inputedSection)
        discoServiceSpy.addNewRecordCompletion?(
            .success(
                .init(
                    disco: inputedEntity.mapToDomain(),
                    references: [],
                    section: [inputedSection.mapToDomain()]
                )
            )
        )
        XCTAssertEqual(
            discoServiceSpy.receivedMessages,
            [
                .addNewRecord(
                    inputedEntity.mapToDomain(),
                    inputedSection.mapToDomain()
                )
            ]
        )
    }
}

extension DiscoProfileInteractorTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoProfileInteractor,
        doubles:(
            presenterSpy: DiscoProfilePresenterSpy,
            discoServiceSpy: DiscoServiceSpy,
            referencesServiceSpy: ReferenceServiceSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let discoServiceSpy = DiscoServiceSpy()
        let referencesServiceSpy = ReferenceServiceSpy()
        let presentationSpy = DiscoProfilePresenterSpy()
        
        let searchUseCase = SearchReferencesUseCase(service: referencesServiceSpy)
        let getDiscoUseCase = GetDiscoProfileUseCase(service: discoServiceSpy)
        let addDiscoNewRefUseCase = AddDiscoNewReferenceUseCase(service: discoServiceSpy)
        let addNewSectionToDiscoUseCase = AddNewSectionToDiscoUseCase(service: discoServiceSpy)
        let addNewRecordToSessionUseCase = AddNewRecordToSessionUseCase(service: discoServiceSpy)
    
        
        let sut = DiscoProfileInteractor(
            searchReferencesUseCase: searchUseCase,
            getDiscoProfileUseCase: getDiscoUseCase,
            addDiscoNewReferenceUseCase: addDiscoNewRefUseCase,
            addNewSectionToDiscoUseCase: addNewSectionToDiscoUseCase,
            addNewRecordToSessionUseCase: addNewRecordToSessionUseCase
        )
        
        sut.presenter = presentationSpy
        
        return (sut, (presentationSpy, discoServiceSpy, referencesServiceSpy))
    }
}
