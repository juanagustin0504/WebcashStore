//
//  IntroViewModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

class IntroViewModel {

    func requestToken(completion : @escaping Completion_NSError) {
        let loginVM = LoginViewModel()
        loginVM.requestToken(username: "webcash", andPassword: "123qweasd") { (err) in
            completion(err)
        }
    }
}
