//
//  NewBottleDateViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2023/02/07.
//

import UIKit

import SnapKit


// MARK: - Ver2부터 뷰모델, 해당 뷰 컨트롤러, 뷰 모두 변경될 예정이라 코드 수정 별도로 안 했습니다

class NewBottleDateViewController: UIViewController {
    
    // MARK: - Properties
    
    /// newBottleDateView
    var newBottleDateView: NewBottleDateView = NewBottleDateView()
    
    /// 유리병 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    /// 데이터 가공해 전달하는 뷰모델
    var viewModel: NewBottleDatePickerViewModel = NewBottleDatePickerViewModel()

    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        self.view = self.newBottleDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializePickerView()
        configureNavigationItems()
        configureDescriptionLabel()
        setPickerHighlightWhite()
    }

    
    // MARK: @objc functions
    
    /// 새 유리병 이름 입력하는 뷰 컨트롤러로 돌아가는 back button 액션
    /// 이전으로 돌아가도 현재 입력된 피커의 값이 저장되어야 하므로 델리게이트 함수 사용
    @objc func backButtonDidTap(_ sender: UIBarButtonItem) {
        // 이전 화면으로 돌아가기
        self.delegate?.send(self.viewModel.bottleData ?? NewBottle())
        
        self.navigationController?.popViewControllerWithFade()
    }
    
    /// 새 유리병 개봉 멘트 입력 뷰 컨트롤러로 이동하는 next button 액션
    @objc func nextButtonDidTap(_ sender: Any) {
        self.navigationController?.pushViewControllerWithFade(
            to: prepareNextViewController()
        )
    }
    
    
    // MARK: configurations
    
    /// 내비게이션 바의 왼쪽, 오른쪽 버튼 아이템 설정
    private func configureNavigationItems() {
        let back = UIBarButtonItem(
            image: AssetImage.back,
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        let next = UIBarButtonItem(
            image: AssetImage.next,
            style: .plain,
            target: self,
            action: #selector(nextButtonDidTap)
        )
        
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.rightBarButtonItem = next
        self.navigationItem.title = Text.navigationBarTitle
    }
    
    /// 개봉 예정일 라벨 세팅
    private func configureDescriptionLabel() {
        guard let periodIndex = self.viewModel.bottleData?.periodIndex
        else { return }
        let endDate = viewModel.endDate(
            from: Date(),
            after: periodIndex
        )
        self.newBottleDateView.descriptionLabel.text = viewModel.openDateString(of: endDate)
    }
    
    /// 피커 뷰 초기 상태 세팅하는 함수
    /// 처음엔 가운데로, 이후엔 선택된 행의 인덱스에 따라 설정됨
    private func initializePickerView() {
        let row = self.viewModel.bottleData?.periodIndex ??
        NewBottleDateViewController.pickerValues.count / 2
        
        self.newBottleDateView.pickerView.delegate = self
        self.newBottleDateView.pickerView.dataSource = self
        self.newBottleDateView.pickerView.selectRow(
            row,
            inComponent: 0,
            animated: false
        )
        self.updateSelectedRow(
            self.newBottleDateView.pickerView,
            row: row,
            component: 0
        )
        self.viewModel.bottleData?.periodIndex = row
        self.viewModel.bottleData?.endDate = viewModel.endDate(from: Date(), after: row)
    }
    
    /// 피커 선택 하이라이트 뷰 흰색으로 설정하는 함수
    private func setPickerHighlightWhite() {
        guard let defaultHightlightView = self.newBottleDateView.pickerView.subviews.last
        else { return }
        
        defaultHightlightView.backgroundColor = .clear
        
        let highlightView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = defaultHightlightView.layer.cornerRadius
            $0.frame = defaultHightlightView.frame
        }
        
        self.view.insertSubview(highlightView, belowSubview: self.newBottleDateView.pickerView)
        highlightView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(defaultHightlightView.snp.width)
            make.height.equalTo(defaultHightlightView.snp.height)
        }
    }
    
    /// 다음 뷰 컨트롤러 설정
    private func prepareNextViewController() -> UIViewController {
        let newBottleMessageViewController = NewBottleMessageViewController()
        
        newBottleMessageViewController.delegate = self
        newBottleMessageViewController.bottleData = self.viewModel.bottleData
        
        return newBottleMessageViewController
    }
}

extension NewBottleDateViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func send(_ data: NewBottle) {
        self.viewModel.bottleData = data
    }
}

extension NewBottleDateViewController: UIPickerViewDataSource {
    
    /// 피커 뷰의 휠 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// 피커 뷰의 선택지 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NewBottleDateViewController.pickerValues.count
    }
}

extension NewBottleDateViewController: UIPickerViewDelegate {
    
    /// 피커 각 행 구성
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        
        return BaseLabel().then {
            $0.text = NewBottleDateViewController.pickerValues[row]
            $0.font = .systemFont(ofSize: FontSize.body1)
            $0.textAlignment = .center
        }
    }
    
    /// 피커 뷰의 선택된 항목
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        self.viewModel.bottleData?.periodIndex = row
        self.viewModel.bottleData?.endDate = viewModel.endDate(from: Date(), after: row)
        self.updateSelectedRow(
            pickerView,
            row: row,
            component: component
        )
    }

    /// 피커 선택된 상태로 업데이트
    private func updateSelectedRow(
        _ pickerView: UIPickerView,
        row: Int,
        component: Int
    ) {
        guard let rowView = pickerView.view(forRow: row, forComponent: component)
                as? BaseLabel
        else { return }

        rowView.textColor = AssetColor.mainGreen
        configureDescriptionLabel()
    }
}

extension NewBottleDateViewController {
    
    /// NewBottleDateViewController의 Picker 선택지
    static let pickerValues = ["일주일", "한 달", "3달", "6달", "일 년"]
    
    /// DateComponents를 만들기 위한 Picker의 상수값
    static let pickerConstants: [String: Int] = [
        pickerValues[0] : 7,
        pickerValues[1] : 1,
        pickerValues[2] : 3,
        pickerValues[3] : 6,
        pickerValues[4] : 1
    ]
    
    enum Text {
        
        /// 내비게이션 바 타이틀
        static let navigationBarTitle: String = "개인 저금통 만들기"
    }
}
