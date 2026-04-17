import Foundation

protocol DiscoProfilePresentationLogic: AnyObject {
    func presentLoading()
    func presentFoundReferences(_ references: [AlbumReference])
    func presentFindReferencesError(_ error: Error)
    func presentLoadedProfile(_ profile: DiscoProfile)
    func presentLoadProfileError(_ error: Error)
    func presentAddedReferences(_ profile: DiscoProfile)
    func presentAddReferencesError(_ error: Error)
    func presentAddedSection(_ profile: DiscoProfile)
    func presentAddSectionError(_ error: Error)
    func presentAddedRecord(_ profile: DiscoProfile)
    func presentAddRecordError(_ error: Error)
    func presentCreateSectionError(_ error: Error)
}

final class DiscoProfilePresenter: DiscoProfilePresentationLogic {
    var view: DiscoProfileDisplayLogic?

    func presentLoading() {
        view?.startLoading()
    }

    func presentCreateSectionError(_ error: Error) {
        view?.hideOverlays { [weak self] in
            self?.view?.addingSectionError(
                DiscoProfileError.CreateSectionError.errorTitle,
                description: error.localizedDescription
            )
        }
    }

    func presentFoundReferences(_ references: [AlbumReference]) {
        view?.hideLoading()
        view?.showReferences(references.map(AlbumReferenceViewEntity.init(from:)))
    }

    func presentFindReferencesError(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingReferencesError(
                DiscoProfileError.LoadReferencesError.errorTitle,
                description: error.localizedDescription
            )
        }
    }

    func presentLoadedProfile(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.showProfile(DiscoProfileViewEntity(from: profile))
    }

    func presentLoadProfileError(_ error: Error) {
        view?.hideLoading()
        view?.loadingProfileError(
            DiscoProfileError.LoadingProfileError.errorTitle,
            description: error.localizedDescription
        )
    }

    func presentAddedReferences(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.updateReferences(profile.references.map(AlbumReferenceViewEntity.init(from:)))
    }

    func presentAddReferencesError(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingReferencesError(
                DiscoProfileError.LoadReferencesError.errorTitle,
                description: error.localizedDescription
            )
        }
    }

    func presentAddedSection(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.updateSections(profile.section.map(SectionViewEntity.init(from:)))
        }
    }

    func presentAddSectionError(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingSectionError(
                DiscoProfileError.AddingSectionsError.errorTitle,
                description: error.localizedDescription
            )
        }
    }

    func presentAddedRecord(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.updateSections(profile.section.map(SectionViewEntity.init(from:)))
        }
    }

    func presentAddRecordError(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.addingRecordsError(
                DiscoProfileError.AddingRecordsError.errorTitle,
                description: error.localizedDescription
            )
        }
    }
}
