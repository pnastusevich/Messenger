//
//  GradientView.swift
//  Messenger
//
//  Created by Паша Настусевич on 2.10.24.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing
       
        var point: CGPoint {
            switch self {
            case .topLeading:
                CGPoint(x: 0, y: 0)
            case .leading:
                CGPoint(x: 0, y: 0.5)
            case .bottomLeading:
                CGPoint(x: 0, y: 1.0)
            case .top:
                CGPoint(x: 0.5, y: 0)
            case .center:
                CGPoint(x: 0.5, y: 0.5)
            case .bottom:
                CGPoint(x: 0.5, y: 1.0)
            case .topTrailing:
                CGPoint(x: 1.0, y: 0)
            case .trailing:
                CGPoint(x: 1.0, y: 0.5)
            case .bottomTrailing:
                CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    // для добавления градиента через сториборд
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    
    init(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setupGradient(from: from, to: to, startColor: startColor, endColor: endColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
    
    private func setupGradient(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors(startColor: startColor, endColor: endColor)
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
    }
    
    private func setupGradientColors(startColor: UIColor?, endColor: UIColor?) {
        if let startColor, let endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // для добавления градиента через сториборд
        setupGradient(from: .leading, to: .trailing, startColor: startColor, endColor: endColor)
    }
}
