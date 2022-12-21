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
        self.setColors()
        self.setNavigationControllers()
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
    
    /// 탭 바 컨트롤러 기본 색상 설정
    private func setColors() {
        self.view.backgroundColor = .systemBackground
        self.tabBar.barTintColor = .tabBarDivider
        self.tabBar.tintColor = .customTint
    }
    
    
    // TODO: - 각 NavigationController에 들어갈 ViewController 수정/교체
    /// 탭 바의 내비게이션 컨트롤러 배열 설정
    private func setNavigationControllers() {
        self.viewControllers = [
            createNavigationController(
                for: UIViewController(),
                title: StringLiteral.home,
                image: UIImage.homeIconNormal,
                selectedImage: UIImage.homeIconSelected
            ),
            createNavigationController(
                for: UIViewController(),
                title: StringLiteral.bottleList,
                image: UIImage.listIconNormal,
                selectedImage: UIImage.listIconSelected
            ),
            createNavigationController(
                for: UIViewController(),
                title: StringLiteral.settings,
                image: UIImage.settingsIconNormal,
                selectedImage: UIImage.settingsIconSelected
            )
        ]
    }
    
    /// 각 내비게이션 컨트롤러 기본 설정
    fileprivate func createNavigationController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage?,
        selectedImage: UIImage?
    ) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.isHidden = true
        
        return navigationController
    }
}


extension CustomTabBarController {
    
    /// 탭 바 컨트롤러에서 사용하는 문자열
    enum StringLiteral {
        
        /// 홈 화면 탭 바 아이템 타이틀
        static let home: String = "홈"
        
        /// 저금통 목록 화면 탭 바 아이템 타이틀
        static let bottleList: String = "저금통 목록"
        
        /// 환경설정 화면 탭 바 아이템 타이틀
        static let settings: String = "환경설정"
    }
}
