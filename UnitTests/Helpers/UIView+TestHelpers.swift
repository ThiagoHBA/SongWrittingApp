//
//  UIView+TestHelpers.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//

import UIKit

extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let typedView = self as? T { return typedView }
        for subview in subviews {
            if let typedView = subview.findSubview(ofType: type) { return typedView }
        }
        return nil
    }

    func findSubview<T: UIView>(ofType type: T.Type, identifier: String) -> T? {
        if let typedView = self as? T, typedView.accessibilityIdentifier == identifier { return typedView }
        for subview in subviews {
            if let typedView = subview.findSubview(ofType: type, identifier: identifier) { return typedView }
        }
        return nil
    }

    func findButton(accessibilityLabel label: String) -> UIButton? {
        if let button = self as? UIButton, button.accessibilityLabel == label { return button }
        for subview in subviews {
            if let button = subview.findButton(accessibilityLabel: label) { return button }
        }
        return nil
    }

    func findLabel(withIdentifier identifier: String) -> UILabel? {
        if let label = self as? UILabel, label.accessibilityIdentifier == identifier { return label }
        for subview in subviews {
            if let label = subview.findLabel(withIdentifier: identifier) { return label }
        }
        return nil
    }
}
