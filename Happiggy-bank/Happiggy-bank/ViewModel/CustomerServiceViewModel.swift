//
//  CustomerServiceViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/20.
//

import UIKit

/// 고객 지원 뷰 컨트롤러의 뷰모델
final class CustomerServiceViewModel {
    
    // MARK: - Enums
    
    // 셀별 내용
    private enum Content: Int, CaseIterable {
        
        /// 라이선스
        case license
        
        
        // MARK: - Properties
        
        /// 제목 딕셔너리
        static let title: [Int: String] = [
            license.rawValue: ContentTitle.license
        ]
        
        /// 세그웨이 아이디 딕셔너리
        static let segueIdentifier: [Int: String] = [
            license.rawValue: segueIdentifier(for: license)
        ]
        
        
        // MARK: - Functions
        
        /// 케이스 이름을 카멜케이스로 변환
        private static func nameInCamelCase(_ contentCase: Content) -> String {
            var contentCase = "\(contentCase.self)"
            let firstLetter = contentCase.removeFirst().uppercased()
            
            return firstLetter.appending(contentCase)
        }
        
        /// 세그웨이 아이디 리턴
        private static func segueIdentifier(for contentCase: Content) -> String {
            "show\(nameInCamelCase(contentCase))View"
        }
    }
    
    
    // MARK: - Properties
    
    /// 섹션의 행 개수
    private(set) var numberOfRowsInSection = Content.allCases.count
    
    
    // MARK: - Functions
    
    /// 해당 칸의 제목 리턴
    func title(forContentAt indexPath: IndexPath) -> String? {
        Content.title[indexPath.row]
    }
    
    /// 세그웨이가 있다면 해당 세그웨이의 아이디 리턴
    func segueIdentifier(forContentAt indexPath: IndexPath) -> String? {
        Content.segueIdentifier[indexPath.row]
    }
}
