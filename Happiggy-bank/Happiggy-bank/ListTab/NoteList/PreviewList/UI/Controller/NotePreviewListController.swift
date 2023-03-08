//
//  NotePreviewListController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import CoreData
import UIKit

/// 개봉한 저금통의 쪽지의 프리뷰를 볼 수 있는 리스트를 관리하는 뷰 컨트롤러
final class NotePreviewListController: UIViewController {

    // MARK: - Properties

    private let listView: LabeledCollectionView = {
        let layout = NotePreviewListFlowLayout().then {
            $0.minimumLineSpacing = Metric.spacing10
            $0.minimumInteritemSpacing = Metric.spacing10
        }

        return .init(frame: .zero, collectionViewLayout: layout)
    }()
    
    /// 쪽지 데이터를 갖고 있는 뷰모델
    private let viewModel: NotePreviewListViewModel
    
    /// 최초로 나타날 때만 컬렉션뷰에 애니메이션을 나타내기 위한 프로퍼티
    private var isInitialLayout = true


    // MARK: - Init(s)

    init(viewModel: NotePreviewListViewModel, isInitialLayout: Bool = true) {
        self.viewModel = viewModel
        self.isInitialLayout = isInitialLayout
        
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycle

    override func loadView() {
        self.view = self.listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.configureNavigationBar()
        self.viewModel.fetchedResultsControllerDelegate = self
        self.configureCollectionView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard self.isInitialLayout,
              !self.listView.visibleCells.isEmpty
        else { return }

        self.isInitialLayout.toggle()
        self.displayVisibleCellsWithZoomAnimation()
    }

    
    // MARK: - Functions
    
    /// 네비게이션 바 초기 설정
    private func configureNavigationBar() {
        self.navigationItem.title = self.viewModel.bottleTitle
        self.navigationItem.backButtonTitle = .empty
    }

    private func configureCollectionView() {
        self.listView.register(NotePreviewCell.self, forCellWithReuseIdentifier: NotePreviewCell.name)
        self.listView.contentInset = .init(
            top: Metric.spacing16,
            left: Metric.spacing24,
            bottom: Metric.spacing16,
            right: Metric.spacing24
        )
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.noticeLabel.text = self.viewModel.notes.isEmpty ? StringLiteral.emptyLabel : nil
    }

    /// 처음 화면이 나타날 때만 셀들을 순차적 줌 효과와 함께 나타냄
    private func displayVisibleCellsWithZoomAnimation() {
        
        self.listView.visibleCells.forEach {
            $0.zoomAnimation(
                duration: ZoomAnimation.initialDisplayDuration,
                delay: self.delay(forCell: $0),
                fadeIn: self.viewModel.fadeIn,
                options: .allowUserInteraction
            )
        }
        self.viewModel.fadeIn = false
    }
    
    /// 순차적인 효과를 위해 각 셀에 적용할 딜레이
    private func delay(forCell cell: UICollectionViewCell) -> Double {
        let column = Double(cell.frame.minX / cell.frame.width)
        let row = Double(cell.frame.minY / cell.frame.height)
        
        let distance = sqrt(pow(column, Metric.two) + pow(row, Metric.two))
        
        return sqrt(distance) * ZoomAnimation.initialDisplayDelayBase
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension NotePreviewListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        guard let firstWord = self.viewModel.note(at: indexPath)?.firstWord
        else {
            return .zero
        }
        
        /// 현재 셀의 첫 번째 단어 길이를 재기 위한 라벨
        let dummyLabel = BaseLabel().then {
            $0.text = firstWord
            $0.changeFontSize(to: FontSize.body1)
            $0.bold()
            $0.sizeToFit()
        }

        let labelSize = dummyLabel.frame.size
        
        /// 라벨 크기에 여백 추가해서 리턴
        return CGSize(
            width: labelSize.width + Metric.spacing24,
            height: labelSize.height + Metric.spacing16
        )
    }
}


// MARK: - UICollectionViewDelegate
extension NotePreviewListController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath)
        else { return }
        
        collectionView.deselectItem(at: indexPath, animated: false)
        cell.zoomAnimation(duration: ZoomAnimation.selectionDuration) { [weak self] _ in
            self?.showDetailList(startingWithRow: indexPath.row)
        }
    }

    private func showDetailList(startingWithRow row: Int) {
        guard !self.viewModel.notes.isEmpty
        else { return }

        let viewModel = NoteDetailListViewModel(
            notes: self.viewModel.notes,
            selectedIndex: row,
            bottleTitle: self.viewModel.bottleTitle
        )

        self.show(NoteDetailListViewController(viewModel: viewModel), sender: self)
    }
}


// MARK: - UICollectionViewDataSource
extension NotePreviewListController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.viewModel.notes.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = self.listView.dequeueReusableCell(
            withReuseIdentifier: NotePreviewCell.name,
            for: indexPath
        ) as? NotePreviewCell ?? NotePreviewCell()
        
        self.configureCell(cell, at: indexPath)
        
        return cell
    }
    
    /// 쪽지 색깔, 첫 번째 단어를 사용해서 셀 모습 생성
    private func configureCell(_ cell: NotePreviewCell, at indexPath: IndexPath) {
        guard let note = self.viewModel.note(at: indexPath)
        else {
            return
        }

        cell.firstWordLabel.attributedText = self.viewModel.attributedFirstWordString(
            forNote: note
        )
        cell.contentView.backgroundColor = self.viewModel.backgroundColor(for: note.color)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension NotePreviewListController: NSFetchedResultsControllerDelegate { }


// MARK: - Constants
fileprivate extension NotePreviewListController {

    enum Metric {
        static let spacing10: CGFloat = 10
        static let spacing16: CGFloat = 16
        static let spacing24: CGFloat = 24
        static let two = 2.0
    }

    enum StringLiteral {
        static let emptyLabel = "쪽지를 가져오지 못했어요"
    }

    /// 줌 애니메이션
    enum ZoomAnimation {

        /// 화면이 최초로 나타날 때 줌 효과 시간: 0.5
        static let initialDisplayDuration: CGFloat = 0.5

        /// 순차적 효과를 위한 딜레이: 0.1
        static let initialDisplayDelayBase: TimeInterval = 0.1

        /// 셀 선택 시 줌 효과 시간: 0.3
        static let selectionDuration: Double = 0.3
    }
}
