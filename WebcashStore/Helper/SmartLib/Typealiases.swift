//
//  Typealiases.swift
//  WebcashStore
//
//  Created by kosign webcash on 2/4/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

typealias Completion                = ()                -> Void
typealias Completion_Int            = (Int)             -> Void
typealias Completion_Bool           = (Bool)            -> Void
typealias Completion_NSError        = (NSError?)        -> Void
typealias Completion_String         = (String)          -> Void
typealias Completion_String_Error   = (String, Error?)  -> Void
