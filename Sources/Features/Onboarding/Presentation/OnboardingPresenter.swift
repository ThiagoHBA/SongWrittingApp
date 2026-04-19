import Foundation

protocol OnboardingPresentationLogic: AnyObject {
    func presentPages()
}

final class OnboardingPresenter: OnboardingPresentationLogic {
    var view: OnboardingDisplayLogic?

    func presentPages() {
        view?.showPages([
            OnboardingPageViewEntity(
                title: "Bem vindo ao SongWrittingApp",
                message: "Agrupe suas músicas, organize elas em seções e busque por referências",
                imageSource: .asset(name: "onboarding_app_icon")
            ),
            OnboardingPageViewEntity(
                title: "Em breve",
                message: "Conteúdo desta etapa será adicionado futuramente.",
                imageSource: .system(name: "music.note.list")
            ),
            OnboardingPageViewEntity(
                title: "Em breve",
                message: "Conteúdo desta etapa será adicionado futuramente.",
                imageSource: .system(name: "magnifyingglass")
            )
        ])
    }
}
