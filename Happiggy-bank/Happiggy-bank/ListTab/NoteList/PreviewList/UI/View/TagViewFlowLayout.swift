//
//  TagViewFlowLayout.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/25.
//

import UIKit

final class TagViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize { super.collectionViewContentSize }
    
    /// 가운데 정렬 수행
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]

        else { return nil }
        
        /// 순서대로 확인하면서 왼쪽으로 당기고, 다음 셀이 올 자리 업데이트
        var leftMargin = self.sectionInset.left
        var maxY: CGFloat = -.one
        
        attributes.forEach {
            /// 다음 행으로 이동 시 x좌표 위치를 왼쪽으로 리셋
            if $0.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            $0.frame.origin.x = leftMargin
            leftMargin += $0.frame.width + self.minimumInteritemSpacing
            maxY = max($0.frame.maxY, maxY)
        }
        
        let contentMaxX: CGFloat = collectionViewContentSize.width - sectionInset.right
        let grouped = Dictionary(grouping: attributes, by: { $0.frame.minY })

        /// 각 행 가운데 정렬 작업
        grouped.values.forEach { attributes in
            let maxXs = attributes.map { $0.frame.maxX }
            let diff = (contentMaxX - maxXs.max()!)

            attributes.forEach { $0.frame.origin.x += diff / 2}
        }
        
        /// 섹션 가운데 정렬 작업
        let bottomInset = self.sectionInset.bottom
        let contentHeight = self.collectionViewContentSize.height
        guard let collectionViewHeight = self.collectionView?.visibleSize.height,
              contentHeight <= collectionViewHeight - bottomInset
        else { return attributes }
        
        let yOffset = (collectionViewHeight - bottomInset - contentHeight) / 2
        attributes.forEach { $0.frame.origin.y += yOffset }
        
        return attributes
    }
}
