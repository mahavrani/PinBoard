//
//  PinBoardImageController.swift
//  PinBoard
//
//  Created by Salute on 28/07/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit
import AVFoundation

let reloadNotification = NSNotification.Name(rawValue: "PinBoardImageController")
class PinBoardImageController: UIViewController {
    var photos = PinPhoto.fetchPhotos()
     weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.collectionView.register(UINib(nibName: pinBoardCell,
                                                    bundle: Bundle(for: type(of :self))),
                                              forCellWithReuseIdentifier: pinBoardCell)
        // Set controller as delegate for layout
        if let layout = collectionView?.collectionViewLayout as? PinBoardLayout {
            layout.delegate = self
        }
        view.backgroundColor = UIColor.black
         let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        collectionView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        self.activityIndicatorView.startAnimating()
        
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
         NotificationCenter.default.addObserver(self, selector: #selector(PinBoardImageController.reloadData(_:)), name: reloadNotification, object: nil)
        self.collectionView.addSubview(self.refreshControl)
    }
    
    
    func reloadData(_ notification: NSNotification) {
        if let image =  notification.userInfo?["photos"] as? [PinPhoto] {
            photos  = image
        if photos.count > 0 {
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
        }
    }
    
    //MARK : Pull To Refresh Function
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(PinBoardImageController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.activityIndicatorView.stopAnimating()
        photos.removeAll()
        photos = PinPhoto.fetchPhotos()
        refreshControl.endRefreshing()
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func loadData() {
        //In Real time ,for load more we need to pass start index and end index to API to fetch ,for now this is the pseduo code.
        //print("load more data")
        //Call the API and reload the collection view
        //self.collectionView.reloadData()
        
    }
    }


extension PinBoardImageController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    //Pseudo Code for Load More Commented as the API to give startindex and end index is not there,
   /* func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            self.loadData()
        }
    } */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pinBoardCell, for: indexPath) as! PinBoardCell
        cell.photo = photos[indexPath.item]
        return cell
    }
    
}


extension PinBoardImageController : PinBoardLayoutDelegate {
    
    // This provides the height of the photos

    func collectionView(_ collectionView:UICollectionView,
                        heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        
        let photo = photos[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: CGSize(width:photo.width, height: photo.height) , insideRect: boundingRect)
        return rect.size.height
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(1)
        let height = annotationPadding
        return height
    }
    
}





