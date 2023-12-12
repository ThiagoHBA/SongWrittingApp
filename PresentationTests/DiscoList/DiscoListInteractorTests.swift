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
    
    func test_createDisco_should_call_presenter_when_image_invalid() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        let expectedError = DiscoListError.CreateDiscoError.emptyImage
        sut.createDisco(name: "any", image: Data())
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentCreateDiscoError(expectedError)])
    }
    
    func test_createDisco_when_invalid_data_should_not_call_service() {
        let (sut, (_, _, serviceSpy)) = makeSUT()
        sut.createDisco(name: "", image: Data())
        XCTAssertEqual(serviceSpy.receivedMessages, [])
    }
    
    func test_createDisco_when_valid_data_should_call_presenter_loading() {
        let (sut, (presenterSpy, _, _)) = makeSUT()
        sut.createDisco(name: "any", image: "validData".data(using: .utf8)!)
        XCTAssertEqual(presenterSpy.receivedMessages, [.presentLoading])
    }
    
    func test_createDisco_when_valid_data_should_call_service_with_data() {
        let (sut, (_, _, serviceSpy)) = makeSUT()
        let inputName = "any"
        let inputImage = "validData".data(using: .utf8)!
        sut.createDisco(name: inputName, image: inputImage)
        XCTAssertEqual(serviceSpy.receivedMessages, [.createDisco(inputName, inputImage)])
    }
    
    func test_showProfile_when_called_should_call_router_correctly() {
        let (sut, (_, routerSpy, _)) = makeSUT()
        let inputDisco = DiscoListViewEntity(id: UUID(), name: "any", coverImage: Data())
        sut.showProfile(of: inputDisco)
        XCTAssertEqual(routerSpy.receivedMessages, [.showProfile(inputDisco)])
    }
}

extension DiscoListInteractorTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoListInteractor,
        doubles: (
            DiscoListPresenterSpy,
            DiscoListRouterSpy,
            DiscoServiceSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let serviceSpy = DiscoServiceSpy()
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
