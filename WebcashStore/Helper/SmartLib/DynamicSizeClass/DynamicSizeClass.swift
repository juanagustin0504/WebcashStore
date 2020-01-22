//
//  File.swift
//  SmartLib
//
//  Created by God Save The King on 2020/01/08.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

public class UILabelDynamicSizeClass: UILabel {

    override public func awakeFromNib() {
        super.awakeFromNib()
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.font = self.font.withSize(self.font.pointSize)
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.font = self.font.withSize(self.font.pointSize + 2)
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.font = self.font.withSize(self.font.pointSize + 2)
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            self.font = self.font.withSize(self.font.pointSize + 3)
        default:
            self.font = self.font.withSize(self.font.pointSize + 3.5)
        }
    }
    
    public func overrideFontSize(fontSize:CGFloat){
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.font = self.font.withSize(self.font.pointSize)
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.font = self.font.withSize(self.font.pointSize + 2)
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.font = self.font.withSize(self.font.pointSize + 2)
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            self.font = self.font.withSize(self.font.pointSize + 3)
        default:
            self.font = self.font.withSize(self.font.pointSize + 3.5)
        }
    }
}

//for textfield
public class UITextFieldDynamicSizeClass: UITextField {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        guard let pointSize = self.font?.pointSize else { return }
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.font = self.font?.withSize(pointSize)
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.font = self.font?.withSize(pointSize + 2)
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.font = self.font?.withSize(pointSize + 2)
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            self.font = self.font?.withSize(pointSize + 3)
        default:
            self.font = self.font?.withSize(pointSize + 3.5)
        }
    }
}

//for button
public class UIButtonDynamicSizeClass: UIButton {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        guard let pointSize = self.titleLabel?.font.pointSize else { return }
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.titleLabel?.font = self.titleLabel?.font.withSize(pointSize)
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.titleLabel?.font = self.titleLabel?.font.withSize(pointSize + 2)
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.titleLabel?.font = self.titleLabel?.font.withSize(pointSize + 2)
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            self.titleLabel?.font = self.titleLabel?.font.withSize(pointSize + 3)
        default:
            self.titleLabel?.font = self.titleLabel?.font.withSize(pointSize + 3.5)
        }
    }
}

// for textView
public class UITextViewDynamicSizeClass: UITextView {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        guard let pointSize = self.font?.pointSize else { return }
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.font = self.font?.withSize(pointSize)
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.font = self.font?.withSize(pointSize + 2)
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.font = self.font?.withSize(pointSize + 2)
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            self.font = self.font?.withSize(pointSize + 3)
        default:
            self.font = self.font?.withSize(pointSize + 3.5)
        }
    }
}
