//
//  FontManager.swift
//  Happiggy-bank
//
//  Created by sun on 2023/01/15.
//

import Combine
import Foundation

/// 폰트 관리 객체
final class FontManager: FontManaging {

    // MARK: - Properties

    /// 싱글턴 인스턴스
    static let shared = FontManager()

    /// 폰트 변경 사항을 구독하는 subscriber를 등록할 수 있는 Publisher
    var fontPublisher: Published<CustomFont>.Publisher { self.$font }

    /// 현재 커스텀 폰트
    @Published private(set) var font = CustomFont.current


    // MARK: - Functions

    func fontDidChange(to font: CustomFont) {
        guard font != self.font
        else {
            return
        }

        self.saveFont(font)
        self.font = font
    }

    // TODO: Repository?
    private func saveFont(_ font: CustomFont) {
        UserDefaults.standard.set(font.rawValue, forKey: UserDefaults.Key.font.rawValue)
    }
}
