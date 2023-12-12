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
    func test_presentLoading_when_called_should_call_view_correctly() {
        let (sut, (viewSpy, _, _, _)) = makeSUT()
        sut.presentLoading()
        XCTAssertEqual(viewSpy.receivedMessages, [.startLoading])
    }
    
    func test_presentCreateDiscoError_when_called_should_call_view_correctly() {
        let (sut, (viewSpy, _, _, _)) = makeSUT()
        sut.presentCreateDiscoError(.emptyName)
        viewSpy.hideOverlaysCompletion!()
        
        XCTAssertEqual(
            viewSpy.receivedMessages,
            [
                .hideOverlays,
                .createDiscoError(
                    DiscoListError.CreateDiscoError.errorTitle,
                    DiscoListError.CreateDiscoError.emptyName.localizedDescription
                )
            ]
        )
    }
    
    func test_when_service_create_disco_should_call_view_correctly() {
        let (_, (viewSpy, serviceSpy, _, createUseCase)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        
        createUseCase.input = .init(name: "any", image: Data())
        createUseCase.execute()
        serviceSpy.createDiscoCompletion!(.success(inputDisco))
        viewSpy.hideOverlaysCompletion!()

        XCTAssertEqual(
            viewSpy.receivedMessages, [
                .hideLoading,
                .hideOverlays,
                .showNewDisco(DiscoListViewEntity(from: inputDisco))
            ]
        )
    }
    
    func test_when_service_throw_error_while_creating_disco_should_call_view_correctly() {
        let (_, (viewSpy, serviceSpy, _, createUseCase)) = makeSUT()
        let inputError = DiscoListError.CreateDiscoError.emptyName
        
        createUseCase.input = .init(name: "any", image: Data())
        createUseCase.execute()
        serviceSpy.createDiscoCompletion!(.failure(inputError))
        viewSpy.hideOverlaysCompletion!()

        XCTAssertEqual(
            viewSpy.receivedMessages, [
                .hideLoading,
                .hideOverlays,
                .createDiscoError(
                    DiscoListError.CreateDiscoError.errorTitle,
                    inputError.localizedDescription
                )
            ]
        )
    }
    
    func test_when_service_load_disco_should_call_view_correctly() {
        let (_, (viewSpy, serviceSpy, getUseCase, _)) = makeSUT()
        let inputDiscoList = [
            Disco(id: UUID(), name: "any", coverImage: Data()),
            Disco(id: UUID(), name: "any2", coverImage: Data()),
            Disco(id: UUID(), name: "any3", coverImage: Data())
        ]
        
        getUseCase.execute()
        serviceSpy.loadDiscosCompletion!(.success(inputDiscoList))

        XCTAssertEqual(
            viewSpy.receivedMessages, [
                .hideLoading,
                .showDiscos(inputDiscoList.map { DiscoListViewEntity(from: $0) })
            ]
        )
    }
    
    func test_when_service_throw_error_while_fetching_discos_should_call_view_correctly() {
        let (_, (viewSpy, serviceSpy, getUseCase, _)) = makeSUT()
        let inputError = DiscoListError.CreateDiscoError.emptyImage
        
        getUseCase.execute()
        serviceSpy.loadDiscosCompletion!(.failure(inputError))

        XCTAssertEqual(
            viewSpy.receivedMessages, [
                .hideLoading,
                .loadDiscoError(
                    DiscoListError.LoadDiscoError.errorTitle,
                    inputError.localizedDescription
                )
            ]
        )
    }
}

extension DiscoListPresenterTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoListPresenter,
        doubles: (
            DiscoListViewSpy,
            DiscoServiceSpy,
            GetDiscosUseCase,
            CreateNewDiscoUseCase
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let serviceSpy = DiscoServiceSpy()
        let getDiscosUseCase = GetDiscosUseCase(service: serviceSpy)
        let createDiscoUseCase = CreateNewDiscoUseCase(service: serviceSpy)
        let viewSpy = DiscoListViewSpy()
        let sut = DiscoListPresenter()
        
        getDiscosUseCase.output = [sut]
        createDiscoUseCase.output = [sut]
        sut.view = viewSpy
        
        return (sut, (viewSpy, serviceSpy, getDiscosUseCase, createDiscoUseCase))
    }
}
