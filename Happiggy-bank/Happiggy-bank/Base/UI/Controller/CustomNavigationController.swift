//
//  CustomNavigationController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/24.
//

import UIKit

/// 커스텀 내비게이션 바
final class CustomNavigationController: UINavigationController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.observeCustomFontChange(selector: #selector(customFontDidChange(_:)))
    }
    
    
    // MARK: - @objc
    
    /// 폰트 변경 시 호출되는 메서드
    @objc private func customFontDidChange(_ notification: Notification) {
        
        guard let customFont = notification.object as? CustomFont
        else { return }
        
        self.changeNavigationBarFont(to: customFont)
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 초기 설정
    private func configureNavigationBar() {
        let key = UserDefaults.Key.font.rawValue
        guard let rawValue = UserDefaults.standard.value(forKey: key) as? Int,
              let font = CustomFont(rawValue: rawValue)
        else { return }
        
        self.changeNavigationBarFont(to: font)
    }
    
    /// 내비게이션 바 아이템 폰트 변경
    private func changeNavigationBarFont(to customFont: CustomFont) {
        guard let font = UIFont(name: customFont.regular, size: UIFont.labelFontSize)
        else { return }
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    }
}
