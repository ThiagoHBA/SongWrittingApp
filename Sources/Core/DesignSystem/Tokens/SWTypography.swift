//
//  SWTypography.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

enum SWTypography {
    static let heroTitle = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: .systemFont(ofSize: 32, weight: .bold))
    static let sectionTitle = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 18, weight: .semibold))
    static let bodyStrong = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 18, weight: .semibold))
    static let body = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 16, weight: .regular))
    static let label = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: 14, weight: .medium))
    static let caption = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .systemFont(ofSize: 13, weight: .medium))
    static let button = UIFontMetrics(forTextStyle: .callout).scaledFont(for: .systemFont(ofSize: 16, weight: .semibold))
}
