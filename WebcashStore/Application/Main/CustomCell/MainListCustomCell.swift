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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func configCell(data : MainModel.Response) {
        let url = URL(string: data.app_image ?? "")
        self.appImage.sd_setImage(with: url) { (img, err, _, _) in
            if err == nil {

                img?.getColors({ (imageColors) in
                    self.wrapperView.backgroundColor = imageColors?.secondary
                    if self.wrapperView.backgroundColor!.isLight {
                        self.getBtn.backgroundColor = UIColor(hexString: "5578C0")
                        self.getBtn.setTitleColor(.white, for: .normal)
                    } else {
                        self.getBtn.backgroundColor = .white
                        self.getBtn.setTitleColor(.black, for: .normal)
                    }
                })
            } else {
                print("Error ")
            }
        }
        
        self.appNameLbl.text = data.app_name
    }
    
    func configDetailCell(data : MainModel.Response) {
        self.configCell(data: data)
    }
    
}
