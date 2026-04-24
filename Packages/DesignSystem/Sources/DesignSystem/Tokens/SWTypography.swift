import UIKit

public enum SWTypography {
    public static let heroTitle = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: .systemFont(ofSize: 32, weight: .bold))
    public static let sectionTitle = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 18, weight: .semibold))
    public static let bodyStrong = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 18, weight: .semibold))
    public static let body = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 16, weight: .regular))
    public static let label = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: 14, weight: .medium))
    public static let caption = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .systemFont(ofSize: 13, weight: .medium))
    public static let button = UIFontMetrics(forTextStyle: .callout).scaledFont(for: .systemFont(ofSize: 16, weight: .semibold))
}
