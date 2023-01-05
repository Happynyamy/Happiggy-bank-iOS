//
//  LicenseViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import Foundation

/// 환경설정-고객지원-라이선스 항목의 뷰 모델
final class LicenseViewModel: InformationTextViewDataSource {
    
    // MARK: - Properties
    
    private(set) var navigationTitle: String?
    
    private(set) var attributedInformationString: NSAttributedString? = {
        let attributedString = licenseInformation
            .nsMutableAttributedStringify()
            .addHyperLinks(hyperlinks: hyperlinks)
        
        openSourceLibraries.forEach {
            attributedString.bold(targetString: $0, fontSize: Font.boldFontSize)
        }
        
        return attributedString
    }()
    
    
    // MARK: - Inits
    
    init(navigationTitle: String?) {
        self.navigationTitle = navigationTitle
    }
}
