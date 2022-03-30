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
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionViewLayout()
        self.collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.name)
        self.configureNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.showNoteDetailView {
            guard let noteDetailViewController = segue.destination as? NoteDetailViewController,
                  let notes = self.viewModel.fetchedResultController.fetchedObjects,
                  let selectedIndex = sender as? Int
            else { return }
            
            let viewModel = NoteDetailViewModel(notes: notes, selectedIndex: selectedIndex)
            noteDetailViewController.viewModel = viewModel
        }
    }
    
    
    // MARK: - Functions
    
    /// 컬렉션 뷰의 레이아웃 설정
    private func configureCollectionViewLayout() {
        let layout = TagViewFlowLayout()
        self.collectionView.collectionViewLayout = layout
    }
    
    /// 네비게이션 바 초기 설정
    private func configureNavigationBar() {
        self.navigationItem.title = self.viewModel.bottleTitle
        self.navigationItem.backButtonTitle = .empty
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
        
        collectionView.deselectItem(at: indexPath, animated: false)
        self.performSegue(
            withIdentifier: SegueIdentifier.showNoteDetailView,
            sender: indexPath.row
        )
    }
}


// MARK: - UICollectionViewDataSource
extension NoteListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    /// 쪽지 색깔, 첫 번쨰 단어를 사용해서 셀 모습 생성
    func configureCell(_ cell: TagCell, at indexPath: IndexPath) {
        let note = self.viewModel.fetchedResultController.object(at: indexPath)
        
        // TODO: 첫 단어 추출 메서드 추가
        cell.firstWordLabel.text = note.firstWord
        cell.noteImageView.backgroundColor = .note(color: note.color)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension NoteListViewController: NSFetchedResultsControllerDelegate { }
