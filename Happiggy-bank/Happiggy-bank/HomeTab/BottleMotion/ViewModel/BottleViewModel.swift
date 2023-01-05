//
//  BottleViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/02/18.
//

import UIKit

// TODO: add access control
/// 서버에서 받은 데이터를 Bottle 뷰에 필요한 형식으로 변환해 주는 뷰 모델
final class BottleViewModel {
    
    // MARK: - Properties
    /// 홈 뷰에서 나타낼 저금통
    var bottle: Bottle?
    
    
    // MARK: - Functions
    
    /// 저금통 기간에 따른 그리드 프레임 리턴
    func gridFrame(forView view: UIView) -> CGRect {
        guard let bottle = bottle
        else { return .zero }

        var frame = view.bounds.inset(by: Metric.gridEdgeInsets)
        
        if bottle.duration < Metric.durationCap {
            frame.size.height -= Metric.shorterDurationHeightRemovalConstant
            frame.origin.y += Metric.shorterDurationHeightRemovalConstant
        }
        
        return frame
    }
}
