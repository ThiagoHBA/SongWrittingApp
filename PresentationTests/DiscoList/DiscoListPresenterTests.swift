//
//  DiscoListPresenterTests.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import XCTest
import Domain
@testable import Presentation

final class DiscoListPresenterTests: XCTestCase {

}

extension DiscoListPresenterTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoListPresenter,
        doubles: (
            DiscoListViewSpy,
            DiscoListServiceSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let serviceSpy = DiscoListServiceSpy()
        let getDiscosUseCase = GetDiscosUseCase(service: serviceSpy)
        let createDiscoUseCase = CreateNewDiscoUseCase(service: serviceSpy)
        let viewSpy = DiscoListViewSpy()
        let sut = DiscoListPresenter()
        
        getDiscosUseCase.output = [sut]
        createDiscoUseCase.output = [sut]
        sut.view = viewSpy
        
        return (sut, (viewSpy, serviceSpy))
    }
}
