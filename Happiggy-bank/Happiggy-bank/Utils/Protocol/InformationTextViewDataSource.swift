//
//  InformationTextViewDataSource.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import Foundation

/// 정보 텍스트 뷰 데이터 소스
protocol InformationTextViewDataSource: AnyObject {
    
    /// 내비게이션 바 제목
    var navigationTitle: String? { get }
    
    /// 정보 텍스트
    var attributedInformationString: NSAttributedString? { get }
}
