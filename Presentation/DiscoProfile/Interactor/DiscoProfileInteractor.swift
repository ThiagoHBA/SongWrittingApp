//
//  DiscoProfileInteractor.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public final class DiscoProfileInteractor: DiscoProfileBusinessRule {
    let searchReferencesUseCase: SearchReferencesUseCase
    let getDiscoProfileUseCase: GetDiscoProfileUseCase
    let addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase
    let addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase
    let addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase
    
    public var presenter: DiscoProfilePresentationLogic?
    
    public init(
        searchReferencesUseCase: SearchReferencesUseCase,
        getDiscoProfileUseCase: GetDiscoProfileUseCase,
        addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase,
        addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase,
        addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase
    ) {
        self.searchReferencesUseCase = searchReferencesUseCase
        self.getDiscoProfileUseCase = getDiscoProfileUseCase
        self.addDiscoNewReferenceUseCase = addDiscoNewReferenceUseCase
        self.addNewSectionToDiscoUseCase = addNewSectionToDiscoUseCase
        self.addNewRecordToSessionUseCase = addNewRecordToSessionUseCase
    }
    
    public func searchNewReferences(keywords: String) {
        presenter?.presentLoading()
        searchReferencesUseCase.input = .init(keywords: keywords)
        searchReferencesUseCase.execute()
    }
    
    public func loadProfile(for disco: DiscoListViewEntity) {
        presenter?.presentLoading()
        getDiscoProfileUseCase.input = .init(disco: disco.mapToDomain())
        getDiscoProfileUseCase.execute()
    }
    
    public func addNewReferences(
        for disco: DiscoListViewEntity,
        references: [AlbumReferenceViewEntity]
    ) {
        presenter?.presentLoading()
        addDiscoNewReferenceUseCase.input = .init(
            disco: disco.mapToDomain(),
            newReferences: references.map { $0.mapToDomain() }
        )
        addDiscoNewReferenceUseCase.execute()
    }
    
    public func addNewSection(for disco: DiscoListViewEntity, section: SectionViewEntity) {
        if !sectionIsValid(section.identifer) { return }
        presenter?.presentLoading()
        addNewSectionToDiscoUseCase.input = .init(
            disco: disco.mapToDomain(),
            section: section.mapToDomain()
        )
        addNewSectionToDiscoUseCase.execute()
    }
    
    public func addNewRecord(in disco: DiscoListViewEntity, to section: SectionViewEntity) {
        presenter?.presentLoading()
        addNewRecordToSessionUseCase.input = .init(
            disco: disco.mapToDomain(),
            section: section.mapToDomain()
        )
        addNewRecordToSessionUseCase.execute()
    }
}

// MARK: - Validations
extension DiscoProfileInteractor {
    private func sectionIsValid(_ name: String) -> Bool {
        if name == "" {
            presenter?.presentCreateSectionError(DiscoProfileError.CreateSectionError.emptyName)
            return false
        }
        return true
    }
}
