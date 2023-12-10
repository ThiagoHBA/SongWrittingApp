//
//  ViewCoding.swift
//  UI
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

protocol ViewCoding {
    func setupConstraints()
    func addViewInHierarchy()
    func additionalConfiguration()
    func buildLayout()
}

extension ViewCoding {
    func buildLayout() {
        addViewInHierarchy()
        setupConstraints()
        additionalConfiguration()
    }
    
    func additionalConfiguration() {}
}
