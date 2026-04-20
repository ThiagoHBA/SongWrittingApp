//
//  UIViewController+TestHelpers.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//

import UIKit
import XCTest

extension UIViewController {
    func tableView(file: StaticString = #file, line: UInt = #line) throws -> UITableView {
        try XCTUnwrap(view.findSubview(ofType: UITableView.self), file: file, line: line)
    }

    func numberOfRows(section: Int = 0) throws -> Int {
        let tv = try tableView()
        tv.layoutIfNeeded()
        return tv.numberOfRows(inSection: section)
    }

    func numberOfSections() throws -> Int {
        let tv = try tableView()
        tv.layoutIfNeeded()
        return tv.numberOfSections
    }
}
