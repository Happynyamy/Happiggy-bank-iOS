//
//  CustomTabBarController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/24.
//

import UIKit

/// 커스텀 탭바 컨트롤러
final class CustomTabBarController: UITabBarController {
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTabBar()
        self.observeCustomFontChange(selector: #selector(customFontDidChange(_:)))
    }
    
    // MARK: - @objc
    
    /// 폰트 변경 시 호출되는 메서드
    @objc private func customFontDidChange(_ notification: NSNotification) {
        guard let font = notification.object as? CustomFont
        else { return }
        
        self.changeTabBarFont(to: font)
    }
    
    // MARK: - Functions
    
    /// 내비게이션 바 초기 설정
    private func configureTabBar() {
        let key = UserDefaults.Key.font.rawValue
        guard let rawValue = UserDefaults.standard.value(forKey: key) as? Int,
              let font = CustomFont(rawValue: rawValue)
        else { return }
        
        self.changeTabBarFont(to: font)
    }
    
    /// 내비게이션 바 아이템 폰트 변경
    private func changeTabBarFont(to customFont: CustomFont) {
        guard let font = UIFont(name: customFont.regular, size: Font.tabBarItemSize)
        else { return }
        
        self.tabBar.items?.forEach {
            let attributes = [NSAttributedString.Key.font: font]
            $0.setTitleTextAttributes(attributes, for: .normal)
            $0.setTitleTextAttributes(attributes, for: .selected)
        }
    }
}
