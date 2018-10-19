//
//  PushpaCollectionViewLayout.swift
//  PushpaCollectionViewLayout
//
//  Created by Canopas on 19/10/18.
//  Copyright © 2018 Canopas Inc. All rights reserved.
//

import UIKit

class PushpaCollectionViewLayout: UICollectionViewLayout {
    
    public var itemSize: CGSize = CGSize(width: 280, height: 300) { didSet{ invalidateLayout() } }
    public var maximumVisibleItems: Int = 4 { didSet{ invalidateLayout() } }
    public var spacing:CGFloat = 10 { didSet { invalidateLayout() } }
    public var leftSpace:CGFloat = 12 { didSet { invalidateLayout() } }
    
    override open var collectionView: UICollectionView {
        return super.collectionView!
    }
    
    override open var collectionViewContentSize: CGSize {
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(width: collectionView.bounds.width * itemsCount,
                      height: collectionView.bounds.height)
    }
    
    override open func prepare() {
        super.prepare()
        assert(collectionView.numberOfSections == 1, "Multiple sections aren't supported!")
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    fileprivate var contentOffset:CGPoint   { return collectionView.contentOffset }
    fileprivate var bounds:CGRect           { return collectionView.bounds }
    fileprivate var totalCount:Int          { return collectionView.numberOfItems(inSection: 0) }
    fileprivate var minIndex:Int            { return max(Int(contentOffset.x) / Int(bounds.width), 0) }
    fileprivate var maxIndex:Int            { return min(minIndex + maximumVisibleItems, totalCount) }
    fileprivate var deltaOffset:CGFloat     { return CGFloat(Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width)) }
    fileprivate var percentDelta:CGFloat    { return CGFloat(deltaOffset) / bounds.width }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes:[UICollectionViewLayoutAttributes] = stride(from: minIndex, to: maxIndex, by: 1).map({ index in
            let path = IndexPath.init(item: index, section: 0)
            return self.getAttribute(for: path)
        })
        
        if minIndex > 0 {
            let previsItemAttr = IndexPath(item: minIndex - 1, section: 0)
            attributes.append(self.getAttribute(for: previsItemAttr))
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return getAttribute(for: indexPath)
    }
    
    fileprivate func getAttribute(for indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let spacing:CGFloat = 10
        let leftSpace:CGFloat = 12
        let firstVisibleIndex = indexPath.row - minIndex
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.center.x = self.contentOffset.x + bounds.width / 2 + spacing * CGFloat(firstVisibleIndex)
        attr.center.y = bounds.midY
        attr.size = itemSize
        attr.zIndex = maximumVisibleItems - firstVisibleIndex
        
        switch firstVisibleIndex {
        case -1:
            attr.center.x -= deltaOffset + bounds.width/2 + itemSize.width/2 - leftSpace - spacing
        case 0:
            attr.center.x -= ensureRange(value: deltaOffset, minimum: -bounds.width, maximum: bounds.width/2 + itemSize.width/2 - leftSpace)
        case 1..<maximumVisibleItems:
            attr.center.x -= spacing * percentDelta
            
            if firstVisibleIndex == maximumVisibleItems - 1 {
                attr.alpha = percentDelta
            }
            break
        default:
            attr.alpha = 0
            break
        }
        
        return attr
    }
}

//MARK: Helper
fileprivate func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
    return min(max(value, minimum), maximum)
}
