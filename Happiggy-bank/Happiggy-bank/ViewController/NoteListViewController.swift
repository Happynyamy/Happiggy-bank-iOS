//
//  NoteListViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import CoreData
import UIKit

/// 개봉한 저금통의 쪽지를 확인할 수 있는 쪽지 리스트(테이블뷰)를 관리하는 뷰 컨트롤러
final class NoteListViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    // MARK: - Properties
    
    /// fetched result controller 를 담고 있는 뷰모델
    var viewModel: NoteListViewModel!
    
    /// 최초로 나타날 때만 컬렉션뷰에 애니메이션을 나타내기 위한 프로퍼티
    private var isInitialLayout = true
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.name)
        self.configureNavigationBar()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard self.isInitialLayout,
              !self.collectionView.visibleCells.isEmpty
        else { return }
        
        self.isInitialLayout.toggle()
        self.displayVisibleCellsWithZoomAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.showNoteDetailView {
            guard let noteDetailViewController = segue.destination as? NoteDetailViewController,
                  let notes = self.viewModel.fetchedResultController.fetchedObjects,
                  let selectedIndex = sender as? Int
            else { return }
            
            let viewModel = NoteDetailViewModel(
                notes: notes,
                selectedIndex: selectedIndex,
                bottleTitle: self.viewModel.bottleTitle
            )
            noteDetailViewController.viewModel = viewModel
        }
    }
    
    
    // MARK: - Functions
    
    /// 네비게이션 바 초기 설정
    private func configureNavigationBar() {
        self.navigationItem.title = self.viewModel.bottleTitle
        self.navigationItem.backButtonTitle = .empty
    }
    
    /// 처음 화면이 나타날 때만 셀들을 순차적 줌 효과와 함께 나타냄
    private func displayVisibleCellsWithZoomAnimation() {
        
        self.collectionView.visibleCells.forEach {
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
extension NoteListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let note = self.viewModel.fetchedResultController.object(at: indexPath)
        
        /// 현재 셀의 첫 번쨰 단어 길이를 재기 위한 라벨
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: TagCell.Font.firstWordLabel)
            $0.text = note.firstWord
            $0.sizeToFit()
        }
        
        let labelSize = label.frame.size
        
        /// 라벨 크기에 여백 추가해서 리턴
        return CGSize(
            width: labelSize.width + Metric.firstWordLabelHorizontalPadding,
            height: labelSize.height + Metric.firstWordLabelVerticalPadding
        )
    }
}


// MARK: - UICollectionViewDelegate
extension NoteListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath)
        else { return }
        
        collectionView.deselectItem(at: indexPath, animated: false)
        cell.zoomAnimation(duration: ZoomAnimation.selectionDuration, completion: { _ in
            self.performSegue(
                withIdentifier: SegueIdentifier.showNoteDetailView,
                sender: indexPath.row
            )
        })
    }
}


// MARK: - UICollectionViewDataSource
extension NoteListViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.viewModel.fetchedResultController.fetchedObjects?.count ?? .zero
    }
    
    // swiftlint:disable force_cast
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCell.name,
            for: indexPath
        ) as! TagCell
        
        self.configureCell(cell, at: indexPath)
        
        return cell
    }
    // swiftlint:enable force_cast
    
    /// 쪽지 색깔, 첫 번째 단어를 사용해서 셀 모습 생성
    private func configureCell(_ cell: TagCell, at indexPath: IndexPath) {
        let note = self.viewModel.fetchedResultController.object(at: indexPath)
        
        cell.firstWordLabel.attributedText = self.viewModel.attributedFirstWordString(
            forNote: note
        )
        cell.contentView.backgroundColor = self.viewModel.tagColor(forNote: note)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension NoteListViewController: NSFetchedResultsControllerDelegate { }
