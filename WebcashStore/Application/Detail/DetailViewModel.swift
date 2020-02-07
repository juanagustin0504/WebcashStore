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
//        var ago = Date().interval(ofComponent: .day, fromDate: dateFromMilli)
        
//        if ago >= 31 {
//            ago = Date().interval(ofComponent: .month, fromDate: dateFromMilli)

//            if ago > 12 {
//                ago = Date().interval(ofComponent: .year, fromDate: dateFromMilli)
//                return "\(ago) " + "years_ago".localiz()
//            }
//            return "\(ago) " + "months_ago".localiz()
//        }
//        return "\(ago) " + "days_ago".localiz()
        
        let calendar = Calendar.current
           let now = Date()
           let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .month, .year]
           let components = (calendar as NSCalendar).components(unitFlags, from: dateFromMilli, to: now, options: [])
           
           if let year = components.year, year >= 2 {
            return "\(year) " + "years_ago".localiz()
           }
           
           if let year = components.year, year >= 1 {
            return "year_ago".localiz()
           }
           
           if let month = components.month, month >= 2 {
            return "\(month) " + "months_ago".localiz()
           }
           
           if let month = components.month, month >= 1 {
            return "month_ago".localiz()
           }
           
           if let day = components.day, day >= 2 {
            return "\(day) " + "days_ago".localiz()
           }
           
           if let day = components.day, day >= 1 {
            return "day_ago".localiz()
           }
           
           if let hour = components.hour, hour >= 2 {
            return "\(hour) " + "hours_ago".localiz()
           }
           
           if let hour = components.hour, hour >= 1 {
            return "hour_ago".localiz()
           }
           
           if let minute = components.minute, minute >= 2 {
            return "\(minute) " + "minute_ago".localiz()
           }
           
           if let minute = components.minute, minute >= 1 {
            return "minute_ago".localiz()
           }
           
           if let second = components.second, second >= 3 {
            return "\(second) " + "seconds_ago".localiz()
           }
           
        return "moment_ago".localiz()
      
    }
    
    func getURLString(server : Server, atIndex index : Int = 0) -> String? {
        guard let obj = responseObj.ios?[index] else {
            return nil
        }
        
        return (server == .DevelopeServer ? obj.develop?.path : obj.real?.path)
    }
}
