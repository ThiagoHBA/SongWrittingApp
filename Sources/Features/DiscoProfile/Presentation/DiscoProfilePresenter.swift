import Foundation

protocol DiscoProfilePresentationLogic: AnyObject {
    func presentLoading()
    func presentCreateSectionError(_ error: DiscoProfileError.CreateSectionError)
}

final class DiscoProfilePresenter: DiscoProfilePresentationLogic {
    var view: DiscoProfileDisplayLogic?

    func presentLoading() {
        view?.startLoading()
    }

    func presentCreateSectionError(_ error: DiscoProfileError.CreateSectionError) {
        view?.hideOverlays { [weak self] in
            self?.view?.addingSectionError(
                DiscoProfileError.CreateSectionError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}

extension DiscoProfilePresenter: SearchReferencesUseCaseOutput {
    func didFindedReferences(_ data: [AlbumReference]) {
        view?.hideLoading()
        view?.showReferences(data.map(AlbumReferenceViewEntity.init(from:)))
    }

    func errorWhileFindingReferences(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingReferencesError(
                DiscoProfileError.LoadReferencesError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}

extension DiscoProfilePresenter: GetDiscoProfileUseCaseOutput {
    func succesfullyLoadProfile(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.showProfile(DiscoProfileViewEntity(from: profile))
    }

    func errorWhileLoadingProfile(_ error: Error) {
        view?.hideLoading()
        view?.loadingProfileError(
            DiscoProfileError.LoadingProfileError.errorTitle,
            description: error.localizedDescription
        )
    }
}

extension DiscoProfilePresenter: AddDiscoNewReferenceUseCaseOutput {
    func successfullyAddNewReferences(to disco: DiscoSummary, references: [AlbumReference]) {
        view?.hideLoading()
        view?.updateReferences(references.map(AlbumReferenceViewEntity.init(from:)))
    }

    func errorWhileAddingNewReferences(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingReferencesError(
                DiscoProfileError.LoadReferencesError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}

extension DiscoProfilePresenter: AddNewSectionToDiscoUseCaseOutput {
    func successfullyAddedSectionToDisco(_ disco: DiscoProfile) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.updateSections(disco.section.map(SectionViewEntity.init(from:)))
        }
    }

    func errorWhileAddingSectionToDisco(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingSectionError(
                DiscoProfileError.AddingSectionsError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}

extension DiscoProfilePresenter: AddNewRecordToSessionUseCaseOutput {
    func successfullyAddedNewRecordToSection(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.updateSections(profile.section.map(SectionViewEntity.init(from:)))
        }
    }

    func errorWhileAddingNewRecordToSection(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingRecordsError(
                DiscoProfileError.AddingRecordsError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}
