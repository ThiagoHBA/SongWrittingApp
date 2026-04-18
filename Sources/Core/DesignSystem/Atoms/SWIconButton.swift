//
//  SWIconButton.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

final class SWIconButton: UIButton {
    init(symbolName: String, accessibilityLabel: String? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = SWColor.Accent.primary
        backgroundColor = SWColor.Accent.emphasisBackground
        layer.cornerRadius = SWRadius.pill
        setImage(
            UIImage(
                systemName: symbolName,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: SWSize.iconRegular,
                    weight: .bold
                )
            ),
            for: .normal
        )
        self.accessibilityLabel = accessibilityLabel
    }

    required init?(coder: NSCoder) { nil }
}
