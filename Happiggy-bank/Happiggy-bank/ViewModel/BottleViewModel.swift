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
    /// bottle 의 고유한 ID
    var bottleID: Int!
    
    var bottleName: String! {
        "행복냠냠이"
    }
    
    /// bottle의 채워진 정도에 따른 적절한 이미지
    var image: UIImage? {
        // TODO: Change note Progress numbers to enum?
        let noteProgress = self.noteProgress
        if noteProgress < 10 {
            return UIImage.bottle0
        }
        if noteProgress < 30 {
            return UIImage.bottle30
        }
        if noteProgress < 50 {
            return UIImage.bottle30
        }
        if noteProgress < 70 {
            return UIImage.bottle50
        }
        if noteProgress < 100 {
            return UIImage.bottle70
        }
        if noteProgress == 100 {
            return UIImage.bottle100
        }
        return UIImage.bottle0
    }
    
    /// bottle 의 개봉 여부
    var isOpen: Bool = {
        // TODO: 서버 API 받으면 수정
        // 1. bottle 의 종료 시점을 받아온다
        // 2. 현재 시점이 종료 시점보다 이르면 false, 같거나 느리면 true
        return false
    }()
    
    /// 오늘 note 작성 여부
    var hasTodaysNote: Bool {
        // TODO: 서버 API 받으면 수정
        // 1. 서버로부터 바로 오늘 쪽지를 썼는지 받아오거나 bottle 의 note 들을 받아온다
        // 2. note 들을 받아오는 경우 가장 마지막 note 를 확인한다
        // 3. note 의 생성 날짜가 오늘이면 true 아니면 false
        return false
    }
    
    /// 현재 bottle 이 채워진 정도
    private var noteProgress: Int {
        // TODO: 서버 API 받으면 수정
        // 1. bottle 의 시작 시점과 종료 시점을 받아 기간을 계산한다
        // 2. bottle 의 notes 개수를 직접 받아오거나 배열을 받아와서 개수를 계산한다
        // 3. 2의 notes 개수를 1의 기간으로 나눈 다음, 값을 내림한다
        return Int.random(in: 0...100)
    }
}
