//
//  SideMenuCustomCell.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class SideMenuCustomCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - cusotm functions
    func configueCell(_ data : (img_name : String, title : String)) {
        let img = UIImage(named: data.img_name)
        self.img.image = img
        self.titleLbl.text = data.title.localiz()
    }

}
