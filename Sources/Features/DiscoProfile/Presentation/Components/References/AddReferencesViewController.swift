import UIKit

final class AddReferencesViewController: UIViewController, AlertPresentable {
    private var loadedReferences: [AlbumReferenceViewEntity] = [] {
        didSet {
            emptyStateLabel.isHidden = !loadedReferences.isEmpty
            resultLabel.isHidden = loadedReferences.isEmpty
        }
    }
    private var canLoadMore = false
    private var isLoadingNextPage = false {
        didSet { updateLoadingFooter() }
    }

    var selectedReferences: [AlbumReferenceViewEntity] = [] {
        didSet { updateSelectedReferenceItems(newItems: selectedReferences) }
    }

    var searchProviders: [SearchReferenceViewEntity] = [] {
        didSet {
            guard isViewLoaded else { return }
            updateProviderMenu()
        }
    }

    var selectedProvider: SearchReferenceViewEntity? {
        didSet {
            guard isViewLoaded else { return }
            updateProviderMenu()
        }
    }

    var searchReference: ((String) -> Void)?
    var selectReferenceProvider: ((SearchReferenceViewEntity) -> Void)?
    var loadMoreReferences: (() -> Void)?
    var clearSearch: (() -> Void)?
    var saveReferences: (([AlbumReferenceViewEntity]) -> Void)?

    private lazy var providerMenuButton = SWIconButton(
        symbolName: "line.3.horizontal.decrease.circle",
        accessibilityLabel: "Selecionar provedor de busca"
    )

    private lazy var saveButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "checkmark"),
        style: .plain,
        target: self,
        action: #selector(saveReferencesTapped)
    )

    private lazy var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Referências")
        navigationItem.rightBarButtonItem = saveButtonItem
        nav.items = [navigationItem]
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.tintColor = SWColor.Accent.primary
        return nav
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let resultLabel = SWTextLabel(style: .sectionTitle)

    private let referencesList: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SWReferenceSearchResultCell.self,
            forCellReuseIdentifier: SWReferenceSearchResultCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyStateLabel = SWMessageView()
    private let loadingFooterView = UIActivityIndicatorView(style: .medium)

    private lazy var selectedReferencesList: SWReferenceSelectionListView = {
        let view = SWReferenceSelectionListView()
        view.onChipTap = { [weak self] index in
            self?.removeAddedReference(at: index)
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    @objc private func saveReferencesTapped() {
        saveReferences?(selectedReferences)
    }

    func selectProvider(_ provider: SearchReferenceViewEntity) {
        guard selectedProvider != provider else { return }

        selectedProvider = provider
        loadedReferences = []
        canLoadMore = false
        stopLoadingMore()
        searchBar.text = nil
        referencesList.reloadData()
        clearSearch?()
        selectReferenceProvider?(provider)
    }

    private func removeAddedReference(at index: Int) {
        guard selectedReferences.indices.contains(index) else {
            return
        }
        selectedReferences.remove(at: index)
    }

    func updateReferenceItems(_ newItems: ReferenceSearchViewEntity) {
        loadedReferences = newItems.references
        canLoadMore = newItems.hasMore
        stopLoadingMore()
        referencesList.reloadData()
    }

    func stopLoadingMore() {
        isLoadingNextPage = false
    }

    private func updateSelectedReferenceItems(newItems: [AlbumReferenceViewEntity]) {
        selectedReferencesList.configure(
            items: newItems.map { SWReferenceSelectionChipContent(title: $0.name) }
        )
    }

    private func requestNextPageIfNeeded(for indexPath: IndexPath) {
        let thresholdIndex = max(loadedReferences.count - 3, 0)

        guard indexPath.row >= thresholdIndex,
              canLoadMore,
              !isLoadingNextPage,
              !(searchBar.text ?? "").isEmpty else {
            return
        }

        isLoadingNextPage = true
        loadMoreReferences?()
    }

    private func updateLoadingFooter() {
        guard isViewLoaded else { return }

        if isLoadingNextPage {
            loadingFooterView.startAnimating()
            referencesList.tableFooterView = loadingFooterView
            loadingFooterView.frame = CGRect(x: 0, y: 0, width: referencesList.bounds.width, height: 44)
            return
        }

        loadingFooterView.stopAnimating()
        referencesList.tableFooterView = UIView(frame: .zero)
    }

    private func updateProviderMenu() {
        let actions = searchProviders.map { provider in
            UIAction(
                title: provider.title,
                image: providerImage(for: provider),
                state: provider == selectedProvider ? .on : .off
            ) { [weak self] _ in
                self?.selectProvider(provider)
            }
        }

        providerMenuButton.menu = UIMenu(title: "Provedores", options: .displayInline, children: actions)
        providerMenuButton.showsMenuAsPrimaryAction = true
        providerMenuButton.isEnabled = !searchProviders.isEmpty
        providerMenuButton.accessibilityLabel = selectedProvider.map {
            "Provedor de busca: \($0.title)"
        } ?? "Selecionar provedor de busca"
    }
}

extension AddReferencesViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        referencesList.delegate = self
        referencesList.dataSource = self
        referencesList.backgroundColor = .clear
        referencesList.separatorStyle = .none
        referencesList.tableFooterView = UIView(frame: .zero)
        resultLabel.text = "Resultados"
        resultLabel.isHidden = true
        emptyStateLabel.configure(message: "Nenhuma referência por aqui!")
        updateProviderMenu()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: SWSize.navigationBarHeight),

            searchBar.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: SWSpacing.large),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xxxSmall + 2),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(SWSpacing.xxxSmall + 2)),
            searchBar.heightAnchor.constraint(equalToConstant: 36),

            providerMenuButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: SWSpacing.xSmall),
            providerMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),
            providerMenuButton.widthAnchor.constraint(equalToConstant: SWSize.iconButton),
            providerMenuButton.heightAnchor.constraint(equalToConstant: SWSize.iconButton),

            selectedReferencesList.topAnchor.constraint(equalTo: providerMenuButton.bottomAnchor, constant: SWSpacing.xSmall),
            selectedReferencesList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xSmall),
            selectedReferencesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedReferencesList.heightAnchor.constraint(equalToConstant: 36),

            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xSmall),
            resultLabel.topAnchor.constraint(equalTo: selectedReferencesList.bottomAnchor, constant: SWSpacing.large),

            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: SWSpacing.large),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -SWSpacing.large),

            referencesList.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: SWSpacing.xSmall),
            referencesList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            referencesList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            referencesList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(searchBar)
        view.addSubview(providerMenuButton)
        view.addSubview(referencesList)
        view.addSubview(selectedReferencesList)
        view.addSubview(navBar)
        view.addSubview(emptyStateLabel)
    }
}

private extension AddReferencesViewController {
    func providerImage(for provider: SearchReferenceViewEntity) -> UIImage? {
        UIImage(named: provider.imagePath)
    }
}

extension AddReferencesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        canLoadMore = false
        stopLoadingMore()

        if searchText.isEmpty {
            loadedReferences = []
            referencesList.reloadData()
            clearSearch?()
        } else {
            searchReference?(searchText)
        }
    }
}

extension AddReferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadedReferences.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SWReferenceSearchResultCell.height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SWReferenceSearchResultCell.identifier,
            for: indexPath
        ) as? SWReferenceSearchResultCell else {
            return UITableViewCell()
        }

        let reference = loadedReferences[indexPath.row]
        cell.configure(
            with: SWReferenceSearchResultContent(
                title: reference.name,
                subtitle: reference.artist,
                detail: reference.releaseDate,
                imageURL: reference.coverImage
            )
        )
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        requestNextPageIfNeeded(for: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = loadedReferences[indexPath.row]
        if selectedReferences.contains(selectedItem) { return }
        selectedReferences.append(selectedItem)
    }
}
