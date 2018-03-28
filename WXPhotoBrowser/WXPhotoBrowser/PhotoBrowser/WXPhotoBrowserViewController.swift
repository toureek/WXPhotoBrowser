//
//  WXPhotoBrowserViewController.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

class WXPhotoBrowserViewController: UIViewController, UIScrollViewDelegate, WXPhotoItemViewProtocol {
    
    var contentScrollView: UIScrollView?
    var contentView: UIView?
    var previousImageView: WXPhotoItemView?
    var currentImageView: WXPhotoItemView?
    var nextImageView: WXPhotoItemView?
    
    var currentImageIndex: Int?
    var dataList: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBarStyle()
        setUpViews()
        addAutoLayoutsForViews();
    }
    
    func setUpViews() {
        setUpScrollView()
        setUpContentView()
        setUpPhotoItemViews()
    }
    
    func addAutoLayoutsForViews() {
        addContentScrollViewAutoLayout()
        addContentViewAutoLayout()
        addPreviousImageViewAutoLayout()
    }
    
    func setUpNavigationBarStyle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpScrollView() {
        contentScrollView = UIScrollView.init()
        contentScrollView?.contentSize = CGSize.init(width: self.view.bounds.width, height: self.view.bounds.height)
        contentScrollView?.backgroundColor = .black
        contentScrollView?.isScrollEnabled = true
        contentScrollView?.showsVerticalScrollIndicator = false
        contentScrollView?.showsHorizontalScrollIndicator = false
        contentScrollView?.minimumZoomScale = 1
        contentScrollView?.maximumZoomScale = 4
        contentScrollView?.delegate = self
        contentScrollView?.bouncesZoom = true
        contentScrollView?.clipsToBounds = true
        contentScrollView?.contentOffset = .zero
        contentScrollView?.alwaysBounceVertical = true
        contentScrollView?.alwaysBounceHorizontal = true
        contentScrollView?.layer.borderColor = UIColor.red.cgColor
        contentScrollView?.layer.borderWidth = 1
        if #available(iOS 11, *) {
            contentScrollView?.contentInsetAdjustmentBehavior = .never;
        }
        self.view.addSubview(contentScrollView!)
    }
    
    func setUpContentView() {
        contentView = UIView.init()
        contentView?.backgroundColor = .white
        contentScrollView?.addSubview(contentView!)
    }
    
    func setUpPhotoItemViews() {
        previousImageView = WXPhotoItemView.init(frame: self.view.bounds)
        previousImageView?.delegate = self
        var photo: WXPhoto? = WXPhoto()
        photo?.index = 3;
        previousImageView?.photo = photo
        previousImageView?.layer.borderColor = UIColor.red.cgColor
        previousImageView?.layer.borderWidth = 1
        contentView?.addSubview(previousImageView!)
    }

    func addContentScrollViewAutoLayout() {
        contentScrollView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view)
        })
    }

    func addContentViewAutoLayout() {
        contentView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(contentScrollView!)
            make.width.height.equalTo(contentScrollView!)
            make.right.equalTo(previousImageView!)
        })
    }
    
    func addPreviousImageViewAutoLayout() {
        contentScrollView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(contentView!)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("no cycle-reference by uiviewcontroller")
    }
    
    // MARK: - UIScrollViewDelegate
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x, scrollView.contentOffset.y)
    }
    
    // MARK: - WXPhotoItemViewProtocol
    func triggerToResponseAfterSingleTapGestureOnPhotoItemAtIndex(photoIndex: Int) {
        print("WXPhotoItemViewProtocol")
        print(photoIndex)
    }
    
    
}
