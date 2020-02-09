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
    private let sideMenuArr = [(img_name : "home", title : "home"),
                               (img_name : "recent", title : "recent_visited"),
                               (img_name : "setting", title : "settings")]
    
    

    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localizeSideMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(localizeSideMenu), name: NSNotification.Name("BackToMain"), object: nil)
    }
    
    
    //MARK: - custom functions
    @objc func localizeSideMenu() {
        self.copyrightLbl.text = "copyright © 2020 WEBCASH".localiz()
        print(sideMenuArr)
        self.reloadTableView()
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Recent"), object: nil)
        } else if indexPath.row == 2 { // Settings
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Settings"), object: nil)
        }
    }
    
}
