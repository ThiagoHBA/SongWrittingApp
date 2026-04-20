import AVFAudio
import UIKit

protocol DiscoProfileDisplayLogic: AnyObject {
    func startLoading()
    func hideLoading()
    func hideOverlays(completion: (() -> Void)?)
    func showSearchProviders(_ providers: [SearchReferenceViewEntity], selectedProvider: SearchReferenceViewEntity)
    func showReferences(_ references: ReferenceSearchViewEntity)
    func showProfile(_ profile: DiscoProfileViewEntity)
    func updateReferences(_ references: [AlbumReferenceViewEntity])
    func updateSections(_ sections: [SectionViewEntity])
    func addingReferencesError(_ title: String, description: String)
    func addingSectionError(_ title: String, description: String)
    func loadingProfileError(_ title: String, description: String)
    func addingRecordsError(_ title: String, description: String)
    func discoNameUpdated(_ disco: DiscoSummary)
    func discoDeleted()
    func updatingDiscoError(_ title: String, description: String)
    func deletingDiscoError(_ title: String, description: String)
}

final class DiscoProfileViewController: UIViewController, AlertPresentable {
    private var discoProfile: DiscoProfileViewEntity? {
        didSet {
            updateEmptyStateVisibility()
            tableView.reloadData()
        }
    }

    private let interactor: DiscoProfileBusinessLogic
    private var disco: DiscoSummary
    private var searchProviders: [SearchReferenceViewEntity] = []
    private var selectedReferenceProvider: SearchReferenceViewEntity?

    private let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let projectName = SWTextLabel(style: .heroTitle, numberOfLines: 0)

    private lazy var referenceSection: SWReferenceSectionView = {
        let section = SWReferenceSectionView()
        section.onActionTap = { [weak self] in
            self?.addReferenceTapped()
        }
        return section
    }()

    private lazy var sectionHeaderView: SWHeaderActionView = {
        let view = SWHeaderActionView()
        view.configure(
            with: SWHeaderActionContent(
                title: "Seções",
                titleStyle: .sectionTitle,
                actionSymbolName: "plus",
                actionAccessibilityLabel: "Adicionar seção"
            )
        )
        view.onActionTap = { [weak self] in
            self?.addSectionTapped()
        }
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SWRecordListItemCell.self,
            forCellReuseIdentifier: SWRecordListItemCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyStateLabel = SWMessageView()

    private lazy var referenceViewController: AddReferencesViewController = {
        let sheet = AddReferencesViewController()
        sheet.searchProviders = searchProviders
        sheet.selectedProvider = selectedReferenceProvider
        sheet.searchReference = { [weak self] keywords in
            self?.interactor.searchNewReferences(keywords: keywords)
        }
        sheet.selectReferenceProvider = { [weak self] provider in
            guard let self else { return }
            self.selectedReferenceProvider = provider
            self.interactor.selectReferenceProvider(provider)
        }
        sheet.loadMoreReferences = { [weak self] in
            self?.interactor.loadMoreReferences()
        }
        sheet.clearSearch = { [weak self] in
            self?.interactor.resetReferenceSearch()
        }
        sheet.saveReferences = { [weak self] referencesToAdd in
            guard let self else { return }
            self.interactor.addNewReferences(for: self.disco, references: referencesToAdd)
        }
        sheet.sheetPresentationController?.detents = [.large()]
        return sheet
    }()

    private lazy var addNewSectionViewController: AddSectionViewController = {
        let sheet = AddSectionViewController()
        sheet.addSectionTapped = { [weak self] identifier in
            guard let self else { return }
            self.interactor.addNewSection(
                for: self.disco,
                section: SectionViewEntity(identifer: identifier, records: [])
            )
        }
        return sheet
    }()

    private lazy var editDiscoViewController: EditDiscoViewController = {
        let sheet = EditDiscoViewController()
        sheet.discoName = disco.name
        sheet.saveNameTapped = { [weak self] newName in
            guard let self else { return }
            self.interactor.updateDiscoName(disco: self.disco, newName: newName)
        }
        sheet.deleteDiscoTapped = { [weak self] in
            guard let self else { return }
            self.interactor.deleteDisco(self.disco)
        }
        return sheet
    }()

    init(disco: DiscoSummary, interactor: DiscoProfileBusinessLogic) {
        self.disco = disco
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        configureAudio()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(editDiscTapped)
        )
        interactor.loadSearchProviders()
        interactor.loadProfile(for: disco)
    }

    @objc private func editDiscTapped() {
        editDiscoViewController.discoName = disco.name
        editDiscoViewController.sheetPresentationController?.detents = [
            .custom { context in context.maximumDetentValue * 0.5 }
        ]
        present(editDiscoViewController, animated: true)
    }

    private func addReferenceTapped() {
        referenceViewController.searchProviders = searchProviders
        referenceViewController.selectedProvider = selectedReferenceProvider
        present(referenceViewController, animated: true)
    }

    private func configure(with profile: DiscoProfileViewEntity) {
        discoProfile = profile
        referenceSection.configure(with: makeReferenceSectionContent(from: profile.references))
        referenceViewController.selectedReferences = profile.references
    }

    private func addSectionTapped() {
        addNewSectionViewController.sectionField.text = ""
        addNewSectionViewController.sheetPresentationController?.detents = [
            .custom { context in
                context.maximumDetentValue * 0.4
            }
        ]
        present(addNewSectionViewController, animated: true)
    }

    @objc private func addNewRecordToSection(_ sender: UIButton) {
        guard let section = discoProfile?.section[sender.tag] else { return }

        presentAddRecordSourceSheet(for: section)
    }

    private func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            showAlert(
                title: "Problemas com o áudio",
                message: """
                Ocorreu um problema ao configurar o áudio,
                é possível que algumas interações possam apresentar instabilidades
                """,
                dismissed: nil
            )
        }
    }

    deinit {
        debugPrint("Deallocating viewController...")
    }
}

extension DiscoProfileViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        emptyStateLabel.configure(
            message: """
            Você ainda não adicionou nenhuma seção!
            Adicione uma seção clicando no icone de adicionar seção acima
            """
        )
        referenceSection.configure(with: makeReferenceSectionContent(from: []))

        if let bannerImage = UIImage(data: disco.coverImage) {
            banner.image = bannerImage
        } else {
            banner.image = UIImage(named: "AppIcon")
        }
        projectName.text = disco.name
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            projectName.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: SWSpacing.xxSmall),
            projectName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xSmall),
            projectName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),

            referenceSection.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: SWSpacing.xxxSmall + 2),
            referenceSection.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),
            referenceSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),

            sectionHeaderView.topAnchor.constraint(equalTo: referenceSection.bottomAnchor, constant: SWSpacing.xSmall),
            sectionHeaderView.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),
            sectionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),

            emptyStateLabel.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 80),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SWSpacing.xSmall),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SWSpacing.xSmall),

            tableView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: SWSpacing.xxxSmall),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(tableView)
        view.addSubview(banner)
        view.addSubview(projectName)
        view.addSubview(referenceSection)
        view.addSubview(sectionHeaderView)
        view.addSubview(emptyStateLabel)
    }
}

extension DiscoProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        discoProfile?.section.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SWRecordListItemCell.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        discoProfile?.section[section].records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = SWTextLabel(style: .caption)
        label.text = discoProfile?.section[section].identifer

        let container = UIView()
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: SWSpacing.small),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -SWSpacing.small),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -SWSpacing.xxxSmall)
        ])

        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SWSpacing.xLarge
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = SWIconButton(symbolName: "plus", accessibilityLabel: "Adicionar gravação")
        button.tag = section
        button.addTarget(self, action: #selector(addNewRecordToSection(_:)), for: .touchUpInside)

        let container = UIView()
        container.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: SWSize.iconButton),
            button.heightAnchor.constraint(equalToConstant: SWSize.iconButton)
        ])

        return container
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        SWSize.iconButton
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SWRecordListItemCell.identifier
        ) as? SWRecordListItemCell else {
            return UITableViewCell()
        }

        guard let currentItem = discoProfile?.section[indexPath.section].records[indexPath.row] else {
            return UITableViewCell()
        }

        cell.configure(
            with: SWRecordListItemContent(
                iconImage: defineImageForTag(currentItem.tag),
                audioURL: currentItem.audio
            )
        )
        return cell
    }
}

extension DiscoProfileViewController: DiscoProfileDisplayLogic {
    func showSearchProviders(
        _ providers: [SearchReferenceViewEntity],
        selectedProvider: SearchReferenceViewEntity
    ) {
        searchProviders = providers
        selectedReferenceProvider = selectedProvider
        referenceViewController.searchProviders = providers
        referenceViewController.selectedProvider = selectedProvider
    }

    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.referenceSection.configure(with: self.makeReferenceSectionContent(from: references))
            self.referenceViewController.selectedReferences = references
        }
    }

    func startLoading() {}

    func hideLoading() {}

    func showProfile(_ profile: DiscoProfileViewEntity) {
        configure(with: profile)
    }

    func updateSections(_ sections: [SectionViewEntity]) {
        guard var profile = discoProfile else { return }
        profile.section = sections
        discoProfile = profile
    }

    func hideOverlays(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

    func addingReferencesError(_ title: String, description: String) {
        referenceViewController.stopLoadingMore()

        if presentedViewController === referenceViewController {
            referenceViewController.showAlert(title: title, message: description, dismissed: nil)
            return
        }

        showAlert(title: title, message: description, dismissed: nil)
    }

    func loadingProfileError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    func addingSectionError(_ title: String, description: String) {
        showAlert(title: title, message: description) { [weak self] _ in
            self?.addSectionTapped()
        }
    }

    func addingRecordsError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    func showReferences(_ references: ReferenceSearchViewEntity) {
        referenceViewController.updateReferenceItems(references)
    }

    func discoNameUpdated(_ disco: DiscoSummary) {
        self.disco = disco
        projectName.text = disco.name
    }

    func discoDeleted() {
        navigationController?.popViewController(animated: true)
    }

    func updatingDiscoError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    func deletingDiscoError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }
}

private extension DiscoProfileViewController {
    func presentAddRecordSourceSheet(for section: SectionViewEntity) {
        let sheet = AddRecordSourceViewController()
        sheet.onRecordTap = { [weak sheet] in
            sheet?.dismiss(animated: true)
        }
        sheet.onUploadTap = { [weak self, weak sheet] in
            sheet?.dismiss(animated: true) { [weak self] in
                self?.presentDocumentPicker(for: section)
            }
        }
        present(sheet, animated: true)
    }

    func presentDocumentPicker(for section: SectionViewEntity) {
        let document = CustomPickerController(forOpeningContentTypes: [.audio])
        document.section = section
        document.delegate = self
        document.allowsMultipleSelection = false
        present(document, animated: true)
    }

    func updateEmptyStateVisibility() {
        emptyStateLabel.isHidden = !(discoProfile?.section.isEmpty ?? true)
    }

    func makeReferenceSectionContent(from references: [AlbumReferenceViewEntity]) -> SWReferenceSectionContent {
        SWReferenceSectionContent(
            title: "Referências",
            actionSymbolName: "plus",
            actionAccessibilityLabel: "Adicionar referência",
            emptyStateMessage: "Você ainda não possui nenhuma referência ao disco",
            items: references.map { SWReferenceAvatarContent(imageURL: $0.coverImage) }
        )
    }

    func defineImageForTag(_ tag: InstrumentTagViewEntity) -> UIImage? {
        switch tag {
        case .guitar:
            return UIImage(systemName: "guitars.fill")
        case .vocal:
            return UIImage(systemName: "waveform.and.mic")
        case .drums:
            return UIImage(systemName: "light.cylindrical.ceiling.fill")
        case .bass:
            return UIImage(systemName: "waveform.badge.plus")
        case .custom:
            return UIImage(systemName: "waveform.path")
        }
    }
}

extension DiscoProfileViewController: UIDocumentPickerDelegate {
    func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        guard let url = urls.first,
              let customPicker = controller as? CustomPickerController,
              let section = customPicker.section else {
            return
        }

        interactor.addNewRecord(
            in: disco,
            to: section.identifer,
            audioFileURL: url
        )
    }
}
