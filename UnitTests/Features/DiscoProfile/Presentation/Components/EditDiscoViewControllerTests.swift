//
//  EditDiscoViewControllerTests.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import UIKit
import XCTest
@testable import Main

@MainActor
final class EditDiscoViewControllerTests: XCTestCase {
    func test_viewDidLoad_prefills_textField_with_discoName() {
        let sut = makeSUT(discoName: "My Disco")

        XCTAssertEqual(sut.nameField.text, "My Disco")
    }

    func test_viewDidLoad_renders_navigation_bar_with_edit_title() throws {
        let sut = makeSUT()

        let navBar = try XCTUnwrap(sut.view.findSubview(ofType: UINavigationBar.self))

        XCTAssertEqual(navBar.items?.first?.title, "Editar Disco")
    }

    func test_saveButton_calls_saveNameTapped_with_textField_content() throws {
        let sut = makeSUT(discoName: "Original Name")
        var receivedName: String?
        sut.saveNameTapped = { receivedName = $0 }
        sut.nameField.text = "Updated Name"

        let saveButton = try XCTUnwrap(sut.view.findButton(accessibilityLabel: "Salvar"))
        saveButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(receivedName, "Updated Name")
    }

    func test_deleteButton_is_red() throws {
        let sut = makeSUT()

        let deleteButton = try XCTUnwrap(sut.view.findButton(accessibilityLabel: "Deletar Disco"))

        XCTAssertEqual(deleteButton.backgroundColor, SWColor.Destructive.primary)
    }

    func test_deleteButton_calls_deleteDiscoTapped_when_tapped() throws {
        let sut = makeSUT()
        var deleteCallCount = 0
        sut.deleteDiscoTapped = { deleteCallCount += 1 }

        let deleteButton = try XCTUnwrap(sut.view.findButton(accessibilityLabel: "Deletar Disco"))
        deleteButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(deleteCallCount, 1)
    }
}

private extension EditDiscoViewControllerTests {
    func makeSUT(discoName: String = "Any Disco") -> EditDiscoViewController {
        let sut = EditDiscoViewController()
        sut.discoName = discoName
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.loadViewIfNeeded()
        return sut
    }
}
