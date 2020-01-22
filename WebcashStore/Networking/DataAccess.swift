//
//  DataAccess.swift
//  WebcashStore
//
//  Created by 위차이 on 1/17/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

class DataAccess {
    
    private init() { }
    
    static var shared: DataAccess = DataAccess()
    
    func request<I: Encodable, O: Decodable>(shouldShowLoading  : Bool = true,
                                             apiKey             : APIKey,
                                             httpMethod         : RequestMethod = .post,
                                             body               : I,
                                             responseType       : O.Type,
                                             completion         : @escaping (Result<Response<O>?, NSError>) -> Void) {
        if shouldShowLoading {
            DispatchQueue.main.async {
                Loading.shared.show()
            }
        }
        
        let request = self.request(apiKey: apiKey, body: body, httpMethod: httpMethod)
        
        APIManager.shared.fetchAPI(withRequest: request) { (result) in
            DispatchQueue.main.async {
                Loading.shared.dismiss()
            }
            switch result {
            case .failure(let err) :
                completion(.failure(err))
                
            case .success(let responseData) :
                
                guard let responseObject = responseData.dataToDecodableObject(responseType: Response<O>.self) else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : "Cannot convert Data to Resopnse Object"])
                        completion(.failure(error))
                    }
                    return
                }
                
                if responseObject.error == "invalid_token" {
                    let usename = ""
                    let password = ""
                    
                    LoginViewModel().requestToken(username: usename, andPassword: password) { (err) in
                        guard err == nil else {
                            DispatchQueue.main.async {
                                completion(.failure(err!))
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            completion(.success(nil))
                        }
                        
                    }
                    return
                }
                
                // other error
                if responseObject.error != nil {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : responseObject.error ?? ""])
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                Log.s("""
                    \(request.url!) | \(apiKey.rawValue)
                    \(responseData.prettyPrint())
                    """)
                
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            }
        }
    }
    
    private func request<T: Encodable>(apiKey: APIKey, body: T, httpMethod : RequestMethod = .post) -> URLRequest {
        let fullURL = APIKey.baseURL + apiKey.rawValue
        var request         = URLRequest(url: URL(string: fullURL)!)
        request.httpMethod  = httpMethod.rawValue
        
        
        if apiKey == .Token {
            let basicString     = APIKey.AuthKey//loginData.base64EncodedString()
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue( basicString, forHTTPHeaderField: "Authorization")
            
            let tempBody = body.dictionary
            let cookieHeader = (tempBody!.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }) as Array).joined(separator: "&")
            
            request.httpBody = cookieHeader.data(using: .ascii, allowLossyConversion: false)
        } else {
            let access_token = ShareInstance.shared.access_token
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue( "bearer " + access_token!, forHTTPHeaderField: "Authorization")
            
            if httpMethod == .post {
                request.httpBody = body.asJSONString()?.data(using: .utf8)
            }
        }
    
        Log.r("""
            \(request.url!) | \(apiKey.rawValue)
            \(body.asJSONString() ?? "")
            """)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    
}
