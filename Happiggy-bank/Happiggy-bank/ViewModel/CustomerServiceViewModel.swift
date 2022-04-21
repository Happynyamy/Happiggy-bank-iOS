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
    }
    
    
    // MARK: - Properties
    
    /// 섹션의 행 개수
    private(set) var numberOfRowsInSection = Content.allCases.count
    
    
    // MARK: - Functions
    
    /// 해당 칸의 제목 리턴
    func title(forContentAt indexPath: IndexPath) -> String? {
        Content.title[indexPath.row]
    }
    
    /// 내비게이션이 필요한 경우 내비게이션으로 넘어갈 뷰컨트롤러 리턴
    func destination(forContentAt indexPath: IndexPath) -> UIViewController? {
        let storyboard = UIStoryboard(name: mainStoryboardName, bundle: .main)

        if indexPath.row ==  Content.license.rawValue {
            return storyboard.instantiateViewController(
                identifier: InformationTextViewController.name
            ) { coder in
                let viewModel = LicenseViewModel(navigationTitle: ContentTitle.license)
                
                return InformationTextViewController(coder: coder, viewModel: viewModel)
            }
        }
        
        return nil
    }
}
