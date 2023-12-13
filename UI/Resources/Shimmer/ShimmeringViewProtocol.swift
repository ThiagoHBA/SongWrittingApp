//
//  Protocol.swift
//  UI
//
//  Created by Thiago Henrique on 12/12/23.
//

import Foundation
import UIKit

public protocol ShimmeringViewProtocol where Self: UIView {
    var shimmeringAnimatedItems: [UIView] { get }
    var excludedItems: Set<UIView> { get }
}

extension ShimmeringViewProtocol {
    public var shimmeringAnimatedItems: [UIView] { [self] }
    public var excludedItems: Set<UIView> { [] }
}
