//
//  HBError.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/16.
//

import Foundation

enum HBError: LocalizedError {
    case imageSaveFailure


    // MARK: - Properties
    
    var errorDescription: String? {
        switch self {
        case .imageSaveFailure:
            return NSLocalizedString("사진 저장에 실패했습니다.", comment: "image save failure")
        }
    }
}
