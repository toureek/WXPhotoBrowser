//
//  WXMainCollectionViewCell.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

struct WXMainCollectionViewCellConstants {
    static let kMainCollectionViewCellIdentifier = "kMainCollectionViewCellIdentifier"
}

class WXMainCollectionViewCell: UICollectionViewCell {
    
    var cellIndex : Int?
    var imageViewer : UIImageView?
    var imageNameString : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpMainViewCellAndLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpMainViewCellAndLayout() {
        imageViewer = UIImageView.init()
        imageViewer?.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageViewer!)

        imageViewer?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.contentView)
        })
    }
    
    func updateImageViewer() {
        var backgroundColor: UIColor?
        if let imgName = imageNameString {
            if imgName == "1" {
                backgroundColor = UIColor.black
            } else if imgName == "2" {
                backgroundColor = UIColor.brown
            } else if imgName == "3" {
                backgroundColor = UIColor.green
            } else if imgName == "4" {
                backgroundColor = UIColor.red
            } else {
                backgroundColor = UIColor.purple
            }
        } else {
            backgroundColor = UIColor.clear
        }
        imageViewer?.backgroundColor = backgroundColor
    }
    
}

