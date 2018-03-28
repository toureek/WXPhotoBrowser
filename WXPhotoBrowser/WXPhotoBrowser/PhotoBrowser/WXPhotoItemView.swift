//
//  WXPhotoItemView.swift
//  WXPhotoBrowser
//
//  Created by younghacker on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

protocol WXPhotoItemViewProtocol {
    func triggerToResponseAfterSingleTapGestureOnPhotoItemAtIndex(photoIndex: Int)
}


class WXPhotoItemView: UIView, UIScrollViewDelegate {
    
    var itemScrollView: UIScrollView?
    var itemImageViewer: UIImageView?
    
    var horizonModeSupported: Bool?
    var delegate: WXPhotoItemViewProtocol?
    var photo: WXPhoto?
    
    private var isCurrentImageViewTooHigh: Bool?
    private var currentImageViewWidthWhenImageTooHigh: CGFloat?
    private var currentImageViewHeight: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        setUpScrollView()
        setUpImageView()
        
        addScrollViewAutoLayout()
        addImageViewerAutoLayout()
    }

    func setUpScrollView() {
        itemScrollView = UIScrollView.init()
        itemScrollView?.contentSize = CGSize.init(width: self.bounds.width, height: self.bounds.height)
        itemScrollView?.backgroundColor = .black
        itemScrollView?.isScrollEnabled = true
        itemScrollView?.showsVerticalScrollIndicator = false
        itemScrollView?.showsHorizontalScrollIndicator = false
        itemScrollView?.minimumZoomScale = 1
        itemScrollView?.maximumZoomScale = 4
        itemScrollView?.delegate = self
        itemScrollView?.bouncesZoom = true
        itemScrollView?.clipsToBounds = true
        itemScrollView?.contentOffset = .zero
        itemScrollView?.alwaysBounceVertical = true
        itemScrollView?.alwaysBounceHorizontal = true
        if #available(iOS 11, *) {
            itemScrollView?.contentInsetAdjustmentBehavior = .never;
        }
        self.addSubview(itemScrollView!)
    }
    
    func setUpImageView() {
        itemImageViewer = UIImageView.init()
        itemImageViewer?.isUserInteractionEnabled = true
        itemImageViewer?.contentMode = .scaleAspectFill
        itemImageViewer?.image = UIImage.init(named: "2")
        let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didSingleTapGestureReceived))
        itemImageViewer?.addGestureRecognizer(singleTapGesture)
        itemScrollView?.addSubview(itemImageViewer!)
    }
    
    func addScrollViewAutoLayout() {
        itemScrollView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self)
        })
    }
    
    func addImageViewerAutoLayout() {
        let calculatedAutoLayout = autoLayoutCalculated()
        let calculatedImageHeight: CGFloat = currentImageViewHeight ?? 0
        itemImageViewer?.snp.remakeConstraints({ (make) -> Void in
            if calculatedAutoLayout && (isCurrentImageViewTooHigh == false) {
                make.width.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(calculatedImageHeight)
                make.center.equalTo(itemScrollView!)
            } else if calculatedAutoLayout && (isCurrentImageViewTooHigh == true) {
                make.height.equalTo(UIScreen.main.bounds.height)
                make.width.equalTo(currentImageViewWidthWhenImageTooHigh!)
                make.center.equalTo(itemScrollView!)
            } else {
                print("do nothing...")  // do nothing...
            }
        })
    }
    
    func autoLayoutCalculated() -> Bool {
        currentImageViewHeight = 0
        let imageObject: UIImage? = UIImage.init(named: "2") ?? nil
        if let imageObj = imageObject {
            if imageObj.size.height > self.bounds.height {
                let kImageViewerScalePoint: CGFloat = imageObj.size.height / self.bounds.height
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
        return itemImageViewer
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }

    
    // MARK: - Gesture Handlers
    
    @objc func didSingleTapGestureReceived() {
        let existSEL: Bool = (((delegate?.triggerToResponseAfterSingleTapGestureOnPhotoItemAtIndex(photoIndex: (photo?.index)!)) != nil))
        if (photo != nil) && (delegate != nil) && existSEL {
            delegate?.triggerToResponseAfterSingleTapGestureOnPhotoItemAtIndex(photoIndex: (photo?.index)!)
        }
    }

}
