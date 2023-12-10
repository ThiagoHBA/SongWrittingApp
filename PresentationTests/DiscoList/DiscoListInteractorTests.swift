//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 09/12/23.
//

import XCTest
import Domain
@testable import Presentation

final class DiscoListInteractorTests: XCTestCase {
    
}

extension DiscoListInteractorTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoListInteractor,
        doubles: (
            DiscoListPresenterSpy,
            DiscoListRouterSpy,
            DiscoListServiceStub
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let serviceStub = DiscoListServiceStub()
        let getDiscosUseCase = GetDiscosUseCase(service: serviceStub)
        let createNewDiscoUseCase = CreateNewDiscoUseCase(service: serviceStub)
        let presenterSpy = DiscoListPresenterSpy()
        let routerSpy = DiscoListRouterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        
        sut.presenter = presenterSpy
        sut.router = routerSpy
        
        return (sut, (presenterSpy, routerSpy, serviceStub))
    }
}
