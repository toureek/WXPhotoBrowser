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

class WXPhotoBrowserViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView?
    var currentImageIndex: Int?
    var dataList: Array<WXPhoto>?
    private var targetImageList: Array<WXPhoto>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildFakeDataSource()
        setUpNavigationBarStyle()
        setUpCollectionViewAndLayout()
    }
    
    func buildFakeDataSource() {
        var photo1: WXPhoto? = WXPhoto()
        photo1?.imageName = "1"
        photo1?.index = 1;

        var photo2: WXPhoto? = WXPhoto()
        photo2?.imageName = "2"
        photo2?.index = 2;

        var photo3: WXPhoto? = WXPhoto()
        photo3?.imageName = "3"
        photo3?.index = 3;

        dataList = [photo1!, photo2!, photo3!]
    }
    
    func setUpNavigationBarStyle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpCollectionViewAndLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = WXPhotoBrowserConstants.kImageViewSplitorPadding
        layout.minimumInteritemSpacing = WXPhotoBrowserConstants.kImageViewSplitorPadding
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.backgroundColor = .black
        collectionView?.isScrollEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.minimumZoomScale = 1
        collectionView?.maximumZoomScale = 4
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.clipsToBounds = true
        collectionView?.contentOffset = .zero
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.layer.borderColor = UIColor.yellow.cgColor
        collectionView?.layer.borderWidth = 1
        collectionView?.scrollsToTop = false;
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = true
        collectionView?.register(WXPhotoItemView.self, forCellWithReuseIdentifier: WXPhotoItemViewConstants.kWXPhotoItemViewIdentifier)
        if #available(iOS 11, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never;
        }
        self.view.addSubview(collectionView!)
        
        collectionView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("no cycle-reference by uiviewcontroller")
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleWithScrollingAnimation()
    }
    
    func handleWithScrollingAnimation() {
        let currentItemIndex: Int = Int.init(Double.init(collectionView!.contentOffset.x + UIScreen.main.bounds.width*0.5) / Double.init(UIScreen.main.bounds.width))
        let indexPath: NSIndexPath = NSIndexPath.init(row: currentItemIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataList?.count)!;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WXPhotoItemView = collectionView.dequeueReusableCell(withReuseIdentifier: WXPhotoItemViewConstants.kWXPhotoItemViewIdentifier, for: indexPath) as! WXPhotoItemView
        cell.photo = dataList?[indexPath.row]
        cell.updateUI()
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

}
