//
//  WXPhotoBrowserViewController.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

struct WXPhotoBrowserConstants {
    static let kImageViewSplitorPadding: CGFloat = 10;
}

class WXPhotoBrowserViewController: UIViewController, UIScrollViewDelegate, WXPhotoItemViewProtocol {
    
    var contentScrollView: UIScrollView?
    var contentView: UIView?
    var previousImageView: WXPhotoItemView?
    var currentImageView: WXPhotoItemView?
    var nextImageView: WXPhotoItemView?
    
    var currentImageIndex: Int?
    var dataList: Array<String>?
    private var targetImageList: Array<WXPhoto>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBarStyle()
        setUpViews()
        addAutoLayoutsForViews();
        reloadImageView()
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
    
    func reloadImageView() {
        previousImageView?.updateUI()
        currentImageView?.updateUI()
        nextImageView?.updateUI()
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
        contentScrollView?.contentSize = CGSize.init(width: self.view.bounds.width*2+WXPhotoBrowserConstants.kImageViewSplitorPadding*2,
                                                     height: self.view.bounds.height)
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
        contentScrollView?.layer.borderColor = UIColor.yellow.cgColor
        contentScrollView?.layer.borderWidth = 1
        if #available(iOS 11, *) {
            contentScrollView?.contentInsetAdjustmentBehavior = .never;
        }
        self.view.addSubview(contentScrollView!)
    }
    
    func setUpContentView() {
        contentView = UIView.init()
        contentView?.backgroundColor = .black
        contentScrollView?.addSubview(contentView!)
    }
    
    func setUpPhotoItemViews() {
        previousImageView = WXPhotoItemView.init(frame: self.view.bounds)
        previousImageView?.delegate = self
        var photo1: WXPhoto? = WXPhoto()
        photo1?.imageName = "1"
        photo1?.index = 1;
        previousImageView?.photo = photo1
        previousImageView?.layer.borderColor = UIColor.orange.cgColor
        previousImageView?.layer.borderWidth = 1
        contentView?.addSubview(previousImageView!)
        
        currentImageView = WXPhotoItemView.init(frame: self.view.bounds)
        currentImageView?.delegate = self
        var photo2: WXPhoto? = WXPhoto()
        photo2?.imageName = "2"
        photo2?.index = 2;
        currentImageView?.photo = photo2
        currentImageView?.layer.borderColor = UIColor.green.cgColor
        currentImageView?.layer.borderWidth = 1
        contentView?.addSubview(currentImageView!)
        
        nextImageView = WXPhotoItemView.init(frame: self.view.bounds)
        nextImageView?.delegate = self
        var photo3: WXPhoto? = WXPhoto()
        photo3?.imageName = "3"
        photo3?.index = 3;
        nextImageView?.photo = photo3
        nextImageView?.layer.borderColor = UIColor.blue.cgColor
        nextImageView?.layer.borderWidth = 1
        contentView?.addSubview(nextImageView!)
    }

    func addContentScrollViewAutoLayout() {
        contentScrollView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view)
        })
    }

    func addContentViewAutoLayout() {
        contentView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(contentScrollView!)
            make.height.equalTo(contentScrollView!)
            make.width.equalTo(UIScreen.main.bounds.width*3+WXPhotoBrowserConstants.kImageViewSplitorPadding*2)
        })
    }
    
    func addPreviousImageViewAutoLayout() {
        previousImageView?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(contentView!)
            make.centerY.equalTo(contentView!)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        })
        
        currentImageView?.snp.makeConstraints({ (make) -> Void in
            make.top.bottom.equalTo(contentView!)
            make.left.equalTo(previousImageView!.snp.right).offset(10)
            make.centerY.equalTo(contentView!)
            make.size.equalTo(previousImageView!)
        })
        
        nextImageView?.snp.makeConstraints({ (make) -> Void in
            make.top.bottom.equalTo(contentView!)
            make.left.equalTo(currentImageView!.snp.right).offset(10)
            make.centerY.equalTo(contentView!)
            make.size.equalTo(previousImageView!)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: - WXPhotoItemViewProtocol
    func triggerToResponseAfterSingleTapGestureOnPhotoItemAtIndex(photoIndex: Int) {
        print("WXPhotoItemViewProtocol")
        print(photoIndex)
    }
    
    
}
