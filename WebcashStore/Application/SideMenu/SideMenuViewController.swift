//
//  SideMenuViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 60
        }
    }
    
    @IBOutlet weak var copyrightLbl: UILabelDynamicSizeClass!
    
    //MARK: - properties
    private let sideMenuArr = [(img_name : "home", title : "home".localiz()),
                               (img_name : "recent", title : "recent_visited".localiz()),
                               (img_name : "setting", title : "settings".localiz())]
    
    

    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeSideMenu()
    }
    
    
    //MARK: - custom functions
    func localizeSideMenu() {
        self.copyrightLbl.text = "copyright © 2020 WEBCASH".localiz()
    }
    
    fileprivate func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Tableview data source & delegate
extension SideMenuViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SideMenuCustomCell
        
        let data = sideMenuArr[indexPath.row]
        cell.configueCell(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideMenuViewController.hideViewController()
        self.tableView.deselectRow(at: indexPath, animated: true)
     
        if indexPath.row == 0 { // Home
            
        } else if indexPath.row == 1 { // Recent
            
        } else if indexPath.row == 2 { // Settings
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Settings"), object: nil)
        }
    }
    
}
