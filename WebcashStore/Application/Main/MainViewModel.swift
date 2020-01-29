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
    
    func requestMainList(completion : @escaping Completion_NSError) {
        
        DataAccess.shared.request(apiKey: APIKey.KS_IOS_MAIN,
                                  httpMethod: .get,
                                  body: MainModel.Request(),
                                  responseType: [MainModel.Response].self) { (result) in
                                    
            switch result {
            case .failure(let err):
                completion(err)
            case .success(let response):
                self.mainResponse = response?.DATA
                completion(nil)
            }
        }
    }
    
    
    
    
    
    
}
