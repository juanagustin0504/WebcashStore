//
//  LoginViewModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    private(set) var loginModel : LoginModel.Response!
    
    /// 로그인 요청
    /// - Parameters:
    ///   - username: username
    ///   - pwd: password
    ///   - completion: complete closure
    func requestToken(username : String, andPassword pwd : String, completion: @escaping Completion_NSError) {
        
        let loginReq = LoginModel.Request(grant_type: "password", username: username, password: pwd)
        DataAccess.shared.request(apiKey: APIKey.Token, body: loginReq, responseType: LoginModel.Response.self) { (result) in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let res):
                self.loginModel = res?.DATA
                ShareInstance.shared.access_token = res?.access_token
                completion(nil)
            }
        }   
    }
}
