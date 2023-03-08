//
//  NoteDetailListViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2023/03/06.
//

import UIKit

/// 쪽지의 자세한 내용을 볼 수 있는 목록을 관리하는 컨트롤러
final class NoteDetailListViewController: UIViewController {
    private typealias CellRegistration = UICollectionView.CellRegistration<NoteDetailCell, NoteDetailCellViewModel>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UUID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UUID>


    // MARK: - Enums

    private enum Section: Int {
        case main
    }


    // MARK: - Properties

    private let listView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let viewModel: NoteDetailListViewModel
    private lazy var dataSource = self.configureDatasource()


    // MARK: - Init(s)

    init(viewModel: NoteDetailListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureViews()
        self.configureSnapshot()
        self.scrollToSelectedNote()
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        self.configureNavigationBar()
        self.configureCollectionView()
    }

    private func configureCollectionView() {
        self.view.addSubview(self.listView)
        self.listView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.view)
        }
        self.configureLayout()
    }

    private func configureLayout() {
        let height = navigationController?.view.window?.windowScene?.screen.bounds.height ?? Metric.itemHeight
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat.one),
            heightDimension: .estimated(height)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat.one),
            heightDimension: .estimated(height)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group).then {
            $0.interGroupSpacing = Metric.spacing16
        }

        self.listView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        /// 없으면 초기화 시 일부 셀의 레이블이 찌그러짐
        self.view.layoutIfNeeded()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = self.viewModel.bottleTitle
        self.navigationItem.backButtonTitle = .empty
    }

    private func configureDatasource() -> DataSource {
        let registration = CellRegistration { [weak self] cell, _, noteViewModel in
            let photoTapHandler: (UIImage) -> Void = { [weak self] image in
                self?.show(PhotoViewController(photo: image), sender: self)
            }
            noteViewModel.photoDidTap = noteViewModel.hasPhoto ? photoTapHandler : nil
            cell.viewModel = noteViewModel
        }

        return DataSource(collectionView: self.listView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: self.viewModel.noteViewModel(forRow: indexPath.row, id: itemIdentifier)
            )
        }
    }

    private func configureSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.viewModel.noteViewModels.map { $0.id })
        self.dataSource.apply(snapshot)
    }

    private func scrollToSelectedNote() {
        /// 원하는 위치에 제대로 스크롤하기 위해서 필요
        self.view.layoutIfNeeded()
        let indexPath = IndexPath(row: self.viewModel.selectedIndex, section: Section.main.rawValue)
        self.listView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
}


// MARK: - Constants
fileprivate extension NoteDetailListViewController {

    enum Metric {
        static let spacing16: CGFloat = 16
        static let itemHeight: CGFloat = 3000
    }
}
