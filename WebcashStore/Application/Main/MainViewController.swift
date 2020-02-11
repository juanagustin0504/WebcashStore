//
//  MainViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchForApps: UITextFieldDynamicSizeClass!
    @IBOutlet weak var listOfAllAppsLbl: UILabelDynamicSizeClass!

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
    fileprivate var sortBy : SortBy! = SortBy.LatestUpdate
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchMainList()
        
        self.mainVM.initDataBase()
        self.localizeMainView()
        KeychainManager.setSynchronizable()
        
        self.setNotification()
    }

    //MARK: - button actions
    
    @IBAction func microphoneBtnDidTapped(_ sender: UIButton) {
        let popupVC = self.VC(sbName: "VoicePopup", identifier: VoicePopupViewController.storyboardIdentifier)
        self.presentPopup(vc: popupVC)
    }
    
    @IBAction func filterBtnDidTapped(_ sender: UIButton) {
        let vc = self.VC(sbName: "Filter", identifier: FilterViewController.storyboardIdentifier) as! FilterViewController
        vc.sortBy = self.sortBy
        vc.listStyle = self.viewStyle
        vc.delegate = self
        
        self.presentPopup(vc: vc)
    }
    
    @objc func getBtnDidTapped(_ sender : UIButtonDynamicSizeClass) {
        let index = sender.tag
        let responseObj = mainListDataArr[index]
        
        let vc = self.VC(sbName: "Detail", identifier: DetailBottomViewController.storyboardIdentifier) as! DetailBottomViewController
        vc.detailVM.responseObj = responseObj
        
        // save app id to database
        mainVM.saveAppID(id: responseObj.app_id ?? "")
        
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
        case .LatestUpdate:
            self.mainListDataArr = self.mainVM.mainResponse.reversed()
        case .Accending:
            self.mainListDataArr = self.mainListDataArr.sorted {
                ($0.app_name ?? "") < ($1.app_name ?? "")
            }
        case .Descending:
            self.mainListDataArr = self.mainListDataArr.sorted {
                ($0.app_name ?? "") > ($1.app_name ?? "")
            }
        default:
            print("default sortData")
        }
        
        DispatchQueue.main.async {
            self.reloadTableView()
        }
    }
    
    @objc func gotoSettingsVc() {
        
        let settingsSb = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVc = settingsSb.instantiateViewController(withIdentifier: "SettingsViewController_sid") as! SettingsViewController
        
        self.navigationController?.pushViewController(settingsVc, animated: true)
        
//        DispatchQueue.main.async {
//            self.pushVC(sbName: "Settings", identifier: "SettingsViewController_sid")
//        }
    }
    
    @objc func gotoRecentScreen() {
        let vc = self.VC(sbName: "RecentVisited", identifier: RecentViewController.storyboardIdentifier)
        self.pushVC(viewController: vc)
        
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(gotoSettingsVc), name: NSNotification.Name("Settings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(localizeMainView), name: NSNotification.Name("BackToMain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoRecentScreen), name: NSNotification.Name("Recent"), object: nil)
    }
    
    @objc func localizeMainView() {
        self.searchForApps.placeholder = "search_for_apps".localiz()
        self.listOfAllAppsLbl.text = "list_of_all_apps".localiz()
        
        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let responseObj = mainListDataArr[indexPath.row]

        let detailVC = self.VC(sbName: "Detail", identifier: DetailViewController.storyboardIdentifier) as! DetailViewController
        detailVC.dataResponse = responseObj
        
        // save app id to database
        mainVM.saveAppID(id: responseObj.app_id ?? "")
        DispatchQueue.main.async {
            self.present(detailVC, animated: true, completion: nil)
        }
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
            self.mainListDataArr = mainVM.filter(appName: textField.text!)
        } else {
            self.mainListDataArr = mainVM.mainResponse
        }
        self.sortData()
        return true
    }
}
