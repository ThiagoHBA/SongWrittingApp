//
//  DiscoListViewControllerTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit
import XCTest
@testable import Main

@MainActor
final class DiscoListViewControllerTests: XCTestCase {
    func test_viewDidAppear_requests_discos_and_configures_navigation() throws {
        let (sut, interactor, navigationController, _) = makeSUT(loadView: false)

        sut.loadViewIfNeeded()
        interactor.reset()
        appear(sut)

        XCTAssertEqual(interactor.receivedMessages, [.loadDiscos])
        XCTAssertEqual(sut.title, "Meus Discos")
        XCTAssertTrue(navigationController.navigationBar.prefersLargeTitles)
        XCTAssertEqual(
            navigationController.topViewController?.navigationItem.rightBarButtonItem?.accessibilityLabel,
            "Adicionar disco"
        )
    }

    func test_startLoading_shows_placeholder_rows() throws {
        let (sut, _, _, _) = makeSUT()

        sut.startLoading()

        XCTAssertEqual(try sut.numberOfRows(), 4)
        XCTAssertTrue(try emptyStateView(in: sut).isHidden)
    }

    func test_hideLoading_removes_placeholder_rows() throws {
        let (sut, _, _, _) = makeSUT()

        sut.startLoading()
        sut.hideLoading()

        XCTAssertEqual(try sut.numberOfRows(), 0)
        XCTAssertFalse(try emptyStateView(in: sut).isHidden)
    }

    func test_showDiscos_renders_discos_and_hides_empty_state() throws {
        let (sut, _, _, _) = makeSUT()
        let discos = [
            makeDisco(id: UUID(), name: "One"),
            makeDisco(id: UUID(), name: "Two")
        ]

        sut.showDiscos(discos)

        XCTAssertEqual(try sut.numberOfRows(), 2)
        XCTAssertTrue(try emptyStateView(in: sut).isHidden)
    }

    func test_showDiscos_withEmptyList_shows_empty_state() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showDiscos([])

        XCTAssertEqual(try sut.numberOfRows(), 0)
        XCTAssertFalse(try emptyStateView(in: sut).isHidden)
    }

    func test_showNewDisco_appends_disco_to_rendered_list() throws {
        let (sut, _, _, _) = makeSUT()
        let existingDisco = makeDisco(id: UUID(), name: "Existing")
        let newDisco = makeDisco(id: UUID(), name: "New")

        sut.showDiscos([existingDisco])
        sut.showNewDisco(newDisco)

        XCTAssertEqual(try sut.numberOfRows(), 2)
        XCTAssertTrue(try emptyStateView(in: sut).isHidden)
    }

    func test_selectingRow_routes_selected_disco_to_interactor() throws {
        let (sut, interactor, _, _) = makeSUT()
        let disco = makeDisco()

        interactor.reset()
        sut.showDiscos([disco])

        let tableView = try sut.tableView()
        sut.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(interactor.receivedMessages, [.showProfile(disco)])
    }

    func test_addButtonTap_presents_create_disco_view_controller() throws {
        let (sut, interactor, _, _) = makeSUT()

        interactor.reset()
        try tapAddDiscoButton(on: sut)

        wait(until: { sut.presentedViewController is CreateDiscoViewController })

        XCTAssertTrue(sut.presentedViewController is CreateDiscoViewController)
        XCTAssertEqual(interactor.receivedMessages, [])
    }

    func test_createDiscoSheet_submission_forwards_input_to_interactor() throws {
        let (sut, interactor, _, _) = makeSUT()
        let image = Data("cover".utf8)

        interactor.reset()
        try tapAddDiscoButton(on: sut)
        wait(until: { sut.presentedViewController is CreateDiscoViewController })

        let presentedViewController = try XCTUnwrap(sut.presentedViewController as? CreateDiscoViewController)
        presentedViewController.createDiscoTapped?("Any", nil, image)

        XCTAssertEqual(interactor.receivedMessages, [.createDisco(name: "Any", description: nil, image: image)])
    }

    func test_hideOverlays_dismisses_presented_sheet_and_executes_completion() throws {
        let (sut, _, _, _) = makeSUT()
        var completed = false

        try tapAddDiscoButton(on: sut)
        wait(until: { sut.presentedViewController is CreateDiscoViewController })

        sut.hideOverlays {
            completed = true
        }

        wait(until: { sut.presentedViewController == nil && completed })

        XCTAssertNil(sut.presentedViewController)
        XCTAssertTrue(completed)
    }

    func test_loadDiscoError_presents_alert_with_expected_content() throws {
        let (sut, _, _, _) = makeSUT()

        sut.loadDiscoError("Load Error", "Could not load discos")

        wait(until: { sut.presentedViewController is UIAlertController })

        let alertController = try XCTUnwrap(sut.presentedViewController as? UIAlertController)
        XCTAssertEqual(alertController.title, "Load Error")
        XCTAssertEqual(alertController.message, "Could not load discos")
    }

    func test_createDiscoError_presents_alert_with_expected_content() throws {
        let (sut, _, _, _) = makeSUT()

        sut.createDiscoError("Create Error", "Could not create disco")

        wait(until: { sut.presentedViewController is UIAlertController })

        let alertController = try XCTUnwrap(sut.presentedViewController as? UIAlertController)
        XCTAssertEqual(alertController.title, "Create Error")
        XCTAssertEqual(alertController.message, "Could not create disco")
    }
}

extension DiscoListViewControllerTests {
    typealias SutAndDoubles = (
        sut: DiscoListViewController,
        interactor: DiscoListBusinessLogicSpy,
        navigationController: UINavigationController,
        window: UIWindow
    )

    private func makeSUT(loadView: Bool = true) -> SutAndDoubles {
        let interactor = DiscoListBusinessLogicSpy()
        let sut = DiscoListViewController(interactor: interactor)
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

private extension DiscoListViewControllerTests {
    func makeDisco(
        id: UUID = UUID(),
        name: String = "Any Disco",
        coverImage: Data = Data("cover".utf8)
    ) -> DiscoListViewEntity {
        DiscoListViewEntity(id: id, name: name, coverImage: coverImage, entityType: .disco)
    }

    func emptyStateView(in sut: DiscoListViewController) throws -> SWMessageView {
        try XCTUnwrap(sut.view.findSubview(ofType: SWMessageView.self))
    }

    func tapAddDiscoButton(on sut: DiscoListViewController) throws {
        let button = try XCTUnwrap(sut.navigationItem.rightBarButtonItem)
        let target = try XCTUnwrap(button.target)
        let action = try XCTUnwrap(button.action)

        XCTAssertTrue(
            UIApplication.shared.sendAction(
                action,
                to: target,
                from: button,
                for: nil
            )
        )
    }

    func appear(_ sut: UIViewController, animated: Bool = false) {
        sut.beginAppearanceTransition(true, animated: animated)
        sut.endAppearanceTransition()
    }
}
