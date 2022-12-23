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
    
    /// 탭 바 초기 설정
    private func configureTabBar() {
        let key = UserDefaults.Key.font.rawValue
        guard let rawValue = UserDefaults.standard.value(forKey: key) as? Int,
              let font = CustomFont(rawValue: rawValue)
        else { return }
        
        self.configureBasicSettings()
        self.changeTabBarFont(to: font)
        self.setNavigationControllers()
    }
    
    /// 내비게이션 바 아이템 폰트 변경
    private func changeTabBarFont(to customFont: CustomFont) {
        guard let font = UIFont(name: customFont.regular, size: FontSize.caption2)
        else { return }
        
        self.tabBar.items?.forEach {
            let attributes = [NSAttributedString.Key.font: font]
            $0.setTitleTextAttributes(attributes, for: .normal)
            $0.setTitleTextAttributes(attributes, for: .selected)
        }
    }
    
    /// 탭 바 기본 설정
    private func configureBasicSettings() {
        object_setClass(self.tabBar, CustomTabBar.self)
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.isTranslucent = false
    }
    
    
    // TODO: - 각 NavigationController에 들어갈 ViewController 수정/교체
    /// 탭 바의 내비게이션 컨트롤러 배열 설정
    private func setNavigationControllers() {
        self.viewControllers = [
            createNavigationController(
                for: HomeTabViewController(),
                title: Tab.home.title,
                image: Tab.home.image,
                selectedImage: Tab.home.selectedImage
            ),
            createNavigationController(
                for: UIViewController(),
                title: Tab.bottleList.title,
                image: Tab.bottleList.image,
                selectedImage: Tab.bottleList.selectedImage
            ),
            createNavigationController(
                for: UIViewController(),
                title: Tab.settings.title,
                image: Tab.settings.image,
                selectedImage: Tab.settings.selectedImage
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
    
    enum Tab: Int {
        case home
        case bottleList
        case settings
        
        /// 탭 바 아이템 타이틀
        var title: String {
            switch self {
            case .home:
                return "홈"
            case .bottleList:
                return "저금통 목록"
            case .settings:
                return "환경설정"
            }
        }
        
        /// 탭 바 아이템 이미지
        var image: UIImage? {
            switch self {
            case .home:
                return AssetImage.homeNormal
            case .bottleList:
                return AssetImage.listNormal
            case .settings:
                return AssetImage.settingsNormal
            }
        }

        /// 탭 바 아이템 선택됐을 때 이미지
        var selectedImage: UIImage? {
            switch self {
            case .home:
                return AssetImage.homeSelected
            case .bottleList:
                return AssetImage.listSelected
            case .settings:
                return AssetImage.settingsSelected
            }
        }
    }
}
