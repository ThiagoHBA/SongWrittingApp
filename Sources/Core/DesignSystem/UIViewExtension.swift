//
//  UIViewExtensions.swift
//  UI
//
//  Created by Thiago Henrique on 12/12/23.
//

import Foundation
import UIKit

extension UIView {
    var allTemplateViews: [UIView] {
        var views = [UIView]()
        getSubShimmerViews(&views)
        return views
    }
    private func getSubShimmerViews(_ views: inout [UIView], excludedViews: Set<UIView> = []) {
        var excludedViews = excludedViews
        if let view = self as? ShimmeringViewProtocol {
            excludedViews = excludedViews.union(view.excludedItems)
            views.append(contentsOf: view.shimmeringAnimatedItems.filter({ !excludedViews.contains($0) }))
        }
        subviews.forEach { $0.getSubShimmerViews(&views, excludedViews: excludedViews) }
    }
    func getFrame() -> CGRect {
        if let label = self as? UILabel {
            let width: CGFloat = intrinsicContentSize.width
            var horizontalX: CGFloat!
            switch label.textAlignment {
            case .center:
                horizontalX = bounds.midX - width / 2
            case .right:
                horizontalX = bounds.width - width
            default:
                horizontalX = 0
            }
            return CGRect(x: horizontalX, y: 0, width: width, height: intrinsicContentSize.height)
        }
        return bounds
    }
}

extension UIView {
    public func setTemplateWithSubviews(_ template: Bool,
                                        color: UIColor? = nil,
                                        animate: Bool = true,
                                        viewBackgroundColor: UIColor? = nil) {
        allTemplateViews.forEach {
            $0.setTemplate(template, baseColor: color)
            if animate {
                $0.setShimmeringAnimation(template, viewBackgroundColor: viewBackgroundColor)
            }
        }
    }
}

extension UIView {
    func setShimmeringAnimation(_ animate: Bool, viewBackgroundColor: UIColor? = nil) {
        let currentShimmerLayer = layer.sublayers?.first(where: { $0.name == Key.shimmer })
        if animate {
            if currentShimmerLayer != nil { return }
        } else {
            currentShimmerLayer?.removeFromSuperlayer()
            return
        }
        let baseShimmeringColor: UIColor? = viewBackgroundColor ?? superview?.backgroundColor
        guard let color = baseShimmeringColor else {
            return
        }
        // MARK: - Shimmering Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Key.shimmer
        gradientLayer.frame = getFrame()
        gradientLayer.cornerRadius = min(bounds.height / 2, 5)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradientColorOne = color.withAlphaComponent(0.5).cgColor
        let gradientColorTwo = color.withAlphaComponent(0.8).cgColor
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        gradientLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        // MARK: - Shimmer Animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.25
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
}

extension UIView {
    func setTemplate(_ template: Bool, baseColor: UIColor? = nil) {
        var color: UIColor
        if let baseColor = baseColor {
            color = baseColor
        } else {
            if #available(iOS 12, *), traitCollection.userInterfaceStyle == .dark {
                color = Color.Placeholder.dark
            } else {
                color = Color.Placeholder.light
            }
        }
        let currentTemplateLayer = layer.sublayers?.first(where: { $0.name == Key.template })
        if template {
            if currentTemplateLayer != nil { return }
        } else {
            currentTemplateLayer?.removeFromSuperlayer()
            layer.mask = nil
            return
        }
        let templateLayer = CALayer()
        templateLayer.name = Key.template
        setNeedsLayout()
        layoutIfNeeded()
        let templateFrame = getFrame()
        let cornerRadius: CGFloat = max(layer.cornerRadius, min(bounds.height/2, 5))
        // MARK: - Mask Layer
        let maskLayer = CAShapeLayer()
        let ovalPath = UIBezierPath(roundedRect: templateFrame, cornerRadius: cornerRadius)
        maskLayer.path = ovalPath.cgPath
        layer.mask = maskLayer
        // MARK: Template Layer
        templateLayer.frame = templateFrame
        templateLayer.cornerRadius = cornerRadius
        templateLayer.backgroundColor = color.cgColor
        layer.addSublayer(templateLayer)
        templateLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude - 1.0)
    }
}
