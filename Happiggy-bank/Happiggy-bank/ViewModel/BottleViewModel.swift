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
    
    /// 새로 추가한 쪽지
    var newlyAddedNote: Note? {
        bottle?.notes.last
    }
    
    /// 새로 추가한 쪽지의 인덱스
    var newlyAddedNoteIndex: Int? {
        bottle == nil ? nil : bottle!.notes.count - 1
    }
}
