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
    fileprivate var mainListDataArr : [MainModel.Response] = []
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
    
    @objc func getBtnDidTapped(_ sender : UIButtonDynamicSizeClass) {
        let index = sender.tag
        let responseObj = mainListDataArr[index]
        
        let vc = self.VC(sbName: "Detail", identifier: "DetailBottomViewController") as! DetailBottomViewController
        vc.detailVM.responseObj = responseObj

        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - custom methods
    fileprivate func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func fetchMainList() {
        mainVM.fetchMainList { (err) in
            guard err == nil else {
                self.alert(message: err?.localizedDescription ?? "")
                return
            }
            self.mainListDataArr = self.mainVM.mainResponse
            self.sortData()
        }
    }
    
    fileprivate func sortData() {
        switch self.sortBy {
        case .Accending:
            self.mainListDataArr = self.mainListDataArr.sorted {
                ($0.app_name ?? "") < ($1.app_name ?? "")
            }
        default:
            self.mainListDataArr = self.mainListDataArr.sorted {
                ($0.app_name ?? "") > ($1.app_name ?? "")
            }
        }
        
        DispatchQueue.main.async {
            self.reloadTableView()
        }
    }
}


//MARK: - tableview data source and delegate
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MainListCustomCell!

        if mainListDataArr.count > 0 {
            let responseObj = mainListDataArr[indexPath.row]
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
            
            cell.getBtn.tag = indexPath.row
            cell.getBtn.addTarget(self, action: #selector(getBtnDidTapped(_:)), for: .touchUpInside)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? MainListCustomCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainListDataArr.count == 0 ? 1 : mainListDataArr.count
    }
    
    
}

//MARK: - filter delegate
extension MainViewController : FilterDelegate {
    func filterDidApplied(sortBy: SortBy, listStyle: ViewStyle) {
        self.sortBy = sortBy
        self.viewStyle = listStyle
        
        self.sortData()
    }
}

//MARK: - textfield delegate
extension MainViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if !(textField.text?.trim().isEmpty)! {
            self.mainListDataArr = mainVM.filter(searchText: textField.text!)
            self.sortData()
        } else {
            self.mainListDataArr = mainVM.mainResponse
            self.sortData()
        }
        
        return true
    }
}
