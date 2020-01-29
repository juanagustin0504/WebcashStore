//
//  DetailBottomViewModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/23/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

enum Server : Int {
    case RealServer
    case DevelopeServer
}

struct DetailViewModel {
    var responseObj : MainModel.Response!
    
    func serverIsAvailable(version : Server, atIndex idx: Int = 0) -> Bool {
        
        guard let obj = responseObj.ios?[idx] else {
            return false
        }
        
        switch version {
            /**
             - if having uploaded date, server is available
             - else server is not availabble
             */
        case .RealServer:
            guard let _ = obj.real?.date else {
                return false
            }
            return true
        default:
            guard let _ = obj.develop?.date else {
                return false
            }
            return true
        }
    }
    
    func getAgoDate(server : Server, atIndex idx : Int = 0) -> String? {
        
        guard let obj = responseObj.ios?[idx] else {
            return nil
        }
        
        var dateInMilliSecond : Double!
        
        if server == .RealServer {
            dateInMilliSecond = obj.real?.date
        } else {
            dateInMilliSecond = obj.develop?.date
        }
        
        guard dateInMilliSecond != nil else {
            return nil
        }
        
        let dateFromMilli = Date.init(milliseconds: Int64(dateInMilliSecond))
        var ago = Date().interval(ofComponent: .day, fromDate: dateFromMilli)
        
        if ago >= 31 {
            ago = Date().interval(ofComponent: .month, fromDate: dateFromMilli)
            
            if ago > 12 {
                ago = Date().interval(ofComponent: .year, fromDate: dateFromMilli)
                return "\(ago) " + "yeas ago".localiz()
            }
            
            return "\(ago) " + "months ago".localiz()
        }
        
        return "\(ago) " + "days ago".localiz()
    }
    
    func getURLString(server : Server, atIndex index : Int = 0) -> String? {
        guard let obj = responseObj.ios?[index] else {
            return nil
        }
        
        return (server == .DevelopeServer ? obj.develop?.path : obj.real?.path)
    }
}
