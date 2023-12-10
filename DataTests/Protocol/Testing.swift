//
//  Testing.swift
//  DataTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

protocol Testing {
    associatedtype SutAndDoubles
    func makeSUT() -> SutAndDoubles
}
