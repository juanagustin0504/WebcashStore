//
//  RecentViewModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 2/9/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

class RecentViewModel {
    
    private var coreDataManager : CoreDataManager!
    
    init() {
        self.initDataBase()
    }
    
    func getRecentApps() -> [MainModel.Response]? {
        let app_ids = self.coreDataManager.fetchAll(responseType: App.self, entityName: "App")
        var responseObj = [MainModel.Response]()
        for app in app_ids! {
            let apps = ShareInstance.shared.mainResponse.filter {
                $0.app_id == app.app_id
            }
            responseObj.append(contentsOf: apps)
            
        }
        return responseObj
    }
    
    /// Initialize a database
    private func initDataBase() {
        if coreDataManager == nil {
            self.coreDataManager = CoreDataManager.shared
            self.coreDataManager.initalizeStack()
            
        }
    }
    
}
