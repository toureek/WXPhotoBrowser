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
    static let kMainCollectionViewCellIndexErrorMsg = "Something Wrong Here"
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
        print(cellIndex ?? WXMainCollectionViewCellConstants.kMainCollectionViewCellIndexErrorMsg)
        if let imgName = imageNameString {
            imageViewer?.image = UIImage.init(named: imgName)
        } else {
            backgroundColor = UIColor.clear
        }
    }
    
}

