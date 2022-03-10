//
//  NotesViewController.swift
//  Pods
//
//  Created by sun on 2022/02/26.
//

import UIKit

import Then

/// 쪽지들의 컬렉션 뷰를 관리하는 뷰 컨트롤러
class NotesViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    /// 셀 재활용을 위한 아이디
    private let reuseIdentifier = "NotesViewCell"
    
    /// 데이터를 담고 있는 뷰모델
    var viewModel: NotesViewModel!
    
    /// 쪽지가 없는 경우 나타낼 라벨
    private var emptyNotesLabel: UILabel?
    
    
    // MARK: - Init
    
    private override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    convenience init(title: String) {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(
                top: Metric.padding,
                left: Metric.padding,
                bottom: Metric.padding,
                right: Metric.padding
            )
            $0.minimumLineSpacing = Metric.spacing
            $0.minimumInteritemSpacing = Metric.spacing
        }
        self.init(collectionViewLayout: flowLayout)
        
        self.configureNavigationItem(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(
            NotesViewCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
//        self.viewModel.notes = []
        if self.viewModel.notes.isEmpty {
            self.configureEmptyNotesLabel()
            self.configureEmptyNotesLabelConstraints()
        }
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 아이템 설정
    private func configureNavigationItem(title: String) {
        self.navigationItem.title = title
        self.navigationItem.backButtonTitle = StringLiteral.backButtonTitle
    }
    
    /// empty notes label 설정
    private func configureEmptyNotesLabel() {
        self.emptyNotesLabel = UILabel().then {
            $0.text = StringLiteral.emptyNotesLabelText
            self.view.addSubview($0)
        }
    }
    
    /// empty notes label 오토 레이아웃 설정
    private func configureEmptyNotesLabelConstraints() {
        guard let emptyNotesLabel = emptyNotesLabel
        else { return }

        emptyNotesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyNotesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNotesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


// MARK: - UICollectionViewDataSource

extension NotesViewController {

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.viewModel.notes.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? NotesViewCell ?? NotesViewCell()
    
        let note = self.viewModel.notes[indexPath.row]
        
        // TODO: color 가 아니라 이미지 변경, 날짜도 뷰모델에서 받아오기
        cell.contentView.backgroundColor = viewModel.image(for: note)
        cell.dateLabel.text = Date().customFormatted(type: .letters)
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension NotesViewController {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemOrange
        
        self.show(viewController, sender: self)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension NotesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        Metric.cellSize
    }
}
