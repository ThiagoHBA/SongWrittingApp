//
//  XCTestCase+Wait.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//

import XCTest

extension XCTestCase {
    func wait(
        timeout: TimeInterval = 5,
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
