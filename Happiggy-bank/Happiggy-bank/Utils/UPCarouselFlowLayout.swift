//  The MIT License (MIT)
//
//  Copyright (c) 2016 Paul Ulric
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  UPCarouselFlowLayout.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

/// 캐러셀 뷰에서 아이템 간 간격 설정 방식
public enum UPCarouselFlowLayoutSpacingMode {
    /// 아이템 간 고정 거리
    case fixed(spacing: CGFloat)
    /// 양옆 아이템이 보일 정도를 설정
    case overlap(visibleOffset: CGFloat)
}

/// 캐러셀 뷰를 구현하기 위한 컬렉션 플로우 레이아웃
final class UPCarouselFlowLayout: UICollectionViewFlowLayout {
    
    /// 레이아웃 상태
    fileprivate struct LayoutState {
        var size: CGSize
        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size)
        }
    }
    
    /// 양 옆 아이템:중앙 아이템 크기
    @IBInspectable public var sideItemScale: CGFloat = 0.6
    
    /// 양 옆 아이템:중앙 아이템 불투명도
    @IBInspectable public var sideItemAlpha: CGFloat = 0.6
    
    /// 양 옆 아이템의 x축 오프셋
    @IBInspectable public var sideItemShift: CGFloat = .zero
    
    /// 아이템 간 간격 설정 방식
    public var spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 40)
    
    fileprivate var state = LayoutState(size: .zero)
    
    
    override public func prepare() {
        super.prepare()
        let currentState = LayoutState(size: self.collectionView!.bounds.size)
        
        guard !self.state.isEqual(currentState)
        else { return }
        
        self.setupCollectionView()
        self.updateLayout()
        self.state = currentState
    }
    
    /// scroll deceleration 속도 설정
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView,
              collectionView.decelerationRate != .fast
        else { return }
        
        collectionView.decelerationRate = .fast
    }
    
    /// 섹션 크기를 아이템 사이즈로 조정
    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(
            top: yInset,
            left: xInset,
            bottom: yInset,
            right: xInset
        )
        
        
        let sideWidth = self.itemSize.width
        
        /// 좌우에 약간 보일 아이템들과 중앙에 있는 아이템들 사이의 간격
        let scaledItemOffset =  sideWidth * (1 - self.sideItemScale) / 2
        
        switch self.spacingMode {
        /// 고정 거리
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        /// 아이템일 보일 정도
        case .overlap(let visibleWidth):
            /// 중앙 아이템의 각 끝에서 컬렉션 뷰의 leading/trailing 까지의 거리
            let inset = xInset
            /// 아이템을 축소하면서 scaledItemOffset 만큼 더 떨어져 있는 것 처럼 보이기 때문에 visibleWidth 만큼 보이게 하려면
            /// 현재 스페이싱인 xInset 에서 해당 간격만큼을 빼줘야 함
            let fullSizeSideItemOverlap = visibleWidth + scaledItemOffset
            self.minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        /// 유저가 스크롤할 때마다 레이아웃을 업데이트 해야 하므로 true
        true
    }
    
    override public func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(
                array: superAttributes,
                copyItems: true
              ) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        
        return attributes.map { self.transformLayoutAttributes($0) }
    }
    
    ///
    fileprivate func transformLayoutAttributes(
        _ attributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView
        else { return attributes }
        
        let collectionViewCenter = collectionView.frame.size.width / 2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        
        /// 두 아이템 사이의 고정 간격
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        /// 컬렉션 뷰의 중앙과 아이템의 중앙 사이의 간격
        let distance = min(abs(collectionViewCenter - normalizedCenter), maxDistance)
        
        /// 컬렉션 뷰 중앙에 오면 1이 되고, 멀어지면 0이 됨
        /// 거리를 기준으로 투명도, 크기를 조정하기 위한 값
        let ratio = (maxDistance - distance) / maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        let shift = (1 - ratio) * self.sideItemShift
        
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)
        attributes.center.y = (attributes.center.y + shift)
        
        return attributes
    }
    
    /// 스크롤 시 항상 하나의 아이템으로 snap 하도록 오프셋 조정
    override public func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView,
              !collectionView.isPagingEnabled,
              let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
        else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let halfOfCenterWidth = collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOriginX = proposedContentOffset.x + halfOfCenterWidth

        /// 스크롤이 끝나서 업데이트 된 중앙 지점과 가장 가까운 레이아웃 어트리뷰트
        let closest = layoutAttributes.sorted {
            abs($0.center.x - proposedContentOffsetCenterOriginX) <
                abs($1.center.x - proposedContentOffsetCenterOriginX)
        }.first ?? UICollectionViewLayoutAttributes()

        /// 가장 가까운 아이템을 기준으로 스크롤할 새로운 지점의 origin 설정
        let adjustedTargetContentOffset = CGPoint(
            x: floor(closest.center.x - halfOfCenterWidth), y: proposedContentOffset.y
        )
        
        return adjustedTargetContentOffset
    }
}
