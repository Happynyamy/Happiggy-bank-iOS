//
//  LicenseViewModel.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import Foundation

/// 환경설정-고객지원-라이선스 항목의 뷰 모델
final class LicenseViewModel: InformationTextViewDataSource {
    
    private(set) var navigationTitle: String? = "라이선스"
    
    private(set) var attributedInformationString: NSAttributedString? = {
        licenseInformation
            .nsMutableAttributedStringify()
    }()
}
