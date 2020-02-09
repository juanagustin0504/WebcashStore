//
//  FilterViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/21/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func filterDidApplied(sortBy : SortBy, listStyle : ViewStyle)
}

class FilterViewController: UIViewController {

    //MARK: - outlet
    @IBOutlet var sortRadioImages: [UIImageView]! {
        didSet {
            switch sortBy {
            case .Accending:
                sortRadioImages[0].isHighlighted = true
            default:
                sortRadioImages[1].isHighlighted = true
            }
        }
    }
    
    @IBOutlet var listRadionImages: [UIImageView]! {
        didSet {
            switch listStyle {
            case .Detail:
                listRadionImages[0].isHighlighted = true
            default:
                listRadionImages[1].isHighlighted = true
            }
        }
    }
    
    @IBOutlet weak var sortByLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var a2zLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var z2aLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var listStyleLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var applyBtn: UIButtonDynamicSizeClass!
    @IBOutlet weak var styleNormalLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var styleDetailLbl: UILabelDynamicSizeClass!
    
    
    //MARK: - properties
    var sortBy : SortBy = SortBy.Accending
    var listStyle : ViewStyle = ViewStyle.Detail
    var delegate : FilterDelegate?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeFilterView()
    }


    //MARK: - button actions
    @IBAction func sortActions(_ sender: UIButton) {
        sortRadioImages.forEach {
            $0.isHighlighted = false
        }
        
        let index = sender.tag - 100
        sortRadioImages[index].isHighlighted = true
        
        sortBy = SortBy(rawValue: sender.tag) ?? SortBy.Accending
        
    }
    
    
    @IBAction func listAction(_ sender: UIButton) {
        listRadionImages.forEach {
            $0.isHighlighted = false
        }
        
        let index = sender.tag - 300
        listRadionImages[index].isHighlighted = true
        
        self.listStyle = ViewStyle(rawValue: sender.tag) ?? ViewStyle.Detail
    }
    
    
    @IBAction func applyBtnDidTapped(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.filterDidApplied(sortBy: self.sortBy, listStyle: self.listStyle)
            self.popOrDismissVC()
        }
    }
    
    @IBAction func closeBtnDidTapped(_ sender: Any) {
        self.popOrDismissVC()
    }

    //MARK: - custom method
    func localizeFilterView() {
        self.sortByLbl.text         = "sort_the_list_by".localiz()
        self.a2zLbl.text            = "a_to_z".localiz()
        self.z2aLbl.text            = "z_to_a".localiz()
        self.listStyleLbl.text      = "select_list_styles_by".localiz()
        self.styleDetailLbl.text    = "detail".localiz()
        self.styleNormalLbl.text    = "normal".localiz()
        self.applyBtn.setTitle("apply_filter".localiz(), for: .normal)
    }
}
