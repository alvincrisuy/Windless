//
//  WindlessContext.swift
//  Windless-iOS
//
//  Created by gwangbeom on 2017. 11. 12..
//  Copyright © 2017년 Windless. All rights reserved.
//

import UIKit

enum LayerType {
    case animation
    case cover
}

class WindlessContext {
    
    weak var container: UIView!
    fileprivate var animationLayer = CAGradientLayer()
    fileprivate var coverLayer = CAShapeLayer()
    
    init(container: UIView) {
        self.container = container
        animationLayer.frame = container.bounds
        coverLayer.frame = container.bounds
        coverLayer.backgroundColor = container.backgroundColor?.cgColor
    }
    
    func layer(for type: LayerType) -> CALayer {
        switch type {
        case .animation: return animationLayer
        case .cover: return coverLayer
        }
    }
}

// MARK: internal
extension WindlessContext {
    
    // TODO: customizing
    func updateAnimationLayer(configuration: WindlessConfiguration) {
        animationLayer.startPoint = configuration.direction.location.start
        animationLayer.endPoint = configuration.direction.location.end
        animationLayer.colors = [configuration.animationBackgroundColor,
                                 configuration.animationLayerColor.withAlphaComponent(configuration.animationLayerOpacity),
                                 configuration.animationBackgroundColor].flatMap{ $0.cgColor }
        animationLayer.locations = DefaultAnimationValue.Locations.from
        animationLayer.backgroundColor = configuration.animationBackgroundColor.cgColor
    }
    
    func updateMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = Maker.makeWindlessableLayersPath(in: container).cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        coverLayer.mask = maskLayer
    }
    
    func updateLayerFrame(_ frame: CGRect) {
        animationLayer.frame = frame
        coverLayer.frame = frame
    }
}

// MARK: animation
extension WindlessContext {
    
    func start(_ animation: CAAnimation) {
        animationLayer.add(animation, forKey: AnimationKeys.locations)
    }
    
    func end() {
        animationLayer.removeAnimation(forKey: AnimationKeys.locations)
    }
}
