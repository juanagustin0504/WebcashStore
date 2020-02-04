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
    
    
    override func prepareForReuse() {
//        self.wrapperView.backgroundColor = self.wrapperView.backgroundColor 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configCell(data : MainModel.Response) {
        self.appImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        let url = URL(string: data.app_image ?? "")
        self.appImage.sd_setImage(with: url) { (img, err, _, _) in
            if err == nil {
                img?.getColors({ (imgColor) in
                    self.wrapperView.backgroundColor = imgColor?.background
                    self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
                })
            } else {
                self.appImage.image = UIImage(named: "image_placeholder")
                self.wrapperView.backgroundColor = UIColor(hexString: "F3F4EF")
                self.changeBtnBackgroundColor(color: self.wrapperView.backgroundColor)
            }
        }
        
        self.appNameLbl.text = data.app_name
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
