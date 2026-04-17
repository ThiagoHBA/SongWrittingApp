import Foundation

protocol DiscoListPresentationLogic: AnyObject {
    func presentLoading()
    func presentLoadedDiscos(_ discos: [DiscoSummary])
    func presentLoadDiscoError(_ error: Error)
    func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError)
}

final class DiscoListPresenter: DiscoListPresentationLogic {
    var view: DiscoListDisplayLogic?

    func presentLoading() {
        view?.startLoading()
    }

    func presentLoadedDiscos(_ discos: [DiscoSummary]) {
        view?.hideLoading()
        view?.showDiscos(discos.map(DiscoListViewEntity.init(from:)))
    }

    func presentLoadDiscoError(_ error: Error) {
        view?.hideLoading()
        view?.loadDiscoError(
            DiscoListError.LoadDiscoError.errorTitle,
            error.localizedDescription
        )
    }

    func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError) {
        view?.hideOverlays { [weak self] in
            self?.view?.createDiscoError(
                DiscoListError.CreateDiscoError.errorTitle,
                error.localizedDescription
            )
        }
    }
}

extension DiscoListPresenter: CreateNewDiscoUseCaseOutput {
    func successfullyCreateDisco(_ disco: DiscoSummary) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.showNewDisco(DiscoListViewEntity(from: disco))
        }
    }

    func errorWhileCreatingDisco(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.createDiscoError(
                DiscoListError.CreateDiscoError.errorTitle,
                error.localizedDescription
            )
        }
    }
}
