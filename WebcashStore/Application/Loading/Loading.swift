//
//  Loading.swift
//  Supark3.0
//
//  Created by admin on 08/03/2019.
//  Copyright © 2019 webcash. All rights reserved.
//

import UIKit

@objcMembers class Loading : NSObject {
    
    private var newLoadingImageView: UIImageView?
    private var myView: UIView?
    
    //Config singleton
    private override init() {}
    static let shared = Loading()
    
    lazy var imageLoadingStyle1: UIImageView = {
        var images = [UIImage]()
        for index in 1...8 {
            let imgSt = "loading_\(index)"
            let image = UIImage(named: imgSt)
            images.append(image!)
        }
        let img = UIImageView()
        img.animationImages = images
        img.animationDuration = 1.0
        img.animationRepeatCount = 0
        return img
    }()
    
    lazy var messageLoadingLb: UILabel = {
        var lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = .white
        return lb
    }()
    
    private func centerRect(objectWidth: CGFloat) -> CGRect {
        let height  : CGFloat = UIScreen.main.bounds.size.height
        let width   : CGFloat = UIScreen.main.bounds.size.width
        let center = CGPoint(x: (width - objectWidth)/2, y: (height - objectWidth)/2)
        let size = CGSize(width: objectWidth, height: objectWidth)
        return CGRect(origin: center, size: size)
    }
    
    private func setPositionMessageFrame() -> CGRect {
        let height  : CGFloat = UIScreen.main.bounds.size.height
        let width   : CGFloat = UIScreen.main.bounds.size.width
        let messageWidth = width - 32.0
        let center = CGPoint(x: (width - messageWidth)/2, y: (height/2) + 20)
        let size = CGSize(width: messageWidth, height: 60.0) //32 = margin ==> left: 16 + right: 16
        return CGRect(origin: center, size: size)
    }
    
    public func show(message: String = "loading".localiz()) {
        if (myView != nil) {
            if !message.isEmpty {
                messageLoadingLb.text = message
            }
            return
        }
        
        messageLoadingLb.text = message
//        let currentWindow = AppUtil().AppDelegate.window!
        let currentWindow = UIApplication.shared.keyWindow!
        
        if myView == nil {
            myView = UIView(frame: currentWindow.bounds)
            myView?.backgroundColor = UIColor.black.withAlphaComponent(0)
            UIView.animate(withDuration: 0.2) {
                self.myView?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            }
            newLoadingImageView = imageLoadingStyle1
        }
        
        guard let currentLV = newLoadingImageView else { return }
        if let forgroundView = myView {
            messageLoadingLb.frame = setPositionMessageFrame()
            
            currentLV.frame = centerRect(objectWidth: 60)
            forgroundView.layer.zPosition = 1001
            
            if forgroundView.superview == nil {
                currentWindow.addSubview(forgroundView)
            }
            
            if currentLV.superview == nil {
                forgroundView.addSubview(currentLV)
            }
            
            if messageLoadingLb.superview == nil {
                forgroundView.addSubview(messageLoadingLb)
            }
            
            currentLV.startAnimating()
        }
    }
    
    private func centerLoadingPoint(width: CGFloat) -> CGPoint {
        let c = width/2
        let p = CGPoint(x: c, y: c)
        return p
    }
    
    public func dismiss() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.myView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.newLoadingImageView?.stopAnimating()
            self.messageLoadingLb.attributedText = NSAttributedString(string: "")
            self.myView?.removeFromSuperview()
            self.myView = nil
            self.newLoadingImageView = nil
        }
    }
    
    public func forceDismiss() {
        self.messageLoadingLb.attributedText = NSAttributedString(string: "")
        self.newLoadingImageView?.stopAnimating()
        self.myView?.removeFromSuperview()
        self.newLoadingImageView = nil
        self.myView = nil
    }
    
    public func delayBeforeHide(seconds: Double = 0.5) {
        let time = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.dismiss()
        }
    }
    
}




















