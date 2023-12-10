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
    func test_loadDiscos_when_called_should_call_loading_on_presenter() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        sut.loadDiscos()
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    
    func test_loadDiscos_when_called_should_call_usecase() {
        let (sut, (_, _, serviceSpy)) = makeSUT()
        sut.loadDiscos()
        XCTAssertEqual(serviceSpy.receivedMessages, [.loadDiscos])
    }
    
    func test_createDisco_should_call_presenter_when_name_invalid() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        let expectedError = DiscoListError.CreateDiscoError.emptyName
        sut.createDisco(name: "", image: Data())
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentCreateDiscoError(expectedError)])
    }
    
}

extension DiscoListInteractorTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoListInteractor,
        doubles: (
            DiscoListPresenterSpy,
            DiscoListRouterSpy,
            DiscoListServiceSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let serviceSpy = DiscoListServiceSpy()
        let getDiscosUseCase = GetDiscosUseCase(service: serviceSpy)
        let createNewDiscoUseCase = CreateNewDiscoUseCase(service: serviceSpy)
        let presenterSpy = DiscoListPresenterSpy()
        let routerSpy = DiscoListRouterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        
        sut.presenter = presenterSpy
        sut.router = routerSpy
        
        return (sut, (presenterSpy, routerSpy, serviceSpy))
    }
}
