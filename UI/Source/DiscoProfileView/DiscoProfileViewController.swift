//
//  DiscoProfileViewController.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import UIKit
import Presentation
import AVFAudio

public class DiscoProfileViewController: UIViewController {
    private var discoProfile: DiscoProfileViewEntity? {
        didSet {
            if let profile = discoProfile,
            !profile.section.isEmpty {
                emptyStateLabel.removeFromSuperview()
                tableView.reloadData()
            }
        }
    }
    let interactor: DiscoProfileBusinessRule
    let disco: DiscoListViewEntity

    let banner: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let projectName: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var referenceSection: ReferencesSectionView = {
        let section = ReferencesSectionView()
        section.addReferenceTapped = addReferenceTapped
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()

    let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Seções"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addButton: AddButtonComponent = {
        let button = AddButtonComponent()
        button.didTapped = addSectionTapped
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RecordTableViewCell.self,
            forCellReuseIdentifier: RecordTableViewCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let emptyStateLabel: UILabel = {
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

    lazy var referenceViewController: AddReferencesViewController = {
        let sheet = AddReferencesViewController()
        sheet.searchReference = interactor.searchNewReferences
        sheet.saveReferences = { [weak self] referencesToAdd in
            guard let self = self else { return }
            interactor.addNewReferences(
                for: disco,
                references: referencesToAdd
            )
        }
        sheet.sheetPresentationController?.detents = [ .large() ]
        return sheet
    }()

    lazy var addNewSectionViewController: AddSectionViewController = {
        let sheet = AddSectionViewController()
        sheet.addSectionTapped = { [weak self] identifier in
            guard let self = self else { return }
            interactor.addNewSection(
                for: disco,
                section: SectionViewEntity(
                    identifer: identifier,
                    records: []
                )
            )
        }
        return sheet
    }()

    public init(disco: DiscoListViewEntity, interactor: DiscoProfileBusinessRule) {
        self.disco = disco
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        configureAudio()
        interactor.loadProfile(for: disco)
    }

    func addReferenceTapped() {
        present(referenceViewController, animated: true)
    }

    func configure(with profile: DiscoProfileViewEntity) {
        discoProfile = profile
        referenceSection.references = discoProfile!.references
        referenceViewController.selectedReferences = discoProfile!.references
    }

    func addSectionTapped() {
        addNewSectionViewController.sectionField.text = ""
        addNewSectionViewController.sheetPresentationController?.detents = [
            .custom { context in
                return context.maximumDetentValue * 0.4
            }
        ]
        present(addNewSectionViewController, animated: true)
    }

    @objc func addNewRecordToSection(_ sender: UIButton) {
        guard let section = discoProfile?.section[sender.tag] else { return }

        let document = CustomPickerController(forOpeningContentTypes: [.audio])
        document.section = section
        document.delegate = self
        document.allowsMultipleSelection = false
        present(document, animated: true)
    }

    func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch _ {
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
        print("Dealocaing Profile...")
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
            banner.image = UIImage(named: "AppIcon")!
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

extension DiscoProfileViewController: AlertPresentable {}

// MARK: TableView Datasource/Delegate Conformance
extension DiscoProfileViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return discoProfile?.section.count ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecordTableViewCell.heigth
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoProfile?.section[section].records.count ?? 0
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return discoProfile?.section[section].identifer
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "plus.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 36)),
            for: .normal
        )
        button.tag = section
        button.addTarget(
            self,
            action: #selector(addNewRecordToSection(_:)),
            for: .touchUpInside
        )
        return button
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }

    public func tableView(
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
    public func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            referenceSection.references = references
        }
    }

    public func startLoading() {

    }

    public func hideLoading() {

    }

    public func showProfile(_ profile: DiscoProfileViewEntity) {
        configure(with: profile)
    }

    public func updateSections(_ sections: [SectionViewEntity]) {
        discoProfile?.section = sections
        tableView.reloadData()
    }

    public func hideOverlays(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }

    public func addingReferencesError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    public func loadingProfileError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    public func addingSectionError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: { [weak self] _ in
            self?.addSectionTapped()
        })
    }

    public func addingRecordsError(_ title: String, description: String) {
        showAlert(title: title, message: description, dismissed: nil)
    }

    public func showReferences(_ references: [AlbumReferenceViewEntity]) {
        referenceViewController.updateReferenceItems(references)
    }
}

extension DiscoProfileViewController: UIDocumentPickerDelegate {
    public func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        guard let url = urls.first else { return }
        guard let customPicker = controller as? CustomPickerController else { return }
        guard var section = customPicker.section else { return }
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
