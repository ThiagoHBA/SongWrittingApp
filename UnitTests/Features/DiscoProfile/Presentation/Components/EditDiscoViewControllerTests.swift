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

        let navBar = try XCTUnwrap(sut.view.profileFindSubview(ofType: UINavigationBar.self))

        XCTAssertEqual(navBar.items?.first?.title, "Editar Disco")
    }

    func test_saveButton_calls_saveNameTapped_with_textField_content() throws {
        let sut = makeSUT(discoName: "Original Name")
        var receivedName: String?
        sut.saveNameTapped = { receivedName = $0 }
        sut.nameField.text = "Updated Name"

        let saveButton = try XCTUnwrap(sut.view.profileFindButton(accessibilityLabel: "Salvar"))
        saveButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(receivedName, "Updated Name")
    }

    func test_deleteButton_is_red() throws {
        let sut = makeSUT()

        let deleteButton = try XCTUnwrap(sut.view.profileFindButton(accessibilityLabel: "Deletar Disco"))

        XCTAssertEqual(deleteButton.backgroundColor, .systemRed)
    }

    func test_deleteButton_calls_deleteDiscoTapped_when_tapped() throws {
        let sut = makeSUT()
        var deleteCallCount = 0
        sut.deleteDiscoTapped = { deleteCallCount += 1 }

        let deleteButton = try XCTUnwrap(sut.view.profileFindButton(accessibilityLabel: "Deletar Disco"))
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

private extension UIView {
    func profileFindSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let typedView = self as? T { return typedView }
        for subview in subviews {
            if let typedView = subview.profileFindSubview(ofType: type) { return typedView }
        }
        return nil
    }

    func profileFindButton(accessibilityLabel label: String) -> UIButton? {
        if let button = self as? UIButton, button.accessibilityLabel == label { return button }
        for subview in subviews {
            if let button = subview.profileFindButton(accessibilityLabel: label) { return button }
        }
        return nil
    }
}
