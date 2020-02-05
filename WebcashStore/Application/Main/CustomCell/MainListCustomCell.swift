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
    @IBOutlet weak var serverRealLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var serverDevelopLbl: UILabelDynamicSizeClass!
    
    
    // define as cache for after downloading the image color 
    let imgCache    = NSCache<NSString, UIImage>()
    let colorCache  = NSCache<NSString, UIColor>()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.appImage.image                 = nil
        self.wrapperView.backgroundColor    = nil
    }
    
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
        
        // set app_name as key for each cache
        let keyForCache = NSString(string: data.app_name ?? "")

        // share to cache when every reuse data as array cache
        if imgCache.object(forKey: keyForCache) != nil{
            self.appImage.image                 = imgCache.object(forKey: keyForCache)
            self.wrapperView.backgroundColor    = colorCache.object(forKey: keyForCache)
            self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
        }else{
            self.appImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url = URL(string: data.app_image!)
            self.appImage.sd_setImage(with: url) { (img, err, _, _) in
                DispatchQueue.main.async {
                    if err == nil {
                        img?.getColors({ (imgColor) in
                            self.wrapperView.backgroundColor = imgColor?.background
                            self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)

                            self.saveCache(image: img!, color:(imgColor?.background)!, key: NSString(string: keyForCache))
                        })
                    } else {
                        self.appImage.image = UIImage(named: "image_placeholder")
                        self.wrapperView.backgroundColor = UIColor(hexString: "FFFFFF")
                        self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
                        
                        self.saveCache(image: UIImage(named: "image_placeholder")!, color: UIColor(hexString: "FFFFFF"), key: NSString(string: keyForCache))
                    }
                }
            }
        }
        self.getBtn.setTitle("get".localiz(), for: .normal)
    }
    
    func saveCache(image : UIImage, color : UIColor , key: NSString){
        self.imgCache.setObject(image, forKey: key)
        self.colorCache.setObject(color, forKey: key)
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
        
        self.localizeCell()
    }
    
    func localizeCell() {
        self.getBtn.setTitle("get".localiz(), for: .normal)
        self.serverRealLbl.text = "server_real".localiz()
        self.serverDevelopLbl.text = "server_develop".localiz()
    }
    
}
