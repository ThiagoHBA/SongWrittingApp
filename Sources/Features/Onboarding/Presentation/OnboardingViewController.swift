import DesignSystem
import UIKit

protocol OnboardingDisplayLogic: AnyObject {
    func showPages(_ pages: [OnboardingPageViewEntity])
}

final class OnboardingViewController: UIViewController {
    private let interactor: OnboardingBusinessLogic
    private let pageViewController: UIPageViewController

    private var pages: [OnboardingPageViewEntity] = []
    private var pageControllers: [OnboardingPageContentViewController] = []
    private var currentPageIndex = 0 {
        didSet {
            pageControl.currentPage = currentPageIndex
            primaryButton.updateTitle(currentPageIndex == pageControllers.count - 1 ? "Começar" : "Próximo")
        }
    }

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pular", for: .normal)
        button.titleLabel?.font = SWTypography.button
        button.accessibilityLabel = "Pular onboarding"
        return button
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = SWColor.Accent.primary
        pageControl.pageIndicatorTintColor = SWColor.Accent.emphasisBackground
        pageControl.isUserInteractionEnabled = false
        pageControl.accessibilityIdentifier = "onboarding.page.control"
        return pageControl
    }()

    private let primaryButton: SWPrimaryButton = {
        let button = SWPrimaryButton(title: "Próximo")
        button.accessibilityLabel = "Ação principal onboarding"
        return button
    }()

    init(interactor: OnboardingBusinessLogic) {
        self.interactor = interactor
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadOnboarding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func skipButtonTapped() {
        interactor.skip()
    }

    @objc private func primaryButtonTapped() {
        guard !pageControllers.isEmpty else { return }

        if currentPageIndex == pageControllers.count - 1 {
            interactor.finish()
            return
        }

        showPage(at: currentPageIndex + 1)
    }
}

extension OnboardingViewController: OnboardingDisplayLogic {
    func showPages(_ pages: [OnboardingPageViewEntity]) {
        self.pages = pages
        pageControllers = pages.map(OnboardingPageContentViewController.init(page:))
        pageControl.numberOfPages = pageControllers.count
        currentPageIndex = 0

        guard let firstPageController = pageControllers.first else {
            return
        }

        pageViewController.setViewControllers(
            [firstPageController],
            direction: .forward,
            animated: false
        )
    }
}

extension OnboardingViewController: ViewCoding {
    func addViewInHierarchy() {
        addChild(pageViewController)
        view.addSubview(skipButton)
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        view.addSubview(primaryButton)
        pageViewController.didMove(toParent: self)
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: SWSpacing.small),
            skipButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -SWSpacing.large),

            pageViewController.view.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: SWSpacing.small),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: SWSpacing.small),
            pageControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            primaryButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: SWSpacing.large),
            primaryButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: SWSpacing.large),
            primaryButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -SWSpacing.large),
            primaryButton.heightAnchor.constraint(equalToConstant: SWSize.primaryButtonHeight),
            primaryButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -SWSpacing.large),

            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -SWSpacing.large)
        ])
    }

    func additionalConfiguration() {
        view.backgroundColor = SWColor.Background.screen
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.dataSource = self
        pageViewController.delegate = self
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageContentViewController,
              let index = pageControllers.firstIndex(where: { $0 === viewController }),
              index > 0 else {
            return nil
        }

        return pageControllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageContentViewController,
              let index = pageControllers.firstIndex(where: { $0 === viewController }),
              index < pageControllers.count - 1 else {
            return nil
        }

        return pageControllers[index + 1]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let visibleController = pageViewController.viewControllers?.first as? OnboardingPageContentViewController,
              let index = pageControllers.firstIndex(where: { $0 === visibleController }) else {
            return
        }

        currentPageIndex = index
    }
}

private extension OnboardingViewController {
    func showPage(at index: Int) {
        guard pageControllers.indices.contains(index) else { return }

        let controller = pageControllers[index]
        let direction: UIPageViewController.NavigationDirection = index > currentPageIndex ? .forward : .reverse

        pageViewController.setViewControllers(
            [controller],
            direction: direction,
            animated: true
        )
        currentPageIndex = index
    }
}
