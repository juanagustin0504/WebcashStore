//
//  RecentViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 2/9/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 50
        }
    }
    
    @IBOutlet weak var listOfAllAppsLbl: UILabelDynamicSizeClass!
    @IBOutlet weak var recentVisitedLbl: UILabelDynamicSizeClass!
    
    //MARK: properties
    fileprivate var mainListDataArr : [MainModel.Response] = []
    private lazy var recentVM = RecentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainListDataArr = recentVM.getRecentApps() ?? []
    }

    //MARK: - custom methods
    private func localize() {
        self.listOfAllAppsLbl.text = "list_of_all_apps".localiz()
        self.recentVisitedLbl.text = "recent_visited".localiz()
    }
    
    //MARK: - button actions

    @IBAction func backBtnDidTapped(_ sender: Any) {
        self.popOrDismissVC()
    }
    
    @objc func getBtnDidTapped(_ sender : UIButtonDynamicSizeClass) {
        let index = sender.tag
        let responseObj = mainListDataArr[index]
        
        let vc = self.VC(sbName: "Detail", identifier: DetailBottomViewController.storyboardIdentifier) as! DetailBottomViewController
        vc.detailVM.responseObj = responseObj
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension RecentViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MainListCustomCell!

        if mainListDataArr.count > 0 {
            let responseObj = mainListDataArr[indexPath.row]
            
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? MainListCustomCell
            cell.configDetailCell(data: responseObj)
            
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
        
        DispatchQueue.main.async {
            self.present(detailVC, animated: true, completion: nil)
        }
    }
}
