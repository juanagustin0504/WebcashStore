//
//  VoicePopupViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

let kMaxRadius: CGFloat = 150
let kMaxDuration: TimeInterval = 4

class VoicePopupViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var effectBlurView: UIVisualEffectView!
    @IBOutlet weak var microPhoneImg: UIImageView!
    //MARK: - properties
    var effectStyle : UIVisualEffect!
    let pulsator = Pulsator()

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectStyle = effectBlurView.effect
        self.effectBlurView.effect = nil
        self.animateBlurView()
        
        setupPulsatorView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = microPhoneImg.layer.position
    }
    
    
    //MARK: - custom methods
    private func animateBlurView() {
        UIView.animate(withDuration: 0.4) {
            self.effectBlurView.effect = self.effectStyle
        }
    }
    
    private func setupPulsatorView() {
        self.microPhoneImg.layer.superlayer?.insertSublayer(pulsator, below: microPhoneImg.layer)
        self.setupInitialValues()
        
    }
    
    private func setupInitialValues() {
        pulsator.numPulse = 6
        pulsator.animationDuration = kMaxDuration
        pulsator.backgroundColor = UIColor(hex: 707070).cgColor
        pulsator.radius = kMaxRadius
    }
    
    //MARK: - button action
    @IBAction func closeBtnDidTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print("Long press `begin`")
            pulsator.start()
        case .ended:
            print("Long press `end`")
            pulsator.stop()
        default:
            break
        }
    }
}
