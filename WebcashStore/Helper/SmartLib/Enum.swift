//
//  Enum.swift
//  SmartLib
//
//  Created by Vichhai on 2020/01/08.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

public enum LanguageCode : String {
    case Vietnamese     =   "vi"
    case Korean         =   "ko"
    case English        =   "en"
    case Japanese       =   "ja"
    case Chinese        =   "zh"
}

public enum DateType : String {
    case Year   = "yyyy"
    case Month  = "MMMM"
    case Day    = "dd"
    case KoreanShortFormat  =   "yyyy.MM.dd"
    case koreanFullFormat   =   "yyyy.MMMM.dd"
    case Time   =   "HH:mm:ss"
}

public enum RequestMethod: String {
    case get  = "GET"
    case post = "POST"
}

public enum ViewStyle : Int {
    case Detail = 300
    case Normal = 301
}

public enum SortBy : Int {
    case Accending  =   100 // A - Z
    case Descending =   101 // Z - A
}
