//
//  PinBoardCell.swift
//  PinBoard
//
//  Created by Salute on 28/07/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

let pinBoardCell = "PinBoardCell"

class PinBoardCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var photo: PinPhoto? {
        didSet {
            setupImage()
        }
    }
    
    func setupImage() {
        if let Url = photo?.imageStrURL {
            imageView.loadImageUsingUrlString(Url)
        }
        
    }
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinBoardLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}

private var imageCache = NSCache<AnyObject, AnyObject>()
class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageUsingUrlString(_ urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }else {
            self.image = UIImage(named: "dummyImage")
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                } 
                if imageToCache?.size != nil {
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                }
            })
        }).resume()
    }
    
}
