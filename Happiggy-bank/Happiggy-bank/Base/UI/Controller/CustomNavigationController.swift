//
//  CustomNavigationController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/24.
//

import Combine
import UIKit

/// 커스텀 내비게이션 바
final class CustomNavigationController: UINavigationController {

    // MARK: - Properties

    private let fontManager: FontManaging
    private var cancellable: AnyCancellable?


    // MARK: Inits

    init(rootViewController: UIViewController, fontManager: FontManaging) {
        self.fontManager = fontManager

        super.init(rootViewController: rootViewController)
        self.view.backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
        self.subscribeToFontPublisher()
    }


    // MARK: - Functions

    private func configureNavigationBar() {
        self.navigationBar.standardAppearance = self.navigationBar.standardAppearance.then {
            $0.shadowColor = .clear
            $0.backgroundEffect = .none
            $0.backgroundColor = .systemBackground

            // FIXME: 정렬이 이상함...
            $0.setBackIndicatorImage(AssetImage.back, transitionMaskImage: AssetImage.back)
        }
    }

    private func subscribeToFontPublisher() {
        self.cancellable = fontManager.fontPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.updateFont(to: $0) }
    }

    private func updateFont(to newFont: CustomFont) {
        guard let font = UIFont(name: newFont.regular, size: FontSize.body2)
        else {
            return
        }

        self.navigationBar.standardAppearance = self.navigationBar.standardAppearance.then {
            $0.titleTextAttributes = [.font: font]
            $0.largeTitleTextAttributes = [.font: font]
        }
    }
}
