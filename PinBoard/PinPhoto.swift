//
//  PinPhoto.swift
//  PinBoard
//
//  Created by Salute on 28/07/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

class PinPhoto {
    
    class func fetchPhotos() -> [PinPhoto] {
        var photos = [PinPhoto]()
        var request = URLRequest(url: URL(string: baseUrl)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let getData = data else {
                return
            }
            do {
                let dict = try JSONSerialization.jsonObject(with: getData, options: JSONSerialization.ReadingOptions.allowFragments)
                let output = dict as! jsonArray
                guard output.isEmpty == false else {
                    return
                }
                for request in output {
                    //Appending only URLS key from the service.
                    let object = request[APIKeys.urls.rawValue] as? Dictionary<String,Any>
                    let height = request[APIKeys.height.rawValue] as? CGFloat
                    let width = request[APIKeys.width.rawValue] as? CGFloat
                    let raw = PinBoardSingleton.GetvaluefromObject(objectName: APIKeys.raw.rawValue, ObjectList: object,isReturn: false)!
                    photos.append(PinPhoto(imageURL: raw, height: height!, width: width!))
                    
                    let full = PinBoardSingleton.GetvaluefromObject(objectName: APIKeys.full.rawValue, ObjectList: object,isReturn: false)!
                    photos.append(PinPhoto(imageURL: full, height: height!, width: width!))
                    
                    let regular = PinBoardSingleton.GetvaluefromObject(objectName: APIKeys.regular.rawValue, ObjectList: object,isReturn: false)!
                    photos.append(PinPhoto(imageURL: regular, height: height!, width: width!))
                    
                    let small = PinBoardSingleton.GetvaluefromObject(objectName: APIKeys.small.rawValue, ObjectList: object,isReturn: false)!
                    photos.append(PinPhoto(imageURL: small, height: height!, width: width!))
                    
                    let thumb = PinBoardSingleton.GetvaluefromObject(objectName: APIKeys.thumb.rawValue, ObjectList: object,isReturn: false)!
                    photos.append(PinPhoto(imageURL: thumb, height: height!, width: width!))
                }
                DispatchQueue.main.async(execute: {
                    let dataDict:[String: Any] = ["photos": photos]
                    NotificationCenter.default.post(name:reloadNotification, object: nil,userInfo: dataDict)
                })
            
            }
            catch _ {
                print(error)
            }
        }
        task.resume()
        return photos
    }
    

    var imageStrURL: String,height:CGFloat,width:CGFloat
    init(imageURL : String,height:CGFloat,width:CGFloat) {
        self.imageStrURL = imageURL
        self.height = height
        self.width = width
       
    }
    
    

   

}


