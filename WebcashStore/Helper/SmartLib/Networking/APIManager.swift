//
//  APIManager.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/22/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

public enum RequestMethod: String {
    case get  = "GET"
    case post = "POST"
}

struct APIManager {
    
//    private static var sharedInstance   =
    private static var sessionConfig    : URLSessionConfiguration!
    private static var session          : URLSession!
    var shouldReplacePlusWithSpace      : Bool  = false
    
    static var shared: APIManager = {
        
        // Timeout Configuration
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        sessionConfig.urlCache?.removeAllCachedResponses() // clear URL cache
        session = URLSession(configuration: sessionConfig)
        return APIManager()
    }()
    
    func fetchAPI(withRequest request : URLRequest,
                  httpMethod method : RequestMethod = RequestMethod.post,
                  completion         : @escaping (Result<Data, NSError>) -> Void) {
        
        APIManager.session.dataTask(with: request) { (data, urlResponse, error) in
            
            // Server Error
            if let error = error {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription])
                Log.e("""
                    \(request.url!)
                    \(error.localizedDescription)
                    """)
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
            
            // Network error | Request timeout
            guard let data = data else {
                let timeout = NSError(domain: "", code: 1004, userInfo: [NSLocalizedDescriptionKey : "통신중 시간 만료되었습니다. 잠시 후 다시 확인하여 주시기 바랍니다."])
                Log.e("""
                    \(request.url!)
                    Timeout Error.
                    """)
                
                DispatchQueue.main.async {
                    completion(.failure(timeout))
                }
                
                return
            }
            
            var decodedDataString = String(data: data, encoding: String.Encoding.utf8)?.removingPercentEncoding
            if APIManager.shared.shouldReplacePlusWithSpace {
                decodedDataString = decodedDataString?.replace(of: "+", with: " ")
            }
            
            // Data Converting Error
            guard let responseData = decodedDataString == nil ? data : decodedDataString?.data(using: .utf8) else {
                Log.e("""
                    \(request.url!)
                    Could not convert string to data.
                    """)
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : "Could not convert string to data."])
                    completion(.failure(error))
                }
                
                return
            }
            
            completion(.success(responseData))
        }.resume()
    }
    
}
