import AVFAudio
import UIKit

protocol DiscoProfileDisplayLogic: AnyObject {
    func startLoading()
    func hideLoading()
    func hideOverlays(completion: (() -> Void)?)
    func showReferences(_ references: [AlbumReferenceViewEntity])
    func showProfile(_ profile: DiscoProfileViewEntity)
    func updateReferences(_ references: [AlbumReferenceViewEntity])
    func updateSections(_ sections: [SectionViewEntity])
    func addingReferencesError(_ title: String, description: String)
    func addingSectionError(_ title: String, description: String)
    func loadingProfileError(_ title: String, description: String)
    func addingRecordsError(_ title: String, description: String)
}

final class DiscoProfileViewController: UIViewController, AlertPresentable {
    private var discoProfile: DiscoProfileViewEntity? {
        didSet {
            if let profile = discoProfile, !profile.section.isEmpty {
                emptyStateLabel.removeFromSuperview()
                tableView.reloadData()
            }
        }
    }

    private let interactor: DiscoProfileBusinessLogic
    private let disco: DiscoSummary

    private let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let projectName: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var referenceSection: ReferencesSectionView = {
        let section = ReferencesSectionView()
        section.addReferenceTapped = { [weak self] in
            self?.addReferenceTapped()
        }
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()

    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Seções"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: AddButtonComponent = {
        let button = AddButtonComponent()
        button.didTapped = { [weak self] in
            self?.addSectionTapped()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RecordTableViewCell.self,
            forCellReuseIdentifier: RecordTableViewCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Você ainda não adicionou nenhuma seção!
        Adicione uma seção clicando no icone de adicionar seção acima
        """
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var referenceViewController: AddReferencesViewController = {
        let sheet = AddReferencesViewController()
        sheet.searchReference = { [weak self] keywords in
            self?.interactor.searchNewReferences(keywords: keywords)
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
        interactor.loadProfile(for: disco)
    }

    private func addReferenceTapped() {
        present(referenceViewController, animated: true)
    }

    private func configure(with profile: DiscoProfileViewEntity) {
        discoProfile = profile
        referenceSection.references = profile.references
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

        let document = CustomPickerController(forOpeningContentTypes: [.audio])
        document.section = section
        document.delegate = self
        document.allowsMultipleSelection = false
        present(document, animated: true)
    }

    private func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
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
}

extension DiscoProfileViewController: ViewCoding {
    func additionalConfiguration() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self

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

            projectName.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 8),
            projectName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),

            referenceSection.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 6),
            referenceSection.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),
            referenceSection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            referenceSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

            sectionLabel.topAnchor.constraint(equalTo: referenceSection.bottomAnchor, constant: 32),
            sectionLabel.leadingAnchor.constraint(equalTo: projectName.leadingAnchor),

            addButton.centerYAnchor.constraint(equalTo: sectionLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 28),
            addButton.widthAnchor.constraint(equalToConstant: 32),

            emptyStateLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 80),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            tableView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 6),
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
        view.addSubview(sectionLabel)
        view.addSubview(addButton)
        view.addSubview(emptyStateLabel)
    }
}

extension DiscoProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        discoProfile?.section.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        RecordTableViewCell.heigth
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        discoProfile?.section[section].records.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        discoProfile?.section[section].identifer
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "plus.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 36)),
            for: .normal
        )
        button.tag = section
        button.addTarget(self, action: #selector(addNewRecordToSection(_:)), for: .touchUpInside)
        return button
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        64
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordTableViewCell.identifier
        ) as? RecordTableViewCell else {
            return UITableViewCell()
        }

        guard let currentItem = discoProfile?.section[indexPath.section].records[indexPath.row] else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = true
        cell.configure(with: currentItem)
        return cell
    }
}

extension DiscoProfileViewController: DiscoProfileDisplayLogic {
    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        dismiss(animated: true) { [weak self] in
            self?.referenceSection.references = references
        }
    }

    func startLoading() {}

    func hideLoading() {}

    func showProfile(_ profile: DiscoProfileViewEntity) {
        configure(with: profile)
    }

    func updateSections(_ sections: [SectionViewEntity]) {
        discoProfile?.section = sections
        tableView.reloadData()
    }

    func hideOverlays(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

    func addingReferencesError(_ title: String, description: String) {
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

    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        referenceViewController.updateReferenceItems(references)
    }
}

extension DiscoProfileViewController: UIDocumentPickerDelegate {
    func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        guard let url = urls.first,
              let customPicker = controller as? CustomPickerController,
              var section = customPicker.section else {
            return
        }

        section.records.append(.init(tag: .custom, audio: url))
        interactor.addNewRecord(
            in: disco,
            to: SectionViewEntity(
                identifer: section.identifer,
                records: section.records
            )
        )
    }
}
