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
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureEmptyLabel()
        registerBottleCell()
        layoutCells()
    }
    
    
    // MARK: - View Configuration
    
    /// 내비게이션 바 속성 설정
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.clear()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = StringLiteral.navigationBarTitle
        self.navigationItem.backButtonTitle = .empty
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
            withReuseIdentifier: BottleCell.reuseIdentifier,
            for: indexPath
        ) as? BottleCell
        else { return UICollectionViewCell() }

        resetReusableCellAttribute(cell)
        
        cell.bottleTitleLabel.text = bottle.title
        cell.bottleDateLabel.text = bottle.dateLabel
        cell.bottleDateLabel.textColor = AssetColor.mainYellow
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

extension ListTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(
            withIdentifier: SegueIdentifier.showNoteList,
            sender: viewModel.bottleList[indexPath.row]
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
