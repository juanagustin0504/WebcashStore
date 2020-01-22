//
//  UIImage.swift
//  SmartLib
//
//  Created by God Save The King on 2020/01/08.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public convenience init(withBackground color: UIColor) {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(ciImage: CIImage(image: image)!)
    }
}

extension UIImage {
    
    public enum SendType : Int { // sending type
        case Full = 1 // full size image
        case HD = 2 // HD size image
        case SD = 3 // SD size image
    }
    
    public enum ImageType : Int { // image type
        case Portrait = 1
        case Landscape = 2
        case Square = 3
    }
    
    struct CheckImage { // check image type
        
        /// check image if it is landscape, portrait, or square
        ///
        /// - Parameter image: any image you want to check
        /// - Returns: return image type
        static func checkImageType(image : UIImage) -> ImageType {
            let size : CGSize = image.size
            let width : CGFloat = size.width
            let height : CGFloat = size.height
            
            if width > height {
                return ImageType.Landscape
            } else if width < height {
                return ImageType.Portrait
            } else {
                return ImageType.Square
            }
        }
        
    }
    
    /// resize image width and height
    ///
    /// - Parameters:
    ///   - image: any image you want to resize
    ///   - targetSize: any size you want to resize to
    /// - Returns: return new image with new width and height
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// Resize image to any type
    ///
    /// - Parameters:
    ///   - image: image to resize
    ///   - type: Full,HD or SD
    /// - Returns: new image after resize and compress
    public func resizingImage(toType type : SendType) -> UIImage{
        
        let originalWidth : Float = Float(self.size.width)
        let originalHeight : Float = Float(self.size.height)
        
        let imageType : ImageType = CheckImage.checkImageType(image: self)
        
        var resizedImage : UIImage = UIImage()
        
        switch imageType {
        case .Landscape: // landscape image
            switch type {
            case .Full: // full size
                resizedImage = self
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1440.0, fixH: 1080.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 960.0, fixH: 720.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            }
            
        case .Portrait: // Portrait image
            switch type {
            case .Full: // full size
                resizedImage = self
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1080.0, fixH: 1440.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 720.0, fixH: 960.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            }
            
        default: // Square image
            switch type {
            case .Full: // full size
                resizedImage = self
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1440.0, fixH: 1440.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 960.0, fixH: 960.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            }
        }
        
        return resizedImage
    }
    
    /// generate new CGSize for image
    ///
    /// - Parameters:
    ///   - fixW: new width
    ///   - fixH: new height
    ///   - originalH: original image height
    ///   - originalW: original image width
    /// - Returns: return new CGSize(width,height) for image
    private func getNewWidthAndHeight(fixW : Float,fixH : Float, originalH : Float,originalW: Float) -> CGSize {
        
        var newWidth : Float = 0.0
        var newHeight : Float = 0.0
        
        if originalW > fixW && originalH > fixH {
            newWidth = fixW
            newHeight = fixH
        } else if originalW > fixW && originalH < fixH {
            newWidth = fixW
            newHeight = originalH
        } else if originalW < fixW && originalH > fixH {
            newWidth = originalW
            newHeight = fixH
        } else if originalW < fixW && originalH < fixH {
            newWidth = originalW
            newHeight = originalH
        } else if originalW == fixW && originalH < fixH {
            newWidth = originalW
            newHeight = originalH
        }
            //fix crash on 28.02.2019, when image is too small
        else {
            newWidth = fixW
            newHeight = fixH
        }
        return CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight))
    }
}
