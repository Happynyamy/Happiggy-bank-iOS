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
        configureNavigationBar()
        configureEmptyLabel()
        registerBottleCell()
        layoutCells()
        scrollToOpenBottleIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let bottle =  self.viewModel.openingBottle
        else {
            self.showAllSubviews()
            self.configureEmptyLabel()
            return
        }
        self.hideAllSubviewsIfIsOpeningBottle(bottle)
        self.scrollToOpenBottleIfNeeded()
        self.performSegue(withIdentifier: SegueIdentifier.showNoteList, sender: bottle)
    }
    
    
    // MARK: - @IBActions
    
    /// 해당 뷰 컨트롤러로 언와인드 되었을 때 호출
    @IBAction func unwindCallToBottleListDidArrive(segue: UIStoryboardSegue) {
        guard let bottle = self.viewModel.openingBottle,
              self.viewIfLoaded == nil
        else { return }
        
        self.performSegue(withIdentifier: SegueIdentifier.showNoteList, sender: bottle)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showNoteList {
            guard let noteListViewController = segue.destination as? NoteListViewController,
                let bottle = sender as? Bottle
            else { return }
            
            let viewModel = NoteListViewModel(
                bottle: bottle,
                fadeIn: self.viewModel.openingBottle != nil,
                fetchedResultContollerDelegate: noteListViewController
            )
            noteListViewController.viewModel = viewModel
            self.viewModel.openingBottle = nil
        }
    }
    
    
    // MARK: - View Configuration
    
    /// 내비게이션 바 속성 설정
    private func configureNavigationBar() {
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
    
    /// 현재 개봉중인 저금통이 있으면 해당 저금통의 위치로 스크롤
    private func scrollToOpenBottleIfNeeded() {

        guard let indexPath = self.viewModel.openingBottleIndexPath
        else { return }

        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        self.viewModel.openingBottleIndexPath = nil
    }
    
    /// 네비게이션 바, 탭바와 모든 하위 뷰를 다시 나타냄
    private func showAllSubviews() {
        self.title = viewModel.bottleList.isEmpty ?
        StringLiteral.emptyListNavigationBarTitle :
        StringLiteral.fullListNavigationBarTitle
        
        self.view.subviews.forEach {
            $0.isHidden = false
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// 네비게이션 바, 탭바와 모든 하위 뷰를 숨김
    private func hideAllSubviewsIfIsOpeningBottle(_ bottle: Bottle) {
        self.view.subviews.forEach {
            $0.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = .empty
    }
    
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
