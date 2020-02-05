//
//  DetailViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 2/1/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit
import SDWebImage
class DetailViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var closeView: UIView! {
        didSet {
            self.closeView.isHidden = UIDevice.getOSVerstion() >= 13
        }
    }
    
    @IBOutlet weak var lineImage: UIImageView! {
        didSet {
            self.lineImage.isHidden = UIDevice.getOSVerstion() < 13
        }
    }
    
    
    @IBOutlet weak var appNameLbl: UILabelDynamicSizeClass! {
        didSet {
            self.appNameLbl.text = self.dataResponse.app_name
        }
    }
    
    @IBOutlet weak var appIconImage: UIImageView! {
        didSet {
            let url = URL(string: dataResponse.app_image ?? "")
            self.appIconImage.sd_setImage(with: url)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 150
        }
    }
    
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
    
    //MARK: - properties
    private var selectedIndex : IndexPath!
    var dataResponse : MainModel.Response!

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - custom method
    
    func downloadApp(server : Server, atIndex int : Int) {
        UIDevice.hapticWithStyle(style: .medium)
        let detailVM = DetailViewModel(responseObj: self.dataResponse)
        let url = detailVM.getURLString(server: server, atIndex: int)
        self.openWebURL(url: url ?? "")
    }
    
    //MARK: - button action
    @IBAction func realBtnDidClicked(_ sender: UIButtonDynamicSizeClass) {
        sender.scaleState()
        self.downloadApp(server: .RealServer, atIndex: sender.tag)
    }
    
    @IBAction func devBtnDidClicked(_ sender: UIButtonDynamicSizeClass) {
        sender.scaleState()
        self.downloadApp(server: .DevelopeServer, atIndex: sender.tag)
    }
    
    
    @IBAction func closeBtnDidTapped(_ sender: UIButton) {
        self.popOrDismissVC()
    }
    
}

//MARK: - tableview data source and delegate
extension DetailViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailCustomCell
        cell.configueCell(response: self.dataResponse, atindexPath: indexPath)
        
        if selectedIndex == indexPath {
            cell.expandCell()
        } else {
            cell.collapeCell()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataResponse.ios?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedIndex == indexPath {
            self.selectedIndex = nil
        } else {
            self.selectedIndex = indexPath
        }
        UIView.transition(with: self.tableView, duration: 0.3, options: [], animations: {
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath {
            return UITableView.automaticDimension
        } else {
            return 150
        }
    }
    
}
