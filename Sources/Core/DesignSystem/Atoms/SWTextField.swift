//
//  SWTextField.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

final class SWTextField: UITextField {
    private let horizontalInset: CGFloat = SWSpacing.small

    init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        backgroundColor = SWColor.Background.surface
        textColor = SWColor.Content.primary
        font = SWTypography.body
        layer.cornerRadius = SWRadius.medium
        layer.borderWidth = 1
        layer.borderColor = SWColor.Border.subtle.cgColor
        autocorrectionType = .no
        autocapitalizationType = .sentences
        self.placeholder = placeholder
    }

    required init?(coder: NSCoder) { nil }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: horizontalInset, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: horizontalInset, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: horizontalInset, dy: 0)
    }
}
