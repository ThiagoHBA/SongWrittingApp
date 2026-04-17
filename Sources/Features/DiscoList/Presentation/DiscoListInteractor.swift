import Foundation

protocol DiscoListBusinessLogic: AnyObject {
    func loadDiscos()
    func createDisco(name: String, image: Data)
    func showProfile(of disco: DiscoListViewEntity)
}

final class DiscoListInteractor: DiscoListBusinessLogic {
    var presenter: DiscoListPresentationLogic?
    var router: DiscoListRouting?

    private let createNewDiscoUseCase: CreateNewDiscoUseCase
    private let getDiscosUseCase: GetDiscosUseCase

    init(
        getDiscosUseCase: GetDiscosUseCase,
        createNewDiscoUseCase: CreateNewDiscoUseCase
    ) {
        self.getDiscosUseCase = getDiscosUseCase
        self.createNewDiscoUseCase = createNewDiscoUseCase
    }

    func loadDiscos() {
        presenter?.presentLoading()
        getDiscosUseCase.execute()
    }

    func createDisco(name: String, image: Data) {
        guard discoIsValid(name, image) else { return }

        presenter?.presentLoading()
        createNewDiscoUseCase.input = .init(name: name, image: image)
        createNewDiscoUseCase.execute()
    }

    func showProfile(of disco: DiscoListViewEntity) {
        router?.showProfile(of: disco.toSummary())
    }

    private func discoIsValid(_ name: String, _ image: Data) -> Bool {
        if name.isEmpty {
            presenter?.presentCreateDiscoError(.emptyName)
            return false
        }

        if image.isEmpty {
            presenter?.presentCreateDiscoError(.emptyImage)
            return false
        }

        return true
    }
}
