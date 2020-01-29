//
//  VoicePopupViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

let kMaxRadius: CGFloat = 150
let kMaxDuration: TimeInterval = 3

class VoicePopupViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var effectBlurView: UIVisualEffectView!
    @IBOutlet weak var microPhoneImg: UIImageView!
    //MARK: - properties
    var effectStyle : UIVisualEffect!
    let pulsator = Pulsator()
    private lazy var permissionMng = PermissionManager()
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectStyle = effectBlurView.effect
        self.effectBlurView.effect = nil
        self.animateBlurView()
        
        self.setupPulsatorView()
        self.requestSpeechPermission()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = microPhoneImg.layer.position
    }
    
    
    //MARK: - custom methods
    
    private func requestSpeechPermission() {
        permissionMng.requestSpeechPermission { (result) in
            if result {
                self.permissionMng.requestMicrophonePermission { (_result) in
                    if !_result {
                        self.alert(message: "Microphone Error") {
                            self.popOrDismissVC()
                        }
                    }
                }
            } else {
                self.alert(message: "Speech Recognition Error") {
                    self.popOrDismissVC()
                }
            }
        }
    }
    
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
        self.dismiss(animated: true)
        
    }
    
    @IBAction func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print("Long press `begin`")
            pulsator.start()
            self.permissionMng.startSpeechRecognition()
        case .ended:
            print("Long press `end`")
            pulsator.stop()
            self.permissionMng.stopSpeechRecognition()
        default:
            break
        }
    }
}
