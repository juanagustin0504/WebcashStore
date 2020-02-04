//
//  DetailCustomCell.swift
//  WebcashStore
//
//  Created by kosign webcash on 2/1/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class DetailCustomCell: UITableViewCell {

    @IBOutlet weak var realBtn: UIButtonDynamicSizeClass!
    @IBOutlet weak var devBtn: UIButtonDynamicSizeClass!
    @IBOutlet weak var versionLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var realAgoDateLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var devAgoDateLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var expandImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configueCell(response : MainModel.Response, atindexPath indexpath : IndexPath) {
        let detailVM = DetailViewModel(responseObj: response)
        
        self.versionLbl.text = "Version : \(detailVM.responseObj.ios![indexpath.row].version ?? "")"

        realServerSetup: do {
            self.realBtn.backgroundColor = detailVM.serverIsAvailable(version: .RealServer, atIndex: indexpath.row) ? UIColor(hexString: "4B70FF") : UIColor(hexString: "BFBFBF")
            self.realBtn.isUserInteractionEnabled = detailVM.serverIsAvailable(version: .RealServer, atIndex: indexpath.row)
            self.realBtn.tag = indexpath.row
            self.realAgoDateLbl.text =  detailVM.getAgoDate(server: .RealServer,atIndex: indexpath.row) ?? "-"
        }
        
        developServerSetup: do {
            self.devBtn.backgroundColor = detailVM.serverIsAvailable(version: .DevelopeServer, atIndex: indexpath.row) ? UIColor(hexString: "FF7137") : UIColor(hexString: "BFBFBF")
            self.devBtn.isUserInteractionEnabled = detailVM.serverIsAvailable(version: .DevelopeServer, atIndex: indexpath.row)
            self.devBtn.tag = indexpath.row
            self.devAgoDateLbl.text =  detailVM.getAgoDate(server: .DevelopeServer,atIndex: indexpath.row) ?? "-"
        }
        
        if (detailVM.responseObj.ios![indexpath.row].description?.isEmpty)! {
            self.descriptionLbl.text = "No Description"
        } else {
            self.descriptionLbl.text = detailVM.responseObj.ios![indexpath.row].description
        }
        
        
    }

    func expandCell() {
        self.expandImg.isHighlighted = true
        self.contentView.backgroundColor = UIColor(hexString: "F5F5F5")
    }
    
    func collapeCell() {
        self.expandImg.isHighlighted = false
        self.contentView.backgroundColor = .white
    }
    
    
    
}
