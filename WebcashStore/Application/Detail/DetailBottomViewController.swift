//
//  DetailViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/21/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit
import BottomPopup

class DetailBottomViewController: BottomPopupViewController {

    //MARK: - Outlets
    @IBOutlet weak var appName: UILabelDynamicSizeClass! {
        didSet {
            self.appName.text = self.detailVM.responseObj.app_name
        }
    }
    
    @IBOutlet weak var appImage: UIImageView! {
        didSet {
            let url = URL(string: detailVM.responseObj.app_image ?? "")
            self.appImage.sd_setImage(with: url)
        }
    }
    
    @IBOutlet weak var versionLbl: UILabelDynamicSizeClass! {
        didSet {
            self.versionLbl.text = "latest_version".localiz() +  "\((self.detailVM.responseObj.ios?.first)?.version ?? "")"
        }
    }

    @IBOutlet weak var realReleaseDateLbl: UILabelDynamicSizeClass! {
        didSet {
            self.realReleaseDateLbl.text = detailVM.getAgoDate(server: .RealServer) ?? "-"
        }
    }
    
    @IBOutlet weak var devReleaseDateLbl: UILabelDynamicSizeClass! {
        didSet {
            self.devReleaseDateLbl.text = detailVM.getAgoDate(server: .DevelopeServer) ?? "-"
        }
    }

    @IBOutlet weak var descriptionLbl: UILabelDynamicSizeClass! {
        didSet {
            self.descriptionLbl.text = "description".localiz()
        }
    }

    @IBOutlet weak var contentTextView: UITextViewDynamicSizeClass! {
        didSet {
            if ((self.detailVM.responseObj.ios?.first)?.description?.isEmpty)! {
                self.contentTextView.text = "no_description".localiz()
            } else {
                self.contentTextView.text = (self.detailVM.responseObj.ios?.first)?.description
            }
        }
    }
    
    
    @IBOutlet weak var realBtn: UIButtonDynamicSizeClass! {
        didSet {
            self.realBtn.backgroundColor = self.detailVM.serverIsAvailable(version: .RealServer) ? UIColor(hexString: "4B70FF") : UIColor(hexString: "BFBFBF")
            self.realBtn.isUserInteractionEnabled = self.detailVM.serverIsAvailable(version: .RealServer)
            self.realBtn.setTitle("real".localiz(), for: .normal)
        }
    }
    
    @IBOutlet weak var devBtn: UIButtonDynamicSizeClass! {
        didSet {
            self.devBtn.backgroundColor = self.detailVM.serverIsAvailable(version: .DevelopeServer) ? UIColor(hexString: "FF7137") : UIColor(hexString: "BFBFBF")
            self.devBtn.isUserInteractionEnabled = self.detailVM.serverIsAvailable(version: .DevelopeServer)
            self.devBtn.setTitle("develop".localiz(), for: .normal)
        }
    }
    
    //MARK: - properties
    lazy var detailVM = DetailViewModel()
    //MARK: - Override
    override var popupTopCornerRadius: CGFloat { 20 }
    override var popupPresentDuration: Double { 0.3 }
    override var popupDismissDuration: Double { 0.3 }
    override var popupShouldDismissInteractivelty: Bool { true }
    override var popupDimmingViewAlpha: CGFloat { 0.5 }
    override var popupHeight: CGFloat {
        if UIDevice.ScreenSize.SCREEN_MAX_LENGTH > 568.0 {
            return 500
        }
        return 458
        
    }
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: button action
    @IBAction func downloadBtnDidClicked(_ sender: UIButtonDynamicSizeClass) {
        sender.scaleState()
        UIDevice.hapticWithStyle(style: .medium)
        
        var url : String?
        if sender == realBtn {
            url = detailVM.getURLString(server: .RealServer)
        } else {
            url = detailVM.getURLString(server: .DevelopeServer)
        }
        
        self.openWebURL(url: url ?? "")
    }
}
