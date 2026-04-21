//
//  SWColor.swift
//  Main
//
//  Created by Thiago Henrique on 18/04/26.
//

import UIKit

enum SWColor {
    enum Background {
        static let screen = UIColor.systemBackground
        static let surface = UIColor.secondarySystemBackground
        static let mutedSurface = UIColor.tertiarySystemBackground
    }

    enum Content {
        static let primary = UIColor.label
        static let secondary = UIColor.secondaryLabel
        static let inverse = UIColor.white
    }

    enum Accent {
        static let primary = UIColor.systemBlue
        static let emphasisBackground = UIColor.tertiarySystemFill
    }
    
    enum Destructive {
         static let primary = UIColor.systemRed
     }

    enum Border {
        static let subtle = UIColor.separator
    }

    enum Placeholder {
        static let light = UIColor.systemGray5
        static let dark = UIColor.systemGray3
    }
}
