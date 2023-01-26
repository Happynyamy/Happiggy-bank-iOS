//
//  CustomTabBarController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/24.
//

import UIKit

/// 커스텀 탭바 컨트롤러
final class CustomTabBarController: UITabBarController {

    // MARK: - Properties

    private let versionManager: any VersionChecking


    // MARK: - Init

    init(versionManager: any VersionChecking) {
        self.versionManager = versionManager

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
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
        self.configureBasicSettings()
        self.changeTabBarFont(to: CustomFont.current)
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
                of: Tab.home
            ),
            createNavigationController(
                for: ListTabViewController(),
                of: Tab.list
            ),
            createNavigationController(
                for: SettingsViewController(versionManager: self.versionManager),
                of: Tab.settings
            )
        ]
    }
    
    /// 각 내비게이션 컨트롤러 기본 설정
    fileprivate func createNavigationController(
        for rootViewController: UIViewController,
        of tab: Tab
    ) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let title: String
        let image: UIImage?
        let selectedImage: UIImage?
        let navigationBarHidden: Bool = tab == .home ? true : false
        
        title = tab.title
        image = tab.image
        selectedImage = tab.selectedImage
        
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.isHidden = navigationBarHidden
        
        return navigationController
    }
}


extension CustomTabBarController {
    
    enum Tab: Int {
        case home
        case list
        case settings
        
        /// 탭 바 아이템 타이틀
        var title: String {
            switch self {
            case .home:
                return "홈"
            case .list:
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
            case .list:
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
            case .list:
                return AssetImage.listSelected
            case .settings:
                return AssetImage.settingsSelected
            }
        }
    }
}
