//
//  FontSelectionViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/22.
//

import Combine
import UIKit

/// 폰트 선택 뷰 컨트롤러
final class FontSelectionViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, CustomFont>
    private typealias CellRegistration = UICollectionView.CellRegistration<FontCell, CustomFont>


    // MARK: - Enum

    private enum Section {
        case main
    }

    
    // MARK: - Properties

    private let rootView = FontSelectionView()
    private let viewModel: FontManaging
    private var cancellable: AnyCancellable?
    private lazy var dataSource: DataSource = self.configureDatasource()


    // MARK: - Init

    init(fontManager: FontManaging) {
        self.viewModel = fontManager

        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life cycle

    override func loadView() {
        self.view = self.rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.listView.delegate = self
        self.configureNavigationBar()
        self.configureSnapshot()
        self.subscribeToFontPublisher()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.showTabBar()
    }
    
    
    // MARK: - Configuration Functions
    
    private func configureNavigationBar() {
        self.navigationItem.title = StringLiteral.navigationTitle
    }

    private func configureDatasource() -> DataSource {
        let registration = CellRegistration { [weak self] cell, _, font in
            guard let currentFont = self?.viewModel.font
            else {
                return
            }

            cell.update(withCustomFont: font, isCurrentFont: font == currentFont)
        }

        return DataSource(collectionView: self.rootView.listView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }

    private func configureSnapshot() {
        var snapshot = self.dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(CustomFont.allCases)
        dataSource.apply(snapshot)
    }

    private func subscribeToFontPublisher() {
        cancellable = self.viewModel.fontPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.fontNameLabel.text = $0.description
                self?.rootView.listView.reloadData()
        }
    }
}


// MARK: - UICollectionViewDelegate
extension FontSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let font = self.dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }

        HapticManager.instance.selection()
        self.viewModel.fontDidChange(to: font)
    }
}


// MARK: - Constants
fileprivate extension FontSelectionViewController {

    /// 상수
    enum Metric {

        /// 모서리 둥근 정도: 8
        static let tableViewCornerRadius: CGFloat = 8

        /// 예시 라벨 줄 간격: 8
        static let lineSpacing: CGFloat = 8

        /// 예시 라벨 자간: 0.5
        static let characterSpacing: CGFloat = 0.5

    }

    enum StringLiteral {
        static let navigationTitle = "폰트 바꾸기"
    }
}
