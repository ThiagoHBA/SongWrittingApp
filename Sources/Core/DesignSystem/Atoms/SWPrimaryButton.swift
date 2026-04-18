//
//  SWPrimaryButton.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

final class SWPrimaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = SWColor.Accent.primary
        setTitleColor(SWColor.Content.inverse, for: .normal)
        titleLabel?.font = SWTypography.button
        layer.cornerRadius = SWRadius.medium
        setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) { nil }

    func updateTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
