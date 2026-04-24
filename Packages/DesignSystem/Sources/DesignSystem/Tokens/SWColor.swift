import UIKit

public enum SWColor {
    public enum Background {
        public static let screen = UIColor.systemBackground
        public static let surface = UIColor.secondarySystemBackground
        public static let mutedSurface = UIColor.tertiarySystemBackground
    }

    public enum Content {
        public static let primary = UIColor.label
        public static let secondary = UIColor.secondaryLabel
        public static let inverse = UIColor.white
    }

    public enum Accent {
        public static let primary = UIColor.systemBlue
        public static let emphasisBackground = UIColor.tertiarySystemFill
    }

    public enum Destructive {
        public static let primary = UIColor.systemRed
    }

    public enum Border {
        public static let subtle = UIColor.separator
    }

    public enum Placeholder {
        public static let light = UIColor.systemGray5
        public static let dark = UIColor.systemGray3
    }
}
