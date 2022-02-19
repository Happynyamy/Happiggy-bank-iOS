//
//  HomeViewModel.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/19.
//

import UIKit

/// 서버에서 받은 데이터를 Home 뷰에 필요한 형식으로 변환해주는 뷰 모델
final class HomeViewModel {
    
    // TODO: Bottle Model 생성 및 관련 내용 추가
    
    /// 최초인지 아닌지 확인
    var hasBottle: Bool {
        return true
    }
    
    /// 현재 페이지 인덱스
    var currentIndex: Int = 0
    
    /// 현재 페이지 인덱스 업데이트 해 주는 연산 프로퍼티 -> 추후 데이터에 따라 변경 예정
    var updatedIndex: Int {
        get {
            return self.currentIndex
        }
        set(newIndex) {
            if newIndex >= 0 && newIndex < self.pageImages.count {
                self.currentIndex = newIndex
            }
        }
    }
    
    /// 각 페이지에 들어갈 이미지 이름 배열 -> 추후 데이터에 따라 변경 예정
    var pageImages: [String] {
        return ["bottle1", "bottle2", "bottle3", "bottle4"]
    }
}
