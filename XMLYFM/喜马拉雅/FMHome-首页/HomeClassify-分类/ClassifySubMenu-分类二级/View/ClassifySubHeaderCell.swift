//
//  ClassifySubHeaderCell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/20.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import FSPagerView

class ClassifySubHeaderCell: UICollectionViewCell {
    private var focus:FocusModel?
    private var classifyCategoryContentsList:ClassifyCategoryContentsList?

    let ClassifySubCategoryCellID = "ClassifySubCategoryCell"
    // MARK: - 懒加载滚动图片浏览器
    private lazy var pagerView : FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.automaticSlidingInterval =  3
        pagerView.isInfinite = true
        pagerView.interitemSpacing = 15
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        return pagerView
    }()
    private lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
//        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        return layout
    }()
    // MARK: - 懒加载九宫格分类按钮
    private lazy var gridView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ClassifySubCategoryCell.self, forCellWithReuseIdentifier: ClassifySubCategoryCellID)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(150)
        }
        self.addSubview(self.gridView)
        self.gridView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.pagerView.snp.bottom)
            make.height.equalTo(80)
        }
        self.pagerView.itemSize = CGSize.init(width: YYScreenWidth-60, height: 140)
    }
    
    var focusModel:FocusModel? {
        didSet{
            guard let model = focusModel else { return }
            self.focus = model
            self.pagerView.reloadData()
        }
    }
    
    var classifyCategoryContentsListModel:ClassifyCategoryContentsList? {
        didSet{
            guard let model = classifyCategoryContentsListModel else {return}
            self.classifyCategoryContentsList = model
            if (self.classifyCategoryContentsList?.list?.count)! == 10 {
                self.layout.scrollDirection = UICollectionViewScrollDirection.vertical
            }else {
                self.layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            }
            self.gridView.reloadData()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// 顶部循环滚动视图
extension ClassifySubHeaderCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // MARK:- FSPagerView Delegate
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.focus?.data?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string:(self.focus?.data?[index].cover)!))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
}
// 顶部分类九宫格视图
extension ClassifySubHeaderCell:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classifyCategoryContentsList?.list?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell:ClassifySubCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubCategoryCellID, for: indexPath) as! ClassifySubCategoryCell
    cell.classifyVerticalModel = self.classifyCategoryContentsList?.list?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let num:Int = (self.classifyCategoryContentsList?.list?.count)!
        if num <= 6 {
            return CGSize.init(width: YYScreenWidth/CGFloat(num), height: 80)
        }else if num < 10 {
            return CGSize.init(width: YYScreenWidth/6, height: 80)
        }else {
            self.gridView.snp.updateConstraints { (make) in
                make.height.equalTo(160)
            }
            return CGSize.init(width: YYScreenWidth/5, height: 80)
        }
    }
}
