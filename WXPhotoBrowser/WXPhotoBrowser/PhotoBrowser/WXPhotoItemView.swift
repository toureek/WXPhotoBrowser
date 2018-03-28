//
//  WXPhotoItemView.swift
//  WXPhotoBrowser
//
//  Created by younghacker on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit

struct WXPhotoItemViewConstants {
    static let kWXPhotoItemViewIdentifier = "kWXPhotoItemViewIdentifier"
}

class WXPhotoItemView: UICollectionViewCell, UIScrollViewDelegate {
    
    var itemScrollView: UIScrollView?
    var itemImageViewer: UIImageView?
    
    var horizonModeSupported: Bool?  //  TODO:
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
    }
    
    func updateUI() {
        if isImageDataFormatVailable() {
            itemImageViewer?.image = UIImage.init(named: (photo?.imageName)!)
        }
        setNeedsUpdateConstraints()
    }
    
    private func isImageDataFormatVailable() -> Bool {
        if let itemPhoto = photo {
            let imageName = itemPhoto.imageName ?? ""
            let image = UIImage.init(named: imageName) ?? nil
            return nil != image
        }
        return false
    }
    
    override func updateConstraints() {
        addScrollViewAutoLayout()
        addImageViewerAutoLayout()
        
        super.updateConstraints()
    }

    private func setUpScrollView() {
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
        itemScrollView?.isPagingEnabled = true
        if #available(iOS 11, *) {
            itemScrollView?.contentInsetAdjustmentBehavior = .never;
        }
        self.contentView.addSubview(itemScrollView!)
    }
    
    private func setUpImageView() {
        itemImageViewer = UIImageView.init()
        itemImageViewer?.isUserInteractionEnabled = true
        itemImageViewer?.contentMode = .scaleAspectFill
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didDoubleTapGestureReceived(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        //TODO: LongPress Tap
        itemImageViewer?.addGestureRecognizer(doubleTapGesture)
        itemScrollView?.addSubview(itemImageViewer!)
    }
    
    private func addScrollViewAutoLayout() {
        itemScrollView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.contentView)
        })
    }
    
    private func addImageViewerAutoLayout() {
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
    
    private func autoLayoutCalculated() -> Bool {
        currentImageViewHeight = 0
        if isImageDataFormatVailable() {
            let imageObject: UIImage? = UIImage.init(named: (photo?.imageName)!)
            if imageObject!.size.height > self.bounds.height {
                let kImageViewerScalePoint: CGFloat = imageObject!.size.height / self.bounds.height
                currentImageViewWidthWhenImageTooHigh = UIScreen.main.bounds.width * kImageViewerScalePoint
                isCurrentImageViewTooHigh = true
            } else {
                isCurrentImageViewTooHigh = false
                let kImageViewerScalePoint: CGFloat = imageObject!.size.width / imageObject!.size.height
                currentImageViewHeight = UIScreen.main.bounds.width / kImageViewerScalePoint
            }
            return true
        }
        isCurrentImageViewTooHigh = false
        return false
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return itemImageViewer
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x, scrollView.contentOffset.y)
    }

    // MARK: - Gesture Handlers
    @objc func didDoubleTapGestureReceived(gesture: UITapGestureRecognizer) {
        if itemScrollView?.zoomScale == 1 {
            itemScrollView?.zoom(to: zoomingRectForScale(scale: (itemScrollView?.maximumZoomScale)!, center: gesture.location(in: gesture.view)), animated: true)
        } else {
            itemScrollView?.setZoomScale(1, animated: true)
        }
    }
    
    func zoomingRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = itemImageViewer!.frame.size.height / scale
        zoomRect.size.width  = itemImageViewer!.frame.size.width  / scale
        let newCenter = itemScrollView!.convert(center, from: itemImageViewer!)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
