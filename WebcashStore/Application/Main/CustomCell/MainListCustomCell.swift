//
//  MainListCustomCell.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit
import UIImageColors
import SDWebImage

class MainListCustomCell: UITableViewCell {
    
    @IBOutlet weak var realServerDateLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var developServerDateLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var getBtn: UIButtonDynamicSizeClass!
    @IBOutlet weak var appNameLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var wrapperView: DesignableView!
    
    // define as cache for after downloading the image color 
    let cache = NSCache<NSString, UIColor>()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    func configCell(data : MainModel.Response) {
        
//        self.appImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        let url = URL(string: data.app_image ?? "")
//        self.appImage.sd_setImage(with: url) { (img, err, _, _) in
//            if err == nil {
//                img?.getColors({ (imgColor) in
//                    self.wrapperView.backgroundColor = imgColor?.background
//                    self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
//                })
//            } else {
//                self.appImage.image = UIImage(named: "image_placeholder")
//                self.wrapperView.backgroundColor = UIColor(hexString: "FFFFFF")
//                self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
//            }
//        }
        
        self.appNameLbl.text = data.app_name
        
        let key = NSString(string: data.app_image ?? "")

        // share to cache when every reuse data as array cache
        if cache.object(forKey: key) != nil{
            self.wrapperView.backgroundColor = cache.object(forKey: key)
            self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
        }else{
            self.appImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url = URL(string: key as String)
            self.appImage.sd_setImage(with: url) { (img, err, _, _) in
                DispatchQueue.main.async {
                    if err == nil {
                        img?.getColors({ (imgColor) in
                            self.wrapperView.backgroundColor = imgColor?.background
                            self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
                            self.cache.setObject((imgColor?.background)!, forKey: NSString(string: key))
                        })
                    } else {
                        self.appImage.image = UIImage(named: "image_placeholder")
                        self.wrapperView.backgroundColor = UIColor(hexString: "FFFFFF")
                        self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
                        self.cache.setObject(UIColor(hexString: "FFFFFF"), forKey: NSString(string: key))
                    }
                }
            }
        }
    }
    
    private func changeBtnBackgroundColor(color : UIColor?) {
        if color!.isLight {
            self.getBtn.backgroundColor = UIColor(hexString: "5578C0")
            self.getBtn.setTitleColor(.white, for: .normal)
        } else {
            self.getBtn.backgroundColor = .white
            self.getBtn.setTitleColor(.black, for: .normal)
        }
    }

    func configDetailCell(data : MainModel.Response) {
        self.configCell(data: data)
        
        let detailVM = DetailViewModel(responseObj: data)
        self.developServerDateLbl.text = detailVM.getAgoDate(server: .DevelopeServer) ?? "-"
        self.realServerDateLbl.text = detailVM.getAgoDate(server: .RealServer) ?? "-"
    }
    
}
