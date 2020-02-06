//
//  PushNotificationViewModel.swift
//  WebcashStore
//
//  Created by Webcash on 2020/02/03.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationViewModel {
    
    private var pushNotificationResponse : PushNotificationModel?
    
    func requestDeviceToken(deviceToken: String, completion: @escaping Completion_NSError) {
        let pushReq = PushNotificationModel.Request(device_token: deviceToken, platform_name: UIDevice().type.rawValue, platform_version: String(UIDevice.getOSVerstion()), platform_type: "iOS")
        DataAccess.shared.request(apiKey: APIKey.KS_PUSH_NOTIFICATION, body: pushReq, responseType: PushNotificationModel.Response.self) { (result) in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let res):
                print(res ?? "")
                completion(nil)
            }
        }
    }
}
