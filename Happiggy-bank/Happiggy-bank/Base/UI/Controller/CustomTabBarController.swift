//
//  CustomTabBarController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/24.
//

import Combine
import UIKit

/// 커스텀 탭바 컨트롤러
final class CustomTabBarController: UITabBarController {

    // MARK: - Properties

    private let versionManager: any VersionChecking
    private let fontManager: FontManaging
    private var cancellable: AnyCancellable?


    // MARK: - Init

    init(versionManager: any VersionChecking, fontManager: FontManaging) {
        self.versionManager = versionManager
        self.fontManager = fontManager

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
    }


    // MARK: - Functions

    /// 탭 바 초기 설정
    private func configureTabBar() {
        self.configureBasicSettings()
        self.subscribeToFontPublisher()
        self.setNavigationControllers()
    }

    /// 탭 바 기본 설정
    private func configureBasicSettings() {
        object_setClass(self.tabBar, CustomTabBar.self)
        self.view.backgroundColor = .systemBackground
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.isTranslucent = false
        self.tabBar.standardAppearance = self.tabBar.standardAppearance.then {
            $0.shadowColor = .clear
            $0.backgroundEffect = .none
        }
        self.configureDivider()
    }

    /// 탭 바 상단에 경계선 생성
    private func configureDivider() {
        let dividerView = UIView().then { $0.backgroundColor = AssetColor.subGrayBG }
        self.tabBar.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(CGFloat.one)
        }
    }


    private func subscribeToFontPublisher() {
        self.cancellable = fontManager.fontPublisher
//            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateFont(to: $0) }
    }

    private func updateFont(to newFont: CustomFont) {
        guard let font = UIFont(name: newFont.regular, size: FontSize.caption2)
        else {
            return
        }

        self.tabBar.standardAppearance = self.tabBar.standardAppearance.then {
            $0.stackedLayoutAppearance.normal.titleTextAttributes = [.font: font]
            $0.stackedLayoutAppearance.selected.titleTextAttributes = [.font: font]
        }
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
                for: SettingsViewController(
                    versionManager: self.versionManager,
                    fontManager: self.fontManager
                ),
                of: Tab.settings
            )
        ]
    }

    /// 각 내비게이션 컨트롤러 기본 설정
    fileprivate func createNavigationController(
        for rootViewController: UIViewController,
        of tab: Tab
    ) -> UIViewController {

        let navigationController = CustomNavigationController(
            rootViewController: rootViewController,
            fontManager: self.fontManager
        )
        navigationController.tabBarItem.title = tab.title
        navigationController.tabBarItem.image = tab.image
        navigationController.tabBarItem.selectedImage = tab.selectedImage
        navigationController.navigationBar.isHidden = tab == .home

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
