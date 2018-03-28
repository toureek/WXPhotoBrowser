//
//  ViewController.swift
//  WXPhotoBrowser
//
//  Created by June Young on 3/28/18.
//  Copyright © 2018 young. All rights reserved.
//

import UIKit
import SnapKit

struct WXViewControllerConstants {
    static let kCommonContentPaddingSpace: CGFloat = 15.0
    static let kCollectionViewerContentWidth: CGFloat = UIScreen.main.bounds.width - kCommonContentPaddingSpace*2
    static let kCollectionViewItemHeightWidth: CGFloat = floor((WXViewControllerConstants.kCollectionViewerContentWidth)/3.0)
}

class WXViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView : UICollectionView?
    var dataList : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBarStyle()
        setUpFakeData()
        setUpCollectionViewAndLayout()
    }
    
    func setUpNavigationBarStyle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        self.navigationItem.title = "First Page"
    }
    
    func setUpFakeData() {
        self.view.backgroundColor = .blue
        dataList = ["1", "2", "3", "4"]
    }
    
    func setUpCollectionViewAndLayout() {
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        collectionLayout.minimumLineSpacing = WXViewControllerConstants.kCommonContentPaddingSpace
        collectionLayout.minimumInteritemSpacing = WXViewControllerConstants.kCommonContentPaddingSpace
        collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: collectionLayout)
        collectionView?.layer.borderColor = UIColor.red.cgColor
        collectionView?.layer.borderWidth = CGFloat.leastNormalMagnitude
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(WXMainCollectionViewCell.self, forCellWithReuseIdentifier: WXMainCollectionViewCellConstants.kMainCollectionViewCellIdentifier)
        self.view.addSubview(collectionView!)
        
        collectionView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func existDataSource() -> Bool {
        if let list = dataList {
            return list.count > 0
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if existDataSource() {
            return dataList!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WXMainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: WXMainCollectionViewCellConstants.kMainCollectionViewCellIdentifier, for: indexPath) as! WXMainCollectionViewCell
        cell.imageNameString = dataList?[indexPath.row]
        cell.cellIndex = indexPath.row
        cell.updateImageViewer()
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if existDataSource() {
            return CGSize.init(width: WXViewControllerConstants.kCollectionViewItemHeightWidth, height: WXViewControllerConstants.kCollectionViewItemHeightWidth)
        }
        return CGSize.zero
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return existDataSource()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = WXPhotoBrowserViewController()
        vc.dataList = ["1"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
