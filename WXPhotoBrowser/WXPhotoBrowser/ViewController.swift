//
//  ViewController.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView : UICollectionView?
    var dataList : Array<String>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBarStyle()
        setUpCollectionViewAndLayout()
    }
    
    func setUpNavigationBarStyle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        self.navigationItem.title = "First Page"
        self.view.backgroundColor = .blue
    }
    
    func setUpCollectionViewAndLayout() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

