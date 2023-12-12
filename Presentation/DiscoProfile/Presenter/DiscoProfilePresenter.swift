//
//  DiscoProfilePresenter.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public final class DiscoProfilePresenter: DiscoProfilePresentationLogic {
    public var view: DiscoProfileDisplayLogic?
    
    public init() {}

    public func presentLoading() {
        view?.startLoading()
    }
    
    public func presentCreateSectionError(_ error: DiscoProfileError.CreateSectionError) {
        view?.hideOverlays { [weak self] in
            self?.view?.addingSectionError(
                DiscoProfileError.CreateSectionError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}

extension DiscoProfilePresenter: SearchReferencesUseCaseOutput {
    public func didFindedReferences(_ data: [AlbumReference]) {
        view?.hideLoading()
        view?.showReferences(data.map { AlbumReferenceViewEntity(from: $0) })
    }
    
    public func errorWhileFindingReferences(_ error: Error) {
        view?.hideLoading()
        view?.addingReferencesError(
            DiscoProfileError.LoadReferencesError.errorTitle,
            description: error.localizedDescription
        )
    }
}

extension DiscoProfilePresenter: GetDiscoProfileUseCaseOutput {
    public func succesfullyLoadProfile(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.showProfile(DiscoProfileViewEntity(from: profile))
    }
    
    public func errorWhileLoadingProfile(_ error: Error) {
        view?.hideLoading()
        view?.loadingProfileError(
            DiscoProfileError.LoadingProfileError.errorTitle,
            description: error.localizedDescription
        )
    }
}

extension DiscoProfilePresenter: AddDiscoNewReferenceUseCaseOutput {
    public func successfullyAddNewReferences(to disco:Disco, references: [AlbumReference]) {
        view?.hideLoading()
        view?.updateReferences(references.map { AlbumReferenceViewEntity(from: $0) })
    }
    
    public func errorWhileAddingNewReferences(_ error: Error) {
        view?.hideLoading()
        view?.addingReferencesError(
            DiscoProfileError.LoadReferencesError.errorTitle,
            description: error.localizedDescription
        )
    }
}

extension DiscoProfilePresenter: AddNewSectionToDiscoUseCaseOutput {
    public func successfullyAddedSectionToDisco(_ disco: DiscoProfile) {
        view?.hideLoading()
        view?.hideOverlays(completion: { [weak self] in
            self?.view?.updateSections(disco.section.map { SectionViewEntity(from: $0)})
        })
    }
    
    public func errorWhileAddingSectionToDisco(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays(completion: { [weak self] in
            self?.view?.addingSectionError(
                DiscoProfileError.AddingSectionsError.errorTitle,
                description: error.localizedDescription
            )
        })
    }
}

extension DiscoProfilePresenter: AddNewRecordToSessionUseCaseOutput {
    public func successfullyAddedNewRecordToSection(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            guard let self = self else { return }
            view?.updateSections(profile.section.map { SectionViewEntity(from: $0) })
        }
    }
    
    public func errorWhileAddingNewRecordToSection(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            guard let self = self else { return }
            view?.addingRecordsError(
                DiscoProfileError.AddingRecordsError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}
