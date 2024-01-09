//
//  DiscoService.swift
//  DataTests
//
//  Created by Thiago Henrique on 09/01/24.
//

import XCTest
@testable import Data

final class DiscoService: XCTestCase {

}

extension DiscoService: Testing {
    typealias SutAndDoubles = (
        sut: DiscoServiceImpl,
        doubles: (
            DiscoStorageSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let storageSpy = DiscoStorageSpy()
        let sut = DiscoServiceImpl(storage: storageSpy)
        return (sut, (storageSpy))
    }
}
