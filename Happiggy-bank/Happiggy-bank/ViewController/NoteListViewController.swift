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
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        self.displayWithBouncyAnimation(cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath)
        else { return }
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        self.bounceOnSelect(cell: cell, atIndexPath: indexPath) { _ in
            self.performSegue(
                withIdentifier: SegueIdentifier.showNoteDetailView,
                sender: indexPath.row
            )
        }
    }
    
    /// 탭하는 경우 선택된 셀이 바운스(수축-확대-원 크기로 돌아감)하는 효과
    private func bounceOnSelect(
        cell: UICollectionViewCell,
        atIndexPath indexPath: IndexPath,
        completion: ((Bool) -> Void)? = nil
    ) {
       
        cell.transform = CGAffineTransform(
            scaleX: Metric.transformDownScale,
            y: Metric.transformDownScale
        )
        
        UIView.animateKeyframes(withDuration: Metric.cellZoomAnimationDuration, delay: .zero) {
            UIView.addKeyframe(
                withRelativeStartTime: .zero,
                relativeDuration: Metric.upScaleRelativeDuration
            ) {
                cell.transform = CGAffineTransform(
                    scaleX: Metric.transformUpScale,
                    y: Metric.transformUpScale
                )
            }
            UIView.addKeyframe(
                withRelativeStartTime: Metric.upScaleRelativeDuration,
                relativeDuration: Metric.downScaleRelativeDuration
            ) {
                cell.transform = .identity
            }
        } completion: { result in
            guard let completion = completion
            else { return }
            
            completion(result)
        }
    }
    
    /// 위치에 따라 순차적으로 셀들이 바운스하면서 디스플레이되는 효과
    private func displayWithBouncyAnimation(cell: UICollectionViewCell) {
        let delayBase = 0.1

        let column = Double(cell.frame.minX / cell.frame.width)
        let row = Double(cell.frame.minY / cell.frame.height)
        
        let distance = sqrt(pow(column, 2) + pow(row, 2))
        let delay = sqrt(distance) * delayBase
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animateKeyframes(withDuration: 0.5, delay: delay) {
            UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 2/3) {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                cell.transform = .identity
            }
        }
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
        
        cell.firstWordLabel.text = note.firstWord
        cell.noteImageView.backgroundColor = .note(color: note.color)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension NoteListViewController: NSFetchedResultsControllerDelegate { }
