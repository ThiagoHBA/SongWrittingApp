//
//  UseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

protocol UseCase {
    associatedtype Gateway
    associatedtype UseCaseOutput
    associatedtype UseCaseInput
    var service: Gateway { get }
    var output: UseCaseOutput? { get set }
    var input: UseCaseInput? { get set }
    init(service: Gateway)
    func execute()
}
