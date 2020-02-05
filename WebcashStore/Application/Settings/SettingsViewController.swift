//
//  SettingViewController.swift
//  WebcashStore
//
//  Created by Webcash on 2020/01/31.
//  Copyright © 2020 WebCash. All rights reserved.
//

import UIKit
import UserNotifications
import LanguageManager_iOS

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var touchAreaView: UIView!
    
    // Navigation View
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsTitle: UILabel!
    
    // Notification View
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var notification_detail: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    // Language Selection View(Header View)
    @IBOutlet weak var display_language: UILabel!
    @IBOutlet weak var choose_language: UILabel!
    
    // About Us View(Footer View)
    @IBOutlet weak var about_us: UILabel!
    @IBOutlet weak var about_us_detail: UILabel!
    
    let langList: [String] = ["한국어", "ខ្មែរ", "English"]
    let langImages: [UIImage?] = [UIImage(named: "Flag_of_Korea.png"), UIImage(named: "Flag_of_Cambodia.png"), UIImage(named: "Flag_of_US_UK.png")]
    let btnLangImages: [UIImage] = [UIImage(named: "radio_button_unchecked.png")!, UIImage(named: "radio_button_checked.png")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Back Button Image Setting
        let image = UIImage(named: "ic_expand_less.png")!
        let newImage = image.rotate(radians: .pi/2) // Rotate 90 degrees
        backButton.setImage(newImage, for: .normal)
        
        // ShadowView, NotificationView Setting
        applyRoundShadow()
        
        // Localizing
        localize()
        
        // When touched NotificationView, gotoNotificationSetting -> modify after login
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.gotoNotificationSetting (_:)))
        self.touchAreaView.addGestureRecognizer(gesture)
        
    }
    
    func applyRoundShadow() {
        
        let maskPath = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 30.0, height: 30.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.shadowView.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.backgroundColor = UIColor.clear.cgColor
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = maskPath.cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: -5.0)
        shadowLayer.shadowOpacity = 0.16
        shadowLayer.shadowRadius = 3
        
        shadowView.layer.insertSublayer(shadowLayer, at: 0)
        notificationView.layer.mask = maskLayer
    }
    
    // open Notification Setting
    @objc func gotoNotificationSetting(_ sender: UITapGestureRecognizer) {
        
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    UIApplication.shared.openURL(settingsUrl as URL)
                }
            }
        }
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        let selectedLanguage: Languages
        
        switch sender.tag {
        case 0:
            selectedLanguage = .ko
        case 1:
            selectedLanguage = .km
        default:
            selectedLanguage = .en
        }
        
        LanguageManager.shared.setLanguage(language: selectedLanguage)
        localize()
        
        self.tableView.reloadData()
    }
    
    func localize() {
        settingsTitle.text = "settings".localiz()
        notification.text = "notification".localiz()
        notification_detail.text = "notification_detail".localiz()
        display_language.text = "display_language".localiz()
        choose_language.text = "choose_language".localiz()
        about_us.text = "about_us".localiz()
        about_us_detail.text = "about_us_detail".localiz()
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage: Languages
        
        switch indexPath.row {
        case 0: // Korean
            selectedLanguage = .ko
        case 1: // Khmer
            selectedLanguage = .km
        default:
            selectedLanguage = .en
        }
        
        LanguageManager.shared.setLanguage(language: selectedLanguage)
        localize()
        
        self.tableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageSelectionCell else {
            return UITableViewCell()
        }
        
        cell.languageImageView.image = langImages[indexPath.row]!
        cell.lblLanguage.text = langList[indexPath.row]
        cell.btnSelection.tag = indexPath.row
        
        if indexPath.row == 0 {         // Korean
            cell.btnSelection.setBackgroundImage((LanguageManager.shared.currentLanguage == .ko) ? btnLangImages[1] : btnLangImages[0], for: .normal)
        } else if indexPath.row == 1 {  // Khmer
            cell.btnSelection.setBackgroundImage((LanguageManager.shared.currentLanguage == .km) ? btnLangImages[1] : btnLangImages[0], for: .normal)
        } else {                        // English
            cell.btnSelection.setBackgroundImage((LanguageManager.shared.currentLanguage == .en) ? btnLangImages[1] : btnLangImages[0], for: .normal)
        }
        return cell
    }
    
    
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
