//
//  PinBoardLayout.swift
//  PinBoard
//
//  Created by Salute on 28/07/18.
//  Copyright © 2018 Maharani. All rights reserved.
//

import UIKit

// MARK: - Protocols
protocol PinBoardLayoutDelegate {
    
    // Request height of photo
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
                        withWidth:CGFloat) -> CGFloat
    
    // Request annotation for photo
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}



// MARK: - Class definition
class PinBoardLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    // Keep reference to the delegate
    var delegate: PinBoardLayoutDelegate!
    
    // Configure number of columns and cell padding
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    // This is an array to cache the calculated attributes.
    
    private var cache = [PinBoardLayoutAttributes]()
    
    // This declares two properties to store the content size.
    // contentHeight is incremented as photos are added
    private var contentHeight: CGFloat  = 0.0
    
    // contentWidth is calculated based on the collection view width and its content inset.
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    // Variable overrides
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return PinBoardLayoutAttributes.self
    }
    
    // MARK: - Overrides
    
    override func prepare() {
        
        // Only calculate if cache is empty
        if cache.isEmpty {
            
            /*  This declares and fills the xOffset array with the x-coordinate for every column based on the column widths.
             */
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            
            var xOffset = [CGFloat]()
            
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            /*  The yOffset array tracks the y-position for every column. You initialize each value in yOffset to 0, since this is the offset of the first item in each column.
             */
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = NSIndexPath(item: item, section: 0)
                
                // This is where you perform the frame calculation
                let width = columnWidth - cellPadding * 2
                // You ask the delegate for the height of the image
                let photoHeight = delegate.collectionView(collectionView!,
                                                          heightForPhotoAtIndexPath: indexPath,
                                                          withWidth:width)
                
                // You ask the delegate for the height of the annotation
                let annotationHeight = delegate.collectionView(collectionView!,
                                                               heightForAnnotationAtIndexPath: indexPath,
                                                               withWidth: width)
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = PinBoardLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                if column >= numberOfColumns - 1 {
                    column = 0
                } else {
                    column = column + 1
                }
                
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)             }
        }
        return layoutAttributes
    }
    
}

