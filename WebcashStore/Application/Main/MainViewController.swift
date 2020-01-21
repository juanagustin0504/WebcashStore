//
//  MainViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 50
        }
    }
    
    //MARK: properties
    fileprivate lazy var mainVM = MainViewModel()
    fileprivate var viewStyle : ViewStyle! = ViewStyle.Detail
    fileprivate var sortBy : SortBy! = SortBy.Accending
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchMainList()
    }

    //MARK: - button actions
    
    @IBAction func microphoneBtnDidTapped(_ sender: UIButton) {
        let popupVC = self.VC(sbName: "VoicePopup", identifier: "VoicePopupViewController")
        self.presentPopup(vc: popupVC)
    }
    
    @IBAction func filterBtnDidTapped(_ sender: UIButton) {
        let vc = self.VC(sbName: "Filter", identifier: "FilterViewController") as! FilterViewController
        vc.sortBy = self.sortBy
        vc.listStyle = self.viewStyle
        vc.delegate = self
        
        self.presentPopup(vc: vc)
    }
    
    //MARK: - custom methods
    fileprivate func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func fetchMainList() {
        mainVM.requestMainList { (err) in
            guard err == nil else {
                self.alert(message: err?.localizedDescription ?? "")
                return
            }
            self.reloadTableView()
        }
    }
}


//MARK: - tableview data source and delegate
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MainListCustomCell!
        let responseObj = mainVM.mainResponse[indexPath.row]
        
        switch viewStyle {
        case .Detail:
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? MainListCustomCell
            cell.configDetailCell(data: responseObj)
        case .Normal:
            cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as? MainListCustomCell
            cell.configCell(data: responseObj)
        case .none:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainVM.mainResponse.count
    }
    
    
}

//MARK: - filet delegate
extension MainViewController : FilterDelegate {
    func filterDidApplied(sortBy: SortBy, listStyle: ViewStyle) {
        self.sortBy = sortBy
        self.viewStyle = listStyle
        self.tableView.reloadData()
    }
}

