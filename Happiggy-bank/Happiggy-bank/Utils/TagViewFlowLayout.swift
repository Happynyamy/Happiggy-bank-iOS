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
        
        let leftMargin = attributes.first?.frame.origin.x ?? self.sectionInset.left
        
        /// 각 셀을 순서대로 확인하면서 맨 좌측에 있는 셀은 그대로 두고 그 다음 셀의 시작 위치를 이전 셀의 너비 + spacing 한 값으로 설정
        for (index, value) in attributes.enumerated() {
            guard value.frame.origin.x != leftMargin,
                  index - 1 >= .zero
            else { continue }
            
            let previousCellmaxX = attributes[index - 1].frame.maxX
            
            value.frame.origin.x = previousCellmaxX + self.minimumLineSpacing
        }
        
        let contentMaxX: CGFloat = collectionViewContentSize.width - leftMargin
        let grouped = Dictionary(grouping: attributes, by: { $0.frame.minY })
        
        /// 가운데 정렬 작업
        grouped.values.forEach { attributes in
            let maxXs = attributes.map { $0.frame.maxX }
            let diff = (contentMaxX - maxXs.max()!)
            
            attributes.forEach { $0.frame.origin.x += diff / 2}
        }
        
        return attributes
    }
}
