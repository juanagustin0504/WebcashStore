//
//  UIImageView.swift
//  SmartLib
//
//  Created by God Save The King on 2020/01/08.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// start rotating an imageview
    /// - Parameter duration: duration
    public func startRotating(duration : Double = 1) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    /// Stop rotating an imageview
    func stopRotating() {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
