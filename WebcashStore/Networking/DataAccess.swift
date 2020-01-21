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
    
    //    static let manager = DataAccess()
    private static var sharedInstance   = DataAccess()
    private static var sessionConfig    : URLSessionConfiguration!
    private static var session          : URLSession!
//    private var loadingView        : LoadingViewController {
//        return UIStoryboard(name: "Loading", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
//    }
    private init() { }
    
    static var shared: DataAccess = {
        
        // Timeout Configuration
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        sessionConfig.urlCache?.removeAllCachedResponses() // clear URL cache
        session = URLSession(configuration: sessionConfig)
        return sharedInstance
    }()
    
    func request<I: Encodable, O: Decodable>(shouldShowLoading  : Bool = true,
                                             apiKey             : APIKey,
                                             httpMethod         : RequestMethod = .post,
                                             body               : I,
                                             responseType       : O.Type,
                                             completion         : @escaping (Result<Response<O>?, NSError>) -> Void) {
        if shouldShowLoading {
            DispatchQueue.main.async {
                Loading.shared.show()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        
        let request = self.request(apiKey: apiKey, body: body, httpMethod: httpMethod)
        
        DataAccess.session.dataTask(with: request) { (data, response, error) in
            if shouldShowLoading {
                DispatchQueue.main.async {
                    Loading.shared.dismiss()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            if let error = error {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription])
                Log.e("""
                    \(request.url!) | \(apiKey.rawValue)
                    \(error.localizedDescription)
                    """)
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
            
            guard let data = data else {
                let timeout = NSError(domain: "정상적으로 로그아웃 되었습니다.", code: 1004, userInfo: [NSLocalizedDescriptionKey : "통신중 시간 만료되었습니다. 잠시 후 다시 확인하여 주시기 바랍니다."])
                Log.e("""
                    \(request.url!) | \(apiKey.rawValue)
                    Timeout Error.
                    """)
                
                DispatchQueue.main.async {
                    completion(.failure(timeout))
                }
                
                return
            }
            
            let decodedDataString = String(data: data, encoding: String.Encoding.utf8)?.removingPercentEncoding
//            decodedDataString = decodedDataString?.replace(of: "+", with: " ")
            
            guard let responseData = decodedDataString == nil ? data : decodedDataString?.data(using: .utf8) else {
                Log.e("""
                    \(request.url!) | \(apiKey.rawValue)
                    Could not convert string to data.
                    """)
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : "Could not convert string to data."])
                    completion(.failure(error))
                }
                
                return
            }
            
            guard let responseObject = try? JSONDecoder().decode(Response<O>.self, from: responseData) else {
                var localizeDescription = responseData.prettyPrint()
                if responseData.prettyPrint() == "{\n\n}" {
                    
                    let htmlString = String(data: responseData, encoding: .utf8) ?? ""
                    
                    Log.e("""
                        \(request.url!) | \(apiKey.rawValue)
                        
                        Error Response:
                        \(responseData.prettyPrint())
                        \(htmlString)
                        """)
                    
                    localizeDescription = htmlString.html2String
                }
                else {
                    Log.e("""
                        \(request.url!) | \(apiKey.rawValue)
                        
                        Error mapping data.
                        Response:
                        \(responseData.prettyPrint())
                        """)
                }
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : localizeDescription])
                    completion(.failure(error))
                }
                
                return
            }
            
            // invalid token
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
        }.resume()
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
        }
        
        
        Log.r("""
            \(request.url!) | \(apiKey.rawValue)
            \(body.asJSONString() ?? "")
            """)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    
}
