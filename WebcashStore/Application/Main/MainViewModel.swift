//
//  MainViewModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

class MainViewModel {
    
    private(set) var mainResponse : [MainModel.Response]! = []
    private var coreDataManager : CoreDataManager!
    
    /// Fetch all record
    /// - Parameter completion: complete block
    func fetchMainList(completion : @escaping Completion_NSError) {
        
        DataAccess.shared.request(apiKey: APIKey.KS_IOS_MAIN, httpMethod: .get, body: MainModel.Request(), responseType: [MainModel.Response].self) { (result) in
            
            switch result {
            case .failure(let err):
                completion(err)
            case .success(let response):
                self.mainResponse = response?.DATA
                ShareInstance.shared.mainResponse = self.mainResponse
                completion(nil)
            }
            
        }
    }
    
    /// Search
    /// - Parameters:
    ///   - appName: App name to search
    ///   - completion: complete block
    func filter(appName text : String ) -> [MainModel.Response] {
        mainResponse.filter {
            ($0.app_name?.lowercased().contains(text.lowercased()))!
        }
    }
 
    /// Initialize a database
    func initDataBase() {
        if coreDataManager == nil {
            self.coreDataManager = CoreDataManager.shared
            self.coreDataManager.initalizeStack()
            
        }
    }
    
    /// Save App ID to a database
    /// - Parameter id: id to save
    func saveAppID(id : String) {
        
        let predic = NSPredicate(format: "app_id == %@", id)
        let arr = self.coreDataManager.fetch(withPredicate: predic, responseType: App.self, andEntityName: "App")
        
        if arr?.count == 0 {
            let appObj = App(context: self.coreDataManager.context)
            appObj.app_id = id
            self.coreDataManager.insert(obj: appObj)
        }
    }

    /// App Count
    /// - Parameter appID: App version ID
    static func requestAppCount(appID: String, completion : @escaping Completion) {
        let req = DownloadCount.Request(appversion_id: appID)
        DataAccess.shared.request(shouldShowLoading: false, apiKey: .KS_HAD_DOWNLOAD, httpMethod: .post, body: req, responseType: DownloadCount.Response.self) { (_) in
            completion()
        }
    }
}
