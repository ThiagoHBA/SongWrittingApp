//
//  DiscoProfilePresenterTests.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import XCTest
import Domain
@testable import Presentation

final class DiscoProfilePresenterTests: XCTestCase {

}

extension DiscoProfilePresenterTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoProfilePresenter,
        doubles: (
            viewSpy: DiscoProfileViewSpy,
            discoServiceSpy: DiscoServiceSpy,
            referenceServiceSpy: ReferenceServiceSpy
        )
    )
    
    func makeSUT() -> SutAndDoubles {
        let discoServiceSpy = DiscoServiceSpy()
        let referencesServiceSpy = ReferenceServiceSpy()
        
        let searchUseCase = SearchReferencesUseCase(service: referencesServiceSpy)
        let getDiscoUseCase = GetDiscoProfileUseCase(service: discoServiceSpy)
        let addDiscoNewRefUseCase = AddDiscoNewReferenceUseCase(service: discoServiceSpy)
        let addNewSectionToDiscoUseCase = AddNewSectionToDiscoUseCase(service: discoServiceSpy)
        let addNewRecordToSessionUseCase = AddNewRecordToSessionUseCase(service: discoServiceSpy)
        
        let viewSpy = DiscoProfileViewSpy()
        let sut = DiscoProfilePresenter()
        
        searchUseCase.output = [sut]
        getDiscoUseCase.output = [sut]
        addDiscoNewRefUseCase.output = [sut]
        addNewSectionToDiscoUseCase.output = [sut]
        addNewRecordToSessionUseCase.output = [sut]
        
        sut.view = viewSpy
        
        return (sut, (viewSpy, discoServiceSpy, referencesServiceSpy))
    }
}
