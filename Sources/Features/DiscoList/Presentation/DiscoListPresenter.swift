import Foundation

protocol DiscoListPresentationLogic: AnyObject {
    func presentLoading()
    func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError)
}

final class DiscoListPresenter: DiscoListPresentationLogic {
    var view: DiscoListDisplayLogic?

    func presentLoading() {
        view?.startLoading()
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

extension DiscoListPresenter: GetDiscosUseCaseOutput {
    func successfullyLoadDiscos(_ discos: [DiscoSummary]) {
        view?.hideLoading()
        view?.showDiscos(discos.map(DiscoListViewEntity.init(from:)))
    }

    func errorWhileLoadingDiscos(_ error: Error) {
        view?.hideLoading()
        view?.loadDiscoError(
            DiscoListError.LoadDiscoError.errorTitle,
            error.localizedDescription
        )
    }
}
