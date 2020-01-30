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
    
    /// Fetch all record
    /// - Parameter completion: complete block
    func fetchMainList(completion : @escaping Completion_NSError) {
        
        DataAccess.shared.request(apiKey: APIKey.KS_IOS_MAIN, httpMethod: .get, body: MainModel.Request(), responseType: [MainModel.Response].self) { (result) in
            
            switch result {
            case .failure(let err):
                completion(err)
            case .success(let response):
                self.mainResponse = response?.DATA
                completion(nil)
            }
            
        }
    }
    
    /// Search
    /// - Parameters:
    ///   - search: App name to search
    ///   - completion: complete block
//    func fetchMainList(searchWord search : String, completion : @escaping Completion_NSError) {
//        let body = MainModel.Search(search_text: search)
//        DataAccess.shared.request(apiKey: APIKey.KS_IOS_SEARCH, body: body, responseType: [MainModel.Response].self) { (result) in
//
//            switch result {
//            case .failure(let err) :
//                completion(err)
//            case .success(let response):
//                self.mainResponse = response?.DATA
//                completion(nil)
//            }
//        }
//    }
    
    func filter(searchText text : String ) -> [MainModel.Response] {
        mainResponse.filter {
            ($0.app_name?.lowercased().contains(text.lowercased()))!
        }
    }
}
