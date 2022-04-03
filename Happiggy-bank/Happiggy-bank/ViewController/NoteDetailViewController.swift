//
//  NoteDetailViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/30.
//

import UIKit

/// 쪽지 디테일 뷰 컨트롤러로 캐러셀 뷰 구현을 위해 컬렉션 뷰 사용
final class NoteDetailViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    /// 캐러셀 뷰를 나타낼 컬렉션 뷰
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 컬렉션 뷰 높이 조정을 위한 프로퍼티
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    /// 상단에 있는 캐릭터 이미지 뷰
    @IBOutlet weak var topCharacterView: UIImageView!
    
    /// 하단에 있는 캐릭터 이미지 뷰들의 배열
    @IBOutlet var bottomCharacterViews: [UIImageView]!
    
    /// 몇 번째 쪽지를 보고 있는 지 나타내는 페이지 인덱스 라벨
    @IBOutlet weak var indexLabel: UILabel!
    
    
    // MARK: - Properties
    
    var viewModel: NoteDetailViewModel!
    
    /// 현재 쪽지 페이지의 크기
    private var pageSize: CGSize {
        guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout
        else { return .zero }
        
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        
        return pageSize
    }
    
    /// 현재 페이지의 인덱스
    private var currentPageIndex: Int = .zero {
        didSet {
            self.updateIndexLabel()
            self.changeTopCharacterAndZoom()
            self.zoomBottomCharactersGradually(inReverseOrder: oldValue > self.currentPageIndex)
        }
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCollectionViewLayout()
        self.registerCell()
        self.currentPageIndex = self.viewModel.selectedIndex
        self.navigationItem.title = self.viewModel.bottleTitle
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollToInitialPage()
        self.collectionViewHeightConstraint.constant = Metric.itemSize.height + .one
    }
    
    
    // MARK: - Initializing Functions
    
    /// 컬렉션 뷰 레이아웃 초기 설정
    private func configureCollectionViewLayout() {
        guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout
        else { return }
        
        layout.spacingMode = .overlap(visibleOffset: Metric.sideItemVisibleWidth)
        layout.itemSize = Metric.itemSize
    }
    
    /// 유저가 선택해서 넘어온 쪽지 페이지로 이동
    private func scrollToInitialPage() {
        guard self.currentPageIndex != .zero,
              self.collectionView.contentSize != .zero
        else { return }
        
        let indexPath = IndexPath(item: self.currentPageIndex, section: .zero)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    /// 셀 등록
    private func registerCell() {
        let nib = UINib(nibName: NoteCell.name, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: NoteCell.name)
    }
    
    
    // MARK: - Animation Functions
    
    /// 상단 캐릭터는 현재 인덱스의 쪽지 색깔에 맞게 바꾸고 줌 효과
    private func changeTopCharacterAndZoom() {
        self.topCharacterView.image = self.viewModel.characterImage(
            forIndex: self.currentPageIndex
        )
        self.topCharacterView.zoomAnimation(duration: Animation.topCharacterDuration)
    }
    
    /// 하단 캐릭터들은 스와이프 방향에 따라 왼쪽 혹은 오른쪽에서 순차적으로 줌 효과
    private func zoomBottomCharactersGradually(inReverseOrder: Bool) {
        let characters = (inReverseOrder) ?
        self.bottomCharacterViews : self.bottomCharacterViews.reversed()
        
        var delay: Double = .zero

        characters?.forEach {
            $0.zoomAnimation(duration: Animation.bottomCharacterDuration, delay: delay)
            delay += Animation.bottomCharacterDelay
        }
    }
    
    /// 인덱스 변화에 맞게 라벨 업데이트
    private func updateIndexLabel() {
        UIView.transition(
            with: self.view,
            duration: Animation.IndexLabelDuration,
            options: .transitionCrossDissolve
        ) {
            self.indexLabel.attributedText = self.viewModel.attributedIndexString(
                self.currentPageIndex
            )
        }
    }
}


// MARK: - UICollectionViewDataSource
extension NoteDetailViewController: UICollectionViewDataSource {

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
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NoteCell.name,
            for: indexPath
        ) as? NoteCell
        else { return NoteCell() }
        
        let note = self.viewModel.notes[indexPath.row]
        
        self.configureNoteCell(cell, note: note)
        return cell
    }
    
    /// 쪽지 셀 구성
    private func configureNoteCell(_ cell: NoteCell, note: Note) {
        cell.noteImageView.image = self.viewModel.image(for: note)
        cell.yearLabel.attributedText = self.viewModel.attributedYearString(forNote: note)
        cell.monthAndDayLabel.attributedText = self.viewModel.attributedMonthAndDayString(
            forNote: note
        )
        cell.contentLabel.text = note.content
    }
}


// MARK: - UIScrollViewDelegate
extension NoteDetailViewController: UIScrollViewDelegate {
    
    // TODO: 디자인 확인 후 필요 없으면 삭제
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.pageSize.width
        let offset = scrollView.contentOffset.x

        self.currentPageIndex = Int(floor((offset - pageWidth / 2) / pageWidth) + 1)
    }
}


// MARK: - UICollectionViewDelegate
extension NoteDetailViewController: UICollectionViewDelegate { }


// MARK: - UICollectionViewDelegateFlowLayout
extension NoteDetailViewController: UICollectionViewDelegateFlowLayout { }
