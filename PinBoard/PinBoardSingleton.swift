///
//  PinBoardSingleton.swift
//  PinBoard
//
//  Created by Salute on 28/07/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

// MARK: - Alias Names
typealias jsonDict = Dictionary<String,Any>
typealias jsonArray = Array<jsonDict>

class PinBoardSingleton: NSObject {
    static let sharedInstance: PinBoardSingleton = {PinBoardSingleton()}()

    public class func  GetvaluefromObject(objectName:String, ObjectList: Dictionary<String,Any>?,isReturn: Bool) -> String? {
        guard ObjectList != nil else {return ""}
        let isValidObject: Bool = PinBoardSingleton.nullToBool(value: ObjectList![objectName])
        return isValidObject ? PinBoardSingleton.nullToNil(value: ObjectList![objectName]) as! String   :  ""
    }

    public class func nullToBool(value : Any?) -> Bool {
        if value is NSNull || value == nil {
            return false
        } else {
            return true
        }
    }
    
    class func nullToNil(value : Any?) -> Any? {
        if value is NSNull || value == nil {
            return "" as Any?
        } else {
            if let a = value as? NSNumber {
                return a.stringValue
            } else {
                return (value as! String).uppercased() == "NULL"  ? "" : value
               
            }
        }
    }
    
}


// MARK: - Service Response Keys
enum APIKeys: String {
    case urls = "urls"
    case raw = "raw"
    case full = "full"
    case regular = "regular"
    case small = "small"
    case thumb = "thumb"
    case height = "height"
    case width = "width"
}



