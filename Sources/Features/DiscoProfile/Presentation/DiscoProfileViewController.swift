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
    func deletingSectionError(_ title: String, description: String)
    func deletingRecordError(_ title: String, description: String)
}

final class DiscoProfileViewController: UIViewController, AlertPresentable {
    private enum Layout {
        static let bannerHeightMultiplier: CGFloat = 0.3
        static let projectNameTopSpacing: CGFloat = 8
    }

    private var discoProfile: DiscoProfileViewEntity? {
        didSet {
            updateEmptyStateVisibility()
            tableView.reloadData()
            updateTableViewHeight()
            playButton.isHidden = (discoProfile?.section.count ?? 0) < 1
        }
    }

    private let interactor: DiscoProfileBusinessLogic
    private var disco: DiscoSummary
    private var searchProviders: [SearchReferenceViewEntity] = []
    private var selectedReferenceProvider: SearchReferenceViewEntity?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bannerSpacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var bannerHeightConstraint: NSLayoutConstraint?

    private let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let projectName = SWTextLabel(style: .heroTitle, numberOfLines: 0)
    private let descriptionLabel = SWTextLabel(style: .body, numberOfLines: 0)

    private lazy var referenceSection: SWReferenceSectionView = {
        let section = SWReferenceSectionView()
        section.onActionTap = { [weak self] in
            self?.addReferenceTapped()
        }
        return section
    }()
    
    private lazy var playButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "play.fill"),
            style: .plain,
            target: self,
            action: #selector(playDiscoTapped)
        )
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

    private static let sectionTitleCellIdentifier = "SectionTitleCell"

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SWRecordListItemCell.self,
            forCellReuseIdentifier: SWRecordListItemCell.identifier
        )
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: DiscoProfileViewController.sectionTitleCellIdentifier
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
        
        navigationItem.rightBarButtonItems = [
            playButton,
            UIBarButtonItem(
                image: UIImage(systemName: "pencil"),
                style: .plain,
                target: self,
                action: #selector(editDiscTapped)
            )
        ]
        
        interactor.loadSearchProviders()
        interactor.loadProfile(for: disco)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }

    @objc private func editDiscTapped() {
        editDiscoViewController.discoName = disco.name
        editDiscoViewController.sheetPresentationController?.detents = [
            .custom { context in context.maximumDetentValue * 0.5 }
        ]
        present(editDiscoViewController, animated: true)
    }
    
    @objc private func playDiscoTapped() {
        guard let sections = discoProfile?.section else { return }
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

        if let text = profile.disco.description, !text.isEmpty {
            descriptionLabel.text = text
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
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
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentBackgroundView.backgroundColor = .systemBackground
        bannerSpacer.backgroundColor = .clear
        banner.layer.zPosition = -1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.isScrollEnabled = false

        emptyStateLabel.configure(
            message: """
            Você ainda não adicionou nenhuma seção!
            Adicione uma seção clicando no icone de adicionar seção acima
            """
        )
        emptyStateLabel.accessibilityIdentifier = "sections-empty-state"
        referenceSection.configure(with: makeReferenceSectionContent(from: []))

        if let bannerImage = UIImage(data: disco.coverImage) {
            banner.image = bannerImage
        } else {
            banner.image = UIImage(named: "AppIcon")
        }
        projectName.text = disco.name
        if let text = disco.description, !text.isEmpty {
            descriptionLabel.text = text
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
    }

    func setupConstraints() {
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        let bannerHeightConstraint = banner.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: Layout.bannerHeightMultiplier
        )

        tableViewHeightConstraint = heightConstraint
        self.bannerHeightConstraint = bannerHeightConstraint

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerHeightConstraint,

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            bannerSpacer.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerSpacer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerSpacer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerSpacer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),

            contentBackgroundView.topAnchor.constraint(equalTo: bannerSpacer.bottomAnchor),
            contentBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            projectName.topAnchor.constraint(equalTo: bannerSpacer.bottomAnchor, constant: Layout.projectNameTopSpacing),
            projectName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.xSmall),
            projectName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.xSmall),

            descriptionLabel.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: SWSpacing.xxxSmall),
            descriptionLabel.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: projectName.trailingAnchor),

            referenceSection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: SWSpacing.large),
            referenceSection.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            referenceSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.xSmall),

            sectionHeaderView.topAnchor.constraint(equalTo: referenceSection.bottomAnchor, constant: SWSpacing.xSmall),
            sectionHeaderView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            sectionHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.xSmall),

            emptyStateLabel.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 80),
            emptyStateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SWSpacing.xSmall),
            emptyStateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SWSpacing.xSmall),

            tableView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: SWSpacing.xxxSmall),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            heightConstraint
        ])
    }

    func addViewInHierarchy() {
        view.addSubview(banner)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bannerSpacer)
        contentView.addSubview(contentBackgroundView)
        contentView.addSubview(projectName)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(referenceSection)
        contentView.addSubview(sectionHeaderView)
        contentView.addSubview(emptyStateLabel)
        contentView.addSubview(tableView)
    }
}

extension DiscoProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        discoProfile?.section.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? SWSpacing.xLarge : SWRecordListItemCell.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recordCount = discoProfile?.section[section].records.count ?? 0
        return recordCount + 1
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let section = discoProfile?.section[indexPath.section] else { return nil }

        if indexPath.row == 0 {
            let deleteAction = UIContextualAction(style: .destructive, title: "Deletar") { [weak self] _, _, completion in
                guard let self else { completion(false); return }
                self.interactor.deleteSection(in: self.disco, sectionIdentifier: section.identifer)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

        let record = section.records[indexPath.row - 1]
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar") { [weak self] _, _, completion in
            guard let self else { completion(false); return }
            self.interactor.deleteRecord(in: self.disco, sectionIdentifier: section.identifer, audioURL: record.audio)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DiscoProfileViewController.sectionTitleCellIdentifier,
                for: indexPath
            )
            cell.backgroundColor = .clear
            cell.selectionStyle = .none

            let labelTag = 1
            let label: SWTextLabel
            
            if let existing = cell.contentView.viewWithTag(labelTag) as? SWTextLabel {
                label = existing
            } else {
                let newLabel = SWTextLabel(style: .caption)
                newLabel.tag = labelTag
                cell.contentView.addSubview(newLabel)
                NSLayoutConstraint.activate([
                    newLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    newLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: SWSpacing.small),
                    newLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -SWSpacing.small),
                    newLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -SWSpacing.xxxSmall)
                ])
                label = newLabel
            }
            
            label.text = discoProfile?.section[indexPath.section].identifer
            
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SWRecordListItemCell.identifier
        ) as? SWRecordListItemCell else {
            return UITableViewCell()
        }

        guard let currentItem = discoProfile?.section[indexPath.section].records[indexPath.row - 1] else {
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

extension DiscoProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let stretchOffset = max(-(scrollView.contentOffset.y + scrollView.adjustedContentInset.top), 0)
        bannerHeightConstraint?.constant = stretchOffset
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

    func deletingSectionError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    func deletingRecordError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }
}

private extension DiscoProfileViewController {
    func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height

        guard tableViewHeightConstraint?.constant != contentHeight else { return }

        tableViewHeightConstraint?.constant = contentHeight
        view.layoutIfNeeded()
    }

    func presentAddRecordSourceSheet(for section: SectionViewEntity) {
        let sheet = AddRecordSourceViewController()
        sheet.onRecordTap = { [weak self, weak sheet] in
            sheet?.dismiss(animated: true) { [weak self] in
                self?.presentAudioRecording(for: section)
            }
        }
        sheet.onUploadTap = { [weak self, weak sheet] in
            sheet?.dismiss(animated: true) { [weak self] in
                self?.presentDocumentPicker(for: section)
            }
        }
        present(sheet, animated: true)
    }

    func presentAudioRecording(for section: SectionViewEntity) {
        let recorder = AudioRecordingViewController()
        recorder.onSave = { [weak self] recordedURL in
            guard let self else { return }
            self.interactor.addNewRecord(
                in: self.disco,
                to: section.identifer,
                audioFileURL: recordedURL
            )
        }
        present(recorder, animated: true)
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
