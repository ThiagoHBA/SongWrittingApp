//
//  SWTextLabel.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

final class SWTextLabel: UILabel {
    enum Style {
        case heroTitle
        case sectionTitle
        case bodyStrong
        case body
        case label
        case caption
    }

    init(style: Style, numberOfLines: Int = 1) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byWordWrapping
        self.numberOfLines = numberOfLines
        adjustsFontForContentSizeCategory = true
        apply(style: style)
    }

    required init?(coder: NSCoder) { nil }

    func apply(style: Style) {
        font = style.font
        textColor = style.color
    }
}

private extension SWTextLabel.Style {
    var font: UIFont {
        switch self {
        case .heroTitle:
            return SWTypography.heroTitle
        case .sectionTitle:
            return SWTypography.sectionTitle
        case .bodyStrong:
            return SWTypography.bodyStrong
        case .body:
            return SWTypography.body
        case .label:
            return SWTypography.label
        case .caption:
            return SWTypography.caption
        }
    }

    var color: UIColor {
        switch self {
        case .caption:
            return SWColor.Content.secondary
        default:
            return SWColor.Content.primary
        }
    }
}
