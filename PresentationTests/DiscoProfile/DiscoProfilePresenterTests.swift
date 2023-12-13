//
//  DiscoProfilePresenterTests.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import XCTest
import Domain
@testable import Presentation

final class DiscoProfilePresenterTests: XCTestCase {
    func test_presentLoading_should_call_view_correctly() {
        let (sut, (viewSpy, _, _, (_, _, _, _, _))) = makeSUT()
        sut.presentLoading()
        XCTAssertEqual(viewSpy.receivedMessages, [.startLoading])
    }

    func test_presentCreateSectionError_should_call_view_correctly() {
        let (sut, (viewSpy, _, _, (_, _, _, _, _))) = makeSUT()
        sut.presentCreateSectionError(.emptyName)
        viewSpy.hideOverlaysCompletion?()

        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideOverlays,
                    .addingSectionError(
                        DiscoProfileError.CreateSectionError.errorTitle,
                        DiscoProfileError.CreateSectionError.emptyName.localizedDescription
                    )
            ]
        )
    }

    func test_when_searchDiscoNewReferenceUseCase_called_with_success_should_call_view_correctly() {
        let (sut, (viewSpy, _, serviceSpy, (refUseCase, _, _, _, _))) = makeSUT()
        refUseCase.output = [sut]
        refUseCase.input = .init(keywords: "any")
        refUseCase.execute()

        serviceSpy.loadReferencesCompletion?(.success([]))

        XCTAssertEqual(viewSpy.receivedMessages, [.hideLoading, .showReferences([])])
    }

    func test_when_searchDiscoNewReferenceUseCase_called_with_error_should_call_view_correctly() {
        let (sut, (viewSpy, _, serviceSpy, (refUseCase, _, _, _, _))) = makeSUT()
        let inputError = NSError(domain: "any", code: 0)
        refUseCase.output = [sut]
        refUseCase.input = .init(keywords: "any")
        refUseCase.execute()

        serviceSpy.loadReferencesCompletion?(.failure(inputError))
        viewSpy.hideOverlaysCompletion?()

        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingReferencesError(
                    DiscoProfileError.LoadReferencesError.errorTitle,
                    inputError.localizedDescription
                )
            ]
        )
    }

    func test_when_getDiscoProfileUseCase_called_with_success_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, getDiscoUseCase, _, _, _))) = makeSUT()
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let profileInput: DiscoProfileViewEntity = .init(
            disco: discoInput,
            references: [],
            section: []
        )
        getDiscoUseCase.output = [sut]
        getDiscoUseCase.input = .init(disco: discoInput.mapToDomain())
        getDiscoUseCase.execute()

        serviceSpy.loadProfileCompletion?(.success(profileInput.mapToDomain()))

        XCTAssertEqual(viewSpy.receivedMessages, [.hideLoading, .showProfile(profileInput)])
    }

    func test_when_getDiscoProfileUseCase_called_with_error_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, getDiscoUseCase, _, _, _))) = makeSUT()
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let inputError = NSError(domain: "any", code: 0)
        getDiscoUseCase.output = [sut]
        getDiscoUseCase.input = .init(disco: discoInput.mapToDomain())
        getDiscoUseCase.execute()

        serviceSpy.loadProfileCompletion?(.failure(inputError))

        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideLoading,
                .loadingProfileError(
                    DiscoProfileError.LoadingProfileError.errorTitle,
                    inputError.localizedDescription
                )
            ]
        )
    }

    func test_when_addDiscoNewReferenceUseCase_called_with_success_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, _, addReferenceUseCase, _, _))) = makeSUT()
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let profileInput: DiscoProfileViewEntity = .init(
            disco: discoInput,
            references: [],
            section: []
        )
        addReferenceUseCase.output = [sut]
        addReferenceUseCase.input = .init(disco: discoInput.mapToDomain(), newReferences: [])
        addReferenceUseCase.execute()

        serviceSpy.updateDiscoReferencesCompletion?(.success(profileInput.mapToDomain()))

        XCTAssertEqual(viewSpy.receivedMessages, [.hideLoading, .updateReferences([])])
    }

    func test_when_addDiscoNewReferenceUseCase_called_with_error_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, _, addReferenceUseCase, _, _))) = makeSUT()
        let inputError = NSError(domain: "any", code: 0)
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        addReferenceUseCase.output = [sut]
        addReferenceUseCase.input = .init(disco: discoInput.mapToDomain(), newReferences: [])
        addReferenceUseCase.execute()

        serviceSpy.updateDiscoReferencesCompletion?(.failure(inputError))
        viewSpy.hideOverlaysCompletion?()

        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingReferencesError(
                    DiscoProfileError.LoadReferencesError.errorTitle,
                    inputError.localizedDescription
                )
            ]
        )
    }

    func test_when_addNewSectionToDiscoUseCase_called_with_success_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, _, _, addNewSectionUseCase, _))) = makeSUT()
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let sectionInput: SectionViewEntity = .init(identifer: "any", records: [])
        addNewSectionUseCase.output = [sut]
        addNewSectionUseCase.input = .init(
            disco: discoInput.mapToDomain(),
            section: sectionInput.mapToDomain()
        )
        addNewSectionUseCase.execute()

        serviceSpy.addNewSectionCompletion?(
            .success(
                .init(
                    disco: discoInput.mapToDomain(),
                    references: [],
                    section: [sectionInput.mapToDomain()]
                )
            )
        )
        viewSpy.hideOverlaysCompletion?()

        XCTAssertEqual(
            viewSpy.receivedMessages, [.hideLoading, .hideOverlays, .updateSections([sectionInput])]
        )
    }

    func test_when_addNewSectionToDiscoUseCase_called_with_error_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, _, _, addNewSectionUseCase, _))) = makeSUT()
        let inputError = NSError(domain: "any", code: 0)
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let sectionInput: SectionViewEntity = .init(identifer: "any", records: [])

        addNewSectionUseCase.output = [sut]
        addNewSectionUseCase.input = .init(
            disco: discoInput.mapToDomain(),
            section: sectionInput.mapToDomain()
        )
        addNewSectionUseCase.execute()

        serviceSpy.addNewSectionCompletion?(.failure(inputError))
        viewSpy.hideOverlaysCompletion?()

        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingSectionError(
                    DiscoProfileError.AddingSectionsError.errorTitle,
                    inputError.localizedDescription)
            ]
        )
    }

    func test_when_addNewRecordToSessionUseCase_called_with_success_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, _, _, _, addRecordUseCase))) = makeSUT()
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let sectionInput: SectionViewEntity = .init(
            identifer: "any",
            records: [.init(tag: .bass, audio: URL(string: "https://www.any.com")!)]
        )
        addRecordUseCase.output = [sut]
        addRecordUseCase.input = .init(
            disco: discoInput.mapToDomain(),
            section: sectionInput.mapToDomain()
        )
        addRecordUseCase.execute()

        serviceSpy.addNewRecordCompletion?(
            .success(
                .init(
                    disco: discoInput.mapToDomain(),
                    references: [],
                    section: [sectionInput.mapToDomain()]
                )
            )
        )
        viewSpy.hideOverlaysCompletion?()
        XCTAssertEqual(
            viewSpy.receivedMessages,
            [.hideLoading, .hideOverlays, .updateSections([sectionInput])]
        )
    }

    func test_when_addNewRecordToSessionUseCase_called_with_error_should_call_view_correctly() {
        let (sut, (viewSpy, serviceSpy, _, (_, _, _, _, addRecordUseCase))) = makeSUT()
        let discoInput: DiscoListViewEntity = .init(id: UUID(), name: "", coverImage: Data())
        let inputError = NSError(domain: "any", code: 0)
        let sectionInput: SectionViewEntity = .init(
            identifer: "any",
            records: [.init(tag: .bass, audio: URL(string: "https://www.any.com")!)]
        )
        addRecordUseCase.output = [sut]
        addRecordUseCase.input = .init(
            disco: discoInput.mapToDomain(),
            section: sectionInput.mapToDomain()
        )
        addRecordUseCase.execute()

        serviceSpy.addNewRecordCompletion?(.failure(inputError))
        viewSpy.hideOverlaysCompletion?()

        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideLoading,
                .hideOverlays,
                .addingRecordsError(
                    DiscoProfileError.AddingRecordsError.errorTitle,
                    inputError.localizedDescription
                )
            ]
        )
    }
}

extension DiscoProfilePresenterTests: Testing {
    // swiftlint:disable large_tuple
    typealias SutAndDoubles = (
        sut: DiscoProfilePresenter,
        doubles: (
            viewSpy: DiscoProfileViewSpy,
            discoServiceSpy: DiscoServiceSpy,
            referenceServiceSpy: ReferenceServiceSpy,
            usecases: (
                SearchReferencesUseCase,
                GetDiscoProfileUseCase,
                AddDiscoNewReferenceUseCase,
                AddNewSectionToDiscoUseCase,
                AddNewRecordToSessionUseCase
            )
        )
    )

    func makeSUT() -> SutAndDoubles {
        let discoServiceSpy = DiscoServiceSpy()
        let referencesServiceSpy = ReferenceServiceSpy()

        let searchUseCase = SearchReferencesUseCase(service: referencesServiceSpy)
        let getDiscoUseCase = GetDiscoProfileUseCase(service: discoServiceSpy)
        let addDiscoNewRefUseCase = AddDiscoNewReferenceUseCase(service: discoServiceSpy)
        let addNewSectionToDiscoUseCase = AddNewSectionToDiscoUseCase(service: discoServiceSpy)
        let addNewRecordToSessionUseCase = AddNewRecordToSessionUseCase(service: discoServiceSpy)

        let viewSpy = DiscoProfileViewSpy()
        let sut = DiscoProfilePresenter()

        sut.view = viewSpy

        return (
            sut,
            (
                viewSpy,
                discoServiceSpy,
                referencesServiceSpy,
                (
                    searchUseCase,
                    getDiscoUseCase,
                    addDiscoNewRefUseCase,
                    addNewSectionToDiscoUseCase,
                    addNewRecordToSessionUseCase
                )
            )
        )
    }
    // swiftlint:enable large_tuple
}
