//
//  WXPhotoBrowserViewController.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

class WXPhotoBrowserViewController: UIViewController, UIScrollViewDelegate {
    var contentScrollView: UIScrollView?
    var imageViewer: UIImageView?
    
    var isCurrentImageViewTooHigh: Bool?
    var currentImageViewWidthWhenImageTooHigh: CGFloat?
    var currentImageViewHeight: CGFloat?
    var currentImageIndex: Int?
    var dataList: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBarStyle()
        setUpViews()
        setUpAutoLayoutsForViews()
    }
    
    func setUpNavigationBarStyle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpViews() {
        setUpScrollView()
        setUpImageView()
    }
    
    func setUpAutoLayoutsForViews() {
        addScrollViewAutoLayout()
        addImageViewerAutoLayout()
    }
    
    func setUpScrollView() {
        contentScrollView = UIScrollView.init()
        contentScrollView?.contentSize = CGSize.init(width: self.view.bounds.width*3 + CGFloat.init(20*2), height: self.view.bounds.height)
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
    
    func setUpImageView() {
        imageViewer = UIImageView.init()
        imageViewer?.isUserInteractionEnabled = true
        imageViewer?.contentMode = .scaleAspectFill
        imageViewer?.image = UIImage.init(named: "2")
        let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didSingleTapGestureReceived))
        imageViewer?.addGestureRecognizer(singleTapGesture)
        contentScrollView?.addSubview(imageViewer!)
    }
    
    func addScrollViewAutoLayout() {
        contentScrollView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view)
        })
    }
    
    func addImageViewerAutoLayout() {
        let calculatedAutoLayout = autoLayoutCalculated()
        let calculatedImageHeight: CGFloat = currentImageViewHeight ?? 0
        imageViewer?.snp.remakeConstraints({ (make) -> Void in
            if calculatedAutoLayout && (isCurrentImageViewTooHigh == false) {
                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(calculatedImageHeight)
                make.center.equalTo(contentScrollView!)
            } else if calculatedAutoLayout && (isCurrentImageViewTooHigh == true) {
                make.height.equalTo(UIScreen.main.bounds.height)
                make.width.equalTo(currentImageViewWidthWhenImageTooHigh!)
                make.center.equalTo(contentScrollView!)
            } else {
                print("do nothing...")  // do nothing...
            }
        })
    }
    
    func autoLayoutCalculated() -> Bool {
        currentImageViewHeight = 0
        let imageObject: UIImage? = UIImage.init(named: "2") ?? nil
        if let imageObj = imageObject {
            if imageObj.size.height > self.view.bounds.height {
                let kImageViewerScalePoint: CGFloat = imageObj.size.height / self.view.bounds.height
                currentImageViewWidthWhenImageTooHigh = UIScreen.main.bounds.width * kImageViewerScalePoint
                isCurrentImageViewTooHigh = true
            } else {
                isCurrentImageViewTooHigh = false
                let kImageViewerScalePoint: CGFloat = imageObj.size.width / imageObj.size.height
                currentImageViewHeight = UIScreen.main.bounds.width / kImageViewerScalePoint
            }
            return true
        }
        isCurrentImageViewTooHigh = false
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("no cycle-reference by uiviewcontroller")
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("#################")
        print("scrollViewDidEndZooming")
        print(scrollView.contentOffset.x, scrollView.contentOffset.y)
        print("#################")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("----------------------------")
        print("viewForZooming")
        print(scrollView.contentOffset.x, scrollView.contentOffset.y)
        print("----------------------------")
        return imageViewer
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x, scrollView.contentOffset.y)
    }
    
    // MARK: - Gesture Handlers
    
    @objc func didSingleTapGestureReceived() {
        self.navigationController?.popViewController(animated: true)
    }

}
