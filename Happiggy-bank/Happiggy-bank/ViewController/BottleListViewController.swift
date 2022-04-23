//
//  BottleListViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/28.
//

import UIKit
import CoreData

import Then

/// 유리병 리스트 뷰 컨트롤러
final class BottleListViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 컬렉션뷰
    @IBOutlet var collectionView: UICollectionView!
    
    /// 리스트 비었을 때 표시되는 라벨
    lazy var emptyListLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.emptyListLabelTitle
        $0.font = .systemFont(ofSize: FontSize.emptyListLabelTitle)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Bottle List View Model
    private(set) var viewModel: BottleListViewModel = BottleListViewModel()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.observe(
            selector: #selector(refetch),
            name: .NSManagedObjectContextDidSave
        )
        
        configureNavigationBar()
        configureEmptyLabel()
        registerBottleCell()
        layoutCells()
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showNoteList {
            guard let noteListViewController = segue.destination as? NoteListViewController,
                let bottle = sender as? Bottle
            else { return }
            
            let viewModel = NoteListViewModel(
                bottle: bottle,
                fetchedResultContollerDelegate: noteListViewController
            )
            noteListViewController.viewModel = viewModel
        }
    }
    
    @objc private func refetch() {
        // 저금통 없을 때
        self.viewModel.executeFetchRequest()
        hideEmptyListLabelIfNeeded()
    }
    
    
    // MARK: - View Configuration
    
    /// 내비게이션 바 속성 설정
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.clear()
        self.navigationController?.navigationBar.tintColor = UIColor(hex: Color.navigationBar)
        self.title = viewModel.bottleList.isEmpty ?
        StringLiteral.emptyListNavigationBarTitle :
        StringLiteral.fullListNavigationBarTitle
        self.navigationItem.backButtonTitle = StringLiteral.emptyString
    }
    
    /// 리스트 비었을 때 표시되는 라벨 설정
    private func configureEmptyLabel() {
        self.view.addSubview(self.emptyListLabel)
        configureLabelConstraints()
        hideEmptyListLabelIfNeeded()
    }
    
    /// 유리병 리스트가 차있는 경우, 테이블뷰에 표시되는 라벨 감추기
    private func hideEmptyListLabelIfNeeded() {
        if !viewModel.bottleList.isEmpty {
            self.emptyListLabel.isHidden = true
        }
    }
    
    /// 라벨 constraints 설정
    private func configureLabelConstraints() {
        NSLayoutConstraint.activate([
            self.emptyListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyListLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    
    // MARK: - Functions
    
    /// 셀에 대한 레이아웃 설정하는 함수
    private func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(
            top: BottleCell.Metric.cellVerticalSpacing,
            left: BottleCell.Metric.cellHorizontalSpacing,
            bottom: .zero,
            right: BottleCell.Metric.cellHorizontalSpacing
        )
        
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = Metric.minimumLineSpacing
        layout.itemSize = CGSize(
            width: Metric.cellWidth,
            height: Metric.cellHeight
        )
        
        collectionView.collectionViewLayout = layout
    }
}

extension BottleListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.viewModel.bottleList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let bottle = viewModel.bottleList[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BottleCell.reuseIdentifier,
            for: indexPath
        ) as? BottleCell
        else { return UICollectionViewCell() }

        resetReusableCellAttribute(cell)
        cell.bottleTitleLabel.text = bottle.title
        cell.bottleDateLabel.text = bottle.dateLabel
        cell.bottleDateLabel.textColor = .customLabel
        cell.bottleImage.image = bottle.image
        
        return cell
        
    }
    
    /// 인터페이스 빌더로 만든 저금통 셀 사용 등록
    private func registerBottleCell() {
        self.collectionView.register(
            UINib(nibName: BottleCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: BottleCell.reuseIdentifier
        )
    }

    /// 리유저블 셀의 속성 초기화하는 함수
    private func resetReusableCellAttribute(_ cell: BottleCell) {
        cell.bottleTitleLabel.text = .empty
        cell.bottleDateLabel.text = .empty
    }
}

extension BottleListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(
            withIdentifier: SegueIdentifier.showNoteList,
            sender: viewModel.bottleList[indexPath.row]
        )
    }
}
