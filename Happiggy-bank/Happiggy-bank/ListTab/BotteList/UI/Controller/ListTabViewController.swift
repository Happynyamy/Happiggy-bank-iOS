//
//  ListTabViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/01/12.
//

import UIKit

import SnapKit
import Then

final class ListTabViewController: UIViewController {

    /// 컬렉션 뷰
    var collectionView: UICollectionView!
    
    /// 리스트 비었을 때 표시되는 라벨
    lazy var emptyListLabel: BaseLabel = BaseLabel().then {
        $0.text = StringLiteral.emptyListLabelTitle
        $0.changeFontSize(to: FontSize.body3)
    }
    
    /// 뷰모델
    private(set) var viewModel: BottleListViewModel = BottleListViewModel()
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.collectionView = UICollectionView(
            frame: UIScreen.main.bounds,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureCollectionView()
        configureEmptyLabel()
        layoutCells()
    }
    
    
    // MARK: - View Configuration
    
    /// 내비게이션 바 속성 설정
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = StringLiteral.navigationBarTitle
        self.navigationItem.backButtonTitle = .empty
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            BottleCollectionCell.self,
            forCellWithReuseIdentifier: BottleCollectionCell.name
        )
        layoutCells()
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
    
    /// 리스트가 비어있을 때 표시되는 라벨 레이아웃 설정
    private func configureLabelConstraints() {
        self.emptyListLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Metric.tabBarHeight)
        }
    }
    
    
    // MARK: - Functions
    
    /// 셀에 대한 레이아웃 설정하는 함수
    private func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(
            top: Metric.cellVerticalSpacing,
            left: Metric.cellHorizontalSpacing,
            bottom: .zero,
            right: Metric.cellHorizontalSpacing
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

extension ListTabViewController: UICollectionViewDataSource {
    
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
            withReuseIdentifier: BottleCollectionCell.name,
            for: indexPath
        ) as? BottleCollectionCell
        else { return UICollectionViewCell() }
        
        cell.bottleTitleLabel.text = bottle.title
        cell.bottleDateLabel.text = bottle.dateLabel
        cell.bottleDateLabel.textColor = AssetColor.mainYellow
        // TODO: - bottle.image로 변경
        cell.bottleImage.image = AssetImage.yellowNote
        
        return cell
        
    }
}

extension ListTabViewController: UICollectionViewDelegate {
    
    // TODO: - NoteListViewController와 연결
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(
            UIViewController().then { $0.view.backgroundColor = .cyan },
            animated: false
        )
    }
}

extension ListTabViewController {
    
    /// ListTabViewController에서 설정하는 layout 상수값
    enum Metric {
        
        /// 셀 각 라인 별 최소 간격
        static let minimumLineSpacing: CGFloat = 40
        
        /// bottle  image 가로:세로 비율
        private static let imageSizeRatio: CGFloat = 306 / 165
        
        /// bottle cell 가로:세로 비율
        private static let cellSizeRatio: CGFloat = 356 / 165
        
        /// 화면 가로 길이
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        /// bottle cell 사이 수평 간격
        static let cellHorizontalSpacing: CGFloat = 24
        
        /// bottle cell 사이 수직 간격
        static let cellVerticalSpacing: CGFloat = 20
        
        /// bottle cell 너비
        static let cellWidth: CGFloat = ((screenWidth - 3 * 24) / 2)
        
        /// bottle cell 높이
        static let cellHeight = imageHeight + 50
        
        /// bottle image 높이 : 스크린 가로 길이에서 좌우 패딩값을 뺀 다음 지정한 비율을 곱해서 계산
        static let imageHeight = cellWidth * imageSizeRatio
        
        /// 탭 바의 높이
        static let tabBarHeight = CustomTabBar.Metric.height - 20
    }
    
    /// BottleListViewController에서 설정하는 문자열
    enum StringLiteral {
        
        /// 리스트가 빈 경우 표시되는 내비게이션 타이틀
        static let navigationBarTitle: String = "지난 저금통 리스트"
        
        /// 리스트가 빈 경우 테이블뷰에 표시되는 라벨
        static let emptyListLabelTitle: String = "이전에 사용한 저금통이 없습니다."
    }
}
