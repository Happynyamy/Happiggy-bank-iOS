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
    
    
    // MARK: - Properties
    
    var viewModel: NoteDetailViewModel!
    
    // TODO: 디자인 픽스 후 불필요하면 삭제
    /// 현재 쪽지 페이지의 크기
    private var pageSize: CGSize {
        guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout
        else { return .zero }
        
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        
        return pageSize
    }

    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCollectionViewLayout()
        self.registerCell()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollToInitialPage()
    }
    
    
    // MARK: - Functions
    
    /// 컬렉션 뷰 레이아웃 초기 설정
    private func configureCollectionViewLayout() {
        guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout
        else { return }
        
        // TODO: 디자인 픽스 후 중앙 셀 크기, 좌우 셀 크기, 투명도 수정
        layout.spacingMode = .overlap(visibleOffset: Metric.sideItemVisibleWidth)
    }
    
    /// 유저가 선택해서 넘어온 쪽지 페이지로 이동
    private func scrollToInitialPage() {
        guard self.viewModel.selectedIndex != .zero,
              self.collectionView.contentSize != .zero
        else { return }
        
        let indexPath = IndexPath(item: self.viewModel.selectedIndex, section: .zero)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    /// 셀 등록
    private func registerCell() {
        let nib = UINib(nibName: NoteCell.name, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: NoteCell.name)
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
        cell.dateLabel.attributedText = self.viewModel.attributedDateString(for: note)
        cell.contentLabel.text = note.content
    }
}


// MARK: - UIScrollViewDelegate
extension NoteDetailViewController: UIScrollViewDelegate {
    
    // TODO: 디자인 확인 후 필요 없으면 삭제
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.pageSize.width
        let offset = scrollView.contentOffset.x

        self.viewModel.selectedIndex = Int(floor((offset - pageWidth / 2) / pageWidth) + 1)
    }
}


// MARK: - UICollectionViewDelegate
extension NoteDetailViewController: UICollectionViewDelegate { }


// MARK: - UICollectionViewDelegateFlowLayout
extension NoteDetailViewController: UICollectionViewDelegateFlowLayout { }
