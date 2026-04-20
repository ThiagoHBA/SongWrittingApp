//
//  DiscoProfileViewControllerTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit
import UniformTypeIdentifiers
import XCTest
@testable import Main

@MainActor
final class DiscoProfileViewControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }
    
    func test_viewDidLoad_requests_profile_for_disc() {
        let disco = makeDisco()
        let (sut, interactor, _, _) = makeSUT(disco: disco, loadView: false)

        sut.loadViewIfNeeded()

        XCTAssertEqual(interactor.receivedMessages, [.loadSearchProviders, .loadProfile(disco)])
    }

    func test_showProfile_withEmptySections_shows_empty_state() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showProfile(makeProfile())

        XCTAssertEqual(try numberOfSections(in: sut), 0)
        XCTAssertFalse(try emptyStateView(in: sut).isHidden)
    }

    func test_showProfile_renders_sections_and_hides_empty_state() throws {
        let (sut, _, _, _) = makeSUT()
        let profile = makeProfile(
            references: [makeReference()],
            sections: [makeSection(records: [makeRecord()])]
        )

        sut.showProfile(profile)

        XCTAssertEqual(try numberOfSections(in: sut), 1)
        XCTAssertEqual(try numberOfRows(in: sut, section: 0), 2) // title row + 1 record
        XCTAssertTrue(try emptyStateView(in: sut).isHidden)
    }

    func test_showProfile_updates_add_reference_sheet_selected_references() throws {
        let (sut, _, _, _) = makeSUT()
        let references = [makeReference()]

        sut.showProfile(makeProfile(references: references))
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        XCTAssertEqual(presentedViewController.selectedReferences, references)
    }

    func test_showReferences_updates_reference_sheet_results() throws {
        let (sut, _, _, _) = makeSUT()
        let references = [makeReference()]

        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        sut.showReferences(.init(references: references, hasMore: false))

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        XCTAssertEqual(try numberOfRows(in: presentedViewController), 1)
    }

    func test_add_reference_button_presents_sheet() throws {
        let (sut, interactor, _, _) = makeSUT()

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        XCTAssertTrue(sut.presentedViewController is AddReferencesViewController)
        XCTAssertEqual(interactor.receivedMessages, [])
    }

    func test_add_reference_sheet_search_forwards_keywords_to_interactor() throws {
        let (sut, interactor, _, _) = makeSUT()

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        presentedViewController.searchReference?("album")

        XCTAssertEqual(interactor.receivedMessages, [.searchNewReferences("album")])
    }

    func test_add_reference_sheet_provider_selection_forwards_to_interactor() throws {
        let (sut, interactor, _, _) = makeSUT()
        let selectedProvider = SearchReferenceViewEntity(from: .lastFM)

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        presentedViewController.selectReferenceProvider?(selectedProvider)

        XCTAssertEqual(interactor.receivedMessages, [.selectReferenceProvider(selectedProvider)])
    }

    func test_add_reference_sheet_loadMore_forwards_to_interactor() throws {
        let (sut, interactor, _, _) = makeSUT()

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        presentedViewController.loadMoreReferences?()

        XCTAssertEqual(interactor.receivedMessages, [.loadMoreReferences])
    }

    func test_add_reference_sheet_clearSearch_forwards_to_interactor() throws {
        let (sut, interactor, _, _) = makeSUT()

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        presentedViewController.clearSearch?()

        XCTAssertEqual(interactor.receivedMessages, [.resetReferenceSearch])
    }

    func test_add_reference_sheet_save_forwards_selected_references_to_interactor() throws {
        let disco = makeDisco()
        let (sut, interactor, _, _) = makeSUT(disco: disco)
        let references = [makeReference()]

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        presentedViewController.saveReferences?(references)

        XCTAssertEqual(interactor.receivedMessages, [.addNewReferences(disco, references)])
    }

    func test_updateReferences_dismisses_sheet_and_updates_saved_selection() throws {
        let (sut, _, _, _) = makeSUT()
        let references = [makeReference()]

        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        sut.updateReferences(references)
        wait(until: { sut.presentedViewController == nil })

        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        XCTAssertEqual(presentedViewController.selectedReferences, references)
    }

    func test_add_reference_sheet_reuses_last_selected_provider() throws {
        let (sut, interactor, _, _) = makeSUT()
        let selectedProvider = SearchReferenceViewEntity(from: .lastFM)

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let firstPresentation = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        firstPresentation.selectReferenceProvider?(selectedProvider)
        sut.dismiss(animated: false)
        wait(until: { sut.presentedViewController == nil })

        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let secondPresentation = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        XCTAssertEqual(secondPresentation.selectedProvider, selectedProvider)
    }

    func test_showSearchProviders_updates_add_reference_sheet_configuration() throws {
        let (sut, _, _, _) = makeSUT()
        let providers = ReferenceProvider.allCases.map(SearchReferenceViewEntity.init(from:))
        let selectedProvider = SearchReferenceViewEntity(from: .lastFM)

        sut.showSearchProviders(providers, selectedProvider: selectedProvider)
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar referência")
        wait(until: { sut.presentedViewController is AddReferencesViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddReferencesViewController)
        XCTAssertEqual(presentedViewController.searchProviders, providers)
        XCTAssertEqual(presentedViewController.selectedProvider, selectedProvider)
    }

    func test_add_section_button_presents_sheet() throws {
        let (sut, interactor, _, _) = makeSUT()

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar seção")
        wait(until: { sut.presentedViewController is AddSectionViewController })

        XCTAssertTrue(sut.presentedViewController is AddSectionViewController)
        XCTAssertEqual(interactor.receivedMessages, [])
    }

    func test_add_section_sheet_submission_forwards_section_to_interactor() throws {
        let disco = makeDisco()
        let (sut, interactor, _, _) = makeSUT(disco: disco)

        interactor.reset()
        try tapButton(in: sut.view, accessibilityLabel: "Adicionar seção")
        wait(until: { sut.presentedViewController is AddSectionViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? AddSectionViewController)
        presentedViewController.addSectionTapped?("Verse")

        XCTAssertEqual(
            interactor.receivedMessages,
            [.addNewSection(disco, SectionViewEntity(identifer: "Verse", records: []))]
        )
    }

    func test_updateSections_updates_rendered_sections() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showProfile(makeProfile())
        sut.updateSections([makeSection(records: [makeRecord()])])

        XCTAssertEqual(try numberOfSections(in: sut), 1)
        XCTAssertEqual(try numberOfRows(in: sut, section: 0), 2) // title row + 1 record
        XCTAssertTrue(try emptyStateView(in: sut).isHidden)
    }

    func test_add_record_footer_renders_add_record_button() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showProfile(makeProfile(sections: [makeSection(records: [])]))

        let footerView = try footerView(in: sut, section: 0)

        XCTAssertNotNil(footerView.profileFindButton(accessibilityLabel: "Adicionar gravação"))
    }

    func test_add_record_button_presents_source_sheet() throws {
        let (sut, interactor, _, _) = makeSUT()

        sut.showProfile(makeProfile(sections: [makeSection(records: [])]))
        interactor.reset()

        let footerView = try footerView(in: sut, section: 0)
        try tapButton(in: footerView, accessibilityLabel: "Adicionar gravação")
        wait(until: { sut.presentedViewController is AddRecordSourceViewController })

        XCTAssertTrue(sut.presentedViewController is AddRecordSourceViewController)
        XCTAssertEqual(interactor.receivedMessages, [])
    }

    func test_add_record_source_sheet_upload_presents_documentPicker() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showProfile(makeProfile(sections: [makeSection(records: [])]))

        let footerView = try footerView(in: sut, section: 0)
        try tapButton(in: footerView, accessibilityLabel: "Adicionar gravação")
        wait(until: { sut.presentedViewController is AddRecordSourceViewController })

        let sourceSheet = try XCTUnwrap(sut.presentedViewController as? AddRecordSourceViewController)
        try tapButton(in: sourceSheet.view, accessibilityLabel: "Upload")
        wait(timeout: 5, until: { sut.presentedViewController is CustomPickerController })

        XCTAssertTrue(sut.presentedViewController is CustomPickerController)
    }

    func test_add_record_source_sheet_record_dismisses_without_interactor_messages() throws {
        let (sut, interactor, _, _) = makeSUT()

        sut.showProfile(makeProfile(sections: [makeSection(records: [])]))
        interactor.reset()

        let footerView = try footerView(in: sut, section: 0)
        try tapButton(in: footerView, accessibilityLabel: "Adicionar gravação")
        wait(timeout: 5, until: { sut.presentedViewController is AddRecordSourceViewController })

        let sourceSheet = try XCTUnwrap(sut.presentedViewController as? AddRecordSourceViewController)
        try tapButton(in: sourceSheet.view, accessibilityLabel: "Gravar")
        wait(timeout: 5, until: { sut.presentedViewController == nil })

        XCTAssertTrue(interactor.receivedMessages.isEmpty)
    }

    func test_documentPicker_forwards_new_custom_record_to_interactor() throws {
        let disco = makeDisco()
        let (sut, interactor, _, _) = makeSUT(disco: disco)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("audio.m4a")
        try? "test".write(to: url, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: url) }

        let originalSection = makeSection(records: [])
        let pickerController = CustomPickerController(forOpeningContentTypes: [UTType.audio])
        pickerController.section = originalSection

        interactor.reset()
        sut.documentPicker(pickerController, didPickDocumentsAt: [url])

        guard let firstMessage = interactor.receivedMessages.first,
              case let .addNewRecord(receivedDisco, receivedSectionIdentifier, receivedAudioURL) = firstMessage else {
            XCTFail("Expected .addNewRecord message")
            return
        }

        XCTAssertEqual(receivedDisco, disco)
        XCTAssertEqual(receivedSectionIdentifier, originalSection.identifer)
        XCTAssertEqual(receivedAudioURL, url)
    }

    func test_hideOverlays_dismisses_presented_sheet_and_executes_completion() throws {
        let (sut, _, _, _) = makeSUT()
        var completed = false

        try tapButton(in: sut.view, accessibilityLabel: "Adicionar seção")
        wait(until: { sut.presentedViewController is AddSectionViewController })

        sut.hideOverlays {
            completed = true
        }

        wait(until: { sut.presentedViewController == nil && completed })

        XCTAssertNil(sut.presentedViewController)
        XCTAssertTrue(completed)
    }

    func test_loadingProfileError_presents_alert_with_expected_content() throws {
        let (sut, _, _, _) = makeSUT()

        sut.loadingProfileError("Load Error", description: "Could not load profile")
        wait(until: { sut.presentedViewController is UIAlertController })

        let alertController = try XCTUnwrap(sut.presentedViewController as? UIAlertController)
        XCTAssertEqual(alertController.title, "Load Error")
        XCTAssertEqual(alertController.message, "Could not load profile")
    }

    func test_addingSectionError_presents_alert_with_expected_content() throws {
        let (sut, _, _, _) = makeSUT()

        sut.addingSectionError("Section Error", description: "Could not add section")
        wait(until: { sut.presentedViewController is UIAlertController })

        let alertController = try XCTUnwrap(sut.presentedViewController as? UIAlertController)
        XCTAssertEqual(alertController.title, "Section Error")
        XCTAssertEqual(alertController.message, "Could not add section")
    }
}

extension DiscoProfileViewControllerTests {
    typealias SutAndDoubles = (
        sut: DiscoProfileViewController,
        interactor: DiscoProfileBusinessLogicSpy,
        navigationController: UINavigationController,
        window: UIWindow
    )

    private func makeSUT(
        disco: DiscoSummary = DiscoSummary(id: UUID(), name: "Any Disco", coverImage: Data("cover".utf8)),
        loadView: Bool = true
    ) -> SutAndDoubles {
        UIView.setAnimationsEnabled(false)
        
        let interactor = DiscoProfileBusinessLogicSpy()
        let sut = DiscoProfileViewController(disco: disco, interactor: interactor)
        let navigationController = UINavigationController(rootViewController: sut)
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if loadView {
            sut.loadViewIfNeeded()
        }

        return (sut, interactor, navigationController, window)
    }
}

private extension DiscoProfileViewControllerTests {
    func makeDisco() -> DiscoSummary {
        DiscoSummary(id: UUID(), name: "Any Disco", coverImage: Data("cover".utf8))
    }

    func makeReference(
        name: String = "Album",
        artist: String = "Artist",
        releaseDate: String = "2024-01-01",
        coverImage: URL? = URL(string: "https://example.com/image")
    ) -> AlbumReferenceViewEntity {
        AlbumReferenceViewEntity(
            name: name,
            artist: artist,
            releaseDate: releaseDate,
            coverImage: coverImage
        )
    }

    func makeRecord(
        tag: InstrumentTagViewEntity = .bass,
        audio: URL = URL(fileURLWithPath: "/tmp/audio.m4a")
    ) -> RecordViewEntity {
        RecordViewEntity(tag: tag, audio: audio)
    }

    func makeSection(
        identifer: String = "Verse",
        records: [RecordViewEntity]
    ) -> SectionViewEntity {
        SectionViewEntity(identifer: identifer, records: records)
    }

    func makeProfile(
        disco: DiscoSummary = DiscoSummary(id: UUID(), name: "Any Disco", coverImage: Data("cover".utf8)),
        references: [AlbumReferenceViewEntity] = [],
        sections: [SectionViewEntity] = []
    ) -> DiscoProfileViewEntity {
        DiscoProfileViewEntity(disco: disco, references: references, section: sections)
    }

    func tableView(in sut: DiscoProfileViewController) throws -> UITableView {
        try XCTUnwrap(sut.view.profileFindSubview(ofType: UITableView.self))
    }

    func emptyStateView(in sut: DiscoProfileViewController) throws -> SWMessageView {
        try XCTUnwrap(sut.view.subviews.first(where: { $0 is SWMessageView }) as? SWMessageView)
    }

    func numberOfSections(in sut: DiscoProfileViewController) throws -> Int {
        let tableView = try tableView(in: sut)
        tableView.layoutIfNeeded()
        return tableView.numberOfSections
    }

    func numberOfRows(in sut: DiscoProfileViewController, section: Int) throws -> Int {
        let tableView = try tableView(in: sut)
        tableView.layoutIfNeeded()
        return tableView.numberOfRows(inSection: section)
    }

    func footerView(in sut: DiscoProfileViewController, section: Int) throws -> UIView {
        let tableView = try tableView(in: sut)
        return try XCTUnwrap(sut.tableView(tableView, viewForFooterInSection: section))
    }

    func numberOfRows(in sut: AddReferencesViewController) throws -> Int {
        let tableView = try XCTUnwrap(sut.view.profileFindSubview(ofType: UITableView.self))
        tableView.layoutIfNeeded()
        return tableView.numberOfRows(inSection: 0)
    }

    func tapButton(in rootView: UIView, accessibilityLabel: String) throws {
        let button = try XCTUnwrap(rootView.profileFindButton(accessibilityLabel: accessibilityLabel))
        button.sendActions(for: .touchUpInside)
    }

    func wait(
        timeout: TimeInterval = 1,
        until condition: () -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let deadline = Date().addingTimeInterval(timeout)
        
        while !condition() {
            if Date() > deadline {
                XCTFail("Condition not met within \(timeout)s", file: file, line: line)
                return
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        }
    }
}

private extension UIView {
    func profileFindSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let typedView = self as? T {
            return typedView
        }

        for subview in subviews {
            if let typedView = subview.profileFindSubview(ofType: type) {
                return typedView
            }
        }

        return nil
    }

    func profileFindButton(accessibilityLabel: String) -> UIButton? {
        if let button = self as? UIButton, button.accessibilityLabel == accessibilityLabel {
            return button
        }

        for subview in subviews {
            if let button = subview.profileFindButton(accessibilityLabel: accessibilityLabel) {
                return button
            }
        }

        return nil
    }
}
