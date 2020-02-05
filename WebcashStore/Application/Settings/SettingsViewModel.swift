//
//  SettingsViewModel.swift
//  WebcashStore
//
//  Created by Webcash on 2020/02/03.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    private var pushNotificationResponse : SettingsModel.Response!
    
    func request_KS_PUSH_NOTIFICATION(completion : @escaping Completion_NSError) {
        
        let reqBody = SettingsModel.Request(divece_token: "3", platform_name: "2", platform_version: "2", platform_type: "3")
        
        DataAccess.shared.request(apiKey: APIKey.KS_PUSH_NOTIFICATION, httpMethod: .post, body: reqBody, responseType: [SettingsModel.Response].self) { (result) in

            switch result {
            case .failure(let err):
                completion(err)
            case .success(let response):
                completion(nil)
            }

        }
    }
}
