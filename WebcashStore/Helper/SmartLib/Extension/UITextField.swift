//
//  UITextField.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/21/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
