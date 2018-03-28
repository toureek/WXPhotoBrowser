//
//  WXPhotoBrowserViewController.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

class WXPhotoBrowserViewController: UIViewController {
    var contentScrollView: UIScrollView?
    var currentImageIndex: Int?
    var dataList: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBarStyle()
        
    }
    
    func setUpNavigationBarStyle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
        self.navigationItem.title = "PhotoBrowser"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
