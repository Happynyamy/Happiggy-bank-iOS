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
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.subscribeToFontPublisher()
    }


    // MARK: - Functions

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

        self.navigationBar.titleTextAttributes = [.font: font]
    }
}
