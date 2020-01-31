//
//  RootViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu,RESideMenuDelegate {

    override func loadView() {
        super.loadView()
        self.setupSideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MAKR: - custom methods
    func setupSideMenu() {
        let leftMenu    = self.VC(sbName: "SideMenu", identifier: "leftMenuViewController")
        let mainVC    = self.VC(sbName: "Main", identifier: "MainViewController")
        

        self.leftMenuViewController = leftMenu
        self.contentViewController  = mainVC
        self.scaleMenuView = false
        self.scaleContentView = false
    }

}
