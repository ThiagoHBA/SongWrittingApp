//
//  DiscoProfileInteractorTests.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import XCTest
import Domain
import Presentation

final class DiscoProfileInteractorTests: XCTestCase {

}

extension DiscoProfileInteractorTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoProfileInteractor,
        doubles:(
            discoServiceSpy: DiscoServiceSpy,
            referencesServiceSpy: ReferenceServiceSpy
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
    
        
        let sut = DiscoProfileInteractor(
            searchReferencesUseCase: searchUseCase,
            getDiscoProfileUseCase: getDiscoUseCase,
            addDiscoNewReferenceUseCase: addDiscoNewRefUseCase,
            addNewSectionToDiscoUseCase: addNewSectionToDiscoUseCase,
            addNewRecordToSessionUseCase: addNewRecordToSessionUseCase
        )
        
        return (sut, (discoServiceSpy, referencesServiceSpy))
    }
}
