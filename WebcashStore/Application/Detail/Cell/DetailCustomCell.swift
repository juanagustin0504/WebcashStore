//
//  DetailCustomCell.swift
//  WebcashStore
//
//  Created by kosign webcash on 2/1/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class DetailCustomCell: UITableViewCell {

    @IBOutlet weak var realBtn: UIButtonDynamicSizeClass! {
        didSet {
            self.realBtn.setTitle("real".localiz(), for: .normal)
        }
    }
    @IBOutlet weak var devBtn: UIButtonDynamicSizeClass! {
        didSet {
            self.devBtn.setTitle("develop".localiz(), for: .normal)
        }
    }
    @IBOutlet weak var versionLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var descriptionTitle: UILabelDynamicSizeClass!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var realAgoDateLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var devAgoDateLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var expandImg: UIImageView!
    @IBOutlet weak var newBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configueCell(response : MainModel.Response, atindexPath indexpath : IndexPath) {
        var detailVM = DetailViewModel(responseObj: response)
        
        self.versionLbl.text = "version".localiz() + " \(detailVM.responseObj.ios![indexpath.row].version ?? "")"

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
        
        self.newBtn.isHidden = !detailVM.isNewUpdate()

        self.descriptionTitle.text = "description".localiz()
        if (detailVM.responseObj.ios![indexpath.row].description?.isEmpty)! {
            self.descriptionLbl.text = "no_description".localiz()
        } else {
            self.descriptionLbl.text = detailVM.responseObj.ios![indexpath.row].description
        }

    }

    func expandCell() {
        self.expandImg.isHighlighted = true
        self.contentView.backgroundColor = UIColor(hexString: "E8E8E8")
    }
    
    func collapeCell() {
        self.expandImg.isHighlighted = false
        self.contentView.backgroundColor = .white
    }
    
    
    
}
