//
//  Grid.swift
//
//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

/// 직사각형 영역의 내부를 n개의 셀로 이루어진 그리드로 나눔
struct Grid {
    
    // MARK: - Properties
    
    /// 그리드를 만들 영역의 프레임
    /// 변경 시 셀 크기가 자동으로 조정됨
    var frame: CGRect { didSet {
        self.calculate()
    }}

    /// 너비/높이 비율
    /// 변경 시 셀 크기가 자동으로 조정됨
    var aspectRatio: CGFloat { didSet { self.calculate()} }
    
    /// 그리드 내부 셀 개수
    /// 변경 시 셀 크기가 자동으로 조정됨
    var cellCount: Int { didSet { self.calculate() }}
    
    /// 셀 크기
    var cellSize: CGSize { self.cellFrames.first?.size ?? .zero }
    
    /// 조건을 만족하는 최대 크기의 셀로 영역을 채울때 행, 열 수
    private(set) var dimensions: (rowCount: Int, columnCount: Int) = (.zero, .zero)

    /// 셀들의 프레임을 좌하단부터 순서대로 담고 있는 배열
    /// subscript 로 각 영역에 접근해서 UIView 의 프레임으로 사용하는 등 목적에 맞게 사용
    private var cellFrames = [CGRect]()
    
    
    // MARK: - Subscript
    
    /// 해당 인덱스의 셀 프레임이 있는 경우 프레임 반환
    subscript(index: Int) -> CGRect? {
        index < self.cellFrames.count ? self.cellFrames[index] : nil
    }
    
    
    // MARK: - Init
    
    /// 프레임, 셀 개수, 셀 너비/높이 비율을 설정하면 조건을 만족하는 가장 큰 셀 크기로 그리드를 구성
    init(frame: CGRect = .zero, cellCount: Int = .zero, aspectRatio: CGFloat = .one) {
        self.frame = frame
        self.cellCount = cellCount
        self.aspectRatio = aspectRatio
        self.calculate()
    }
    
    
    // MARK: - Functions
    
    /// 조건에 따라 그리드를 구성했을 때의 행, 열 개수를 계산하는 메서드
    private mutating func calculate() {
        let cellSize = largestCellSizeThatFits()
        
        guard cellSize.area > .zero
        else {
            self.dimensions = (.zero, .zero)
            self.updateCellFrames(to: cellSize)
            return
        }
        
        self.dimensions.columnCount = Int(self.frame.width / cellSize.width)
        /// 마지막 행은 꽉 차있지 않을 수도 있으므로 나머지로 계산되지 않도록 열 개수 - 1 만큼 추가
        self.dimensions.rowCount = (self.cellCount + self.dimensions.columnCount - 1) / self.dimensions.columnCount
        self.updateCellFrames(to: cellSize)
        
    }
    
    /// 계산한 셀 크기에 맞게 프레임 배열 업데이트
    private mutating func updateCellFrames(to cellSize: CGSize) {
    
        self.cellFrames.removeAll()
        
        /// 그리드의 실제 크기
        let boundingSize = CGSize(
            width: CGFloat(self.dimensions.columnCount) * cellSize.width,
            height: CGFloat(self.dimensions.rowCount) * cellSize.height
        )
        
        let offset = (
            dx: (self.frame.width - boundingSize.width) / 2,
            dy: (self.frame.height - boundingSize.height) / 2
        )
        
        /// 셀들이 실제로 그리드 내부 영역을 딱 맞게 채우지는 못하는 경우 가운데 정렬을 위해서 오프셋을 계산해 시작점을 옮겨줌
        var origin = self.frame.origin
        origin.x += offset.dx
        origin.y += (self.frame.maxY - cellSize.height)

        guard self.cellCount > .zero
        else { return }
        
        /// 맨 아래 행부터 좌->우 방향으로 cellFrame 배열 업데이트
        for _ in .zero..<self.cellCount {
            self.cellFrames.append(CGRect(origin: origin, size: cellSize))
            
            /// 다음 열로 위치 이동
            origin.x += cellSize.width
            
            /// 이번 행에 더 이상 셀을 넣을 수 없는 경우 한 행 위로 위치를 옮김
            if round(origin.x) > round(frame.maxX - cellSize.width) {
                origin.x = self.frame.origin.x + offset.dx
                origin.y -= cellSize.height
            }
        }
    }
    
    /// 주어진 조건을 만족하는 가장 큰 셀 크기를 구하는 메서드
    private func largestCellSizeThatFits() -> CGSize {
        guard self.cellCount > .zero && self.aspectRatio > .zero
        else { return .zero }
        
        var largestSoFar = CGSize.zero
        
        for count in 1...cellCount {
            largestSoFar = self.cellSizeAssuming(rowCount: count, largestSoFar: largestSoFar)
            largestSoFar = self.cellSizeAssuming(columnCount: count, largestSoFar: largestSoFar)
        }
        
        return largestSoFar
    }
    
    /// 행 혹은 열의 개수가 주어졌을 때 주어진 비율과 프레임을 만족하는 셀 사이즈를 구해서 현재 셀 사이즈와 차지하는 영역을 비교한 다음,
    /// 현재 셀 사이즈보다 크고, 셀 개수 조건을 충족하는 경우 새로운 값을, 아닐 경우 현재 셀 사이즈를 리턴
    private func cellSizeAssuming(
        rowCount: Int? = nil,
        columnCount: Int? = nil,
        largestSoFar: CGSize = .zero
    ) -> CGSize {
        var size = CGSize.zero
        
        /// 열 개수가 주어진 경우
        if let columnCount = columnCount {
            size.width = self.frame.width / CGFloat(columnCount)
            size.height = size.width / self.aspectRatio
        }
        /// 행 개수가 주어진 경우
        if let rowCount = rowCount {
            size.height = self.frame.height / CGFloat(rowCount)
            size.width = size.height * self.aspectRatio
        }
        
        /// 현재 셀 사이즈보다 차지하는 영역이 작은 경우 최대가 아니므로 현재 셀 사이즈 리턴
        guard size.area > largestSoFar.area
        else { return largestSoFar }
        
        let rowCount = Int(frame.size.height / size.height)
        let columnCount = Int(frame.size.width / size.width)
        
        
        /// 현재 셀 사이즈보다 크더라도 셀 개수를 만족시키지 못할 수 있으므로 확인 후 리턴
        return rowCount * columnCount >= self.cellCount ? size : largestSoFar
    }
}
