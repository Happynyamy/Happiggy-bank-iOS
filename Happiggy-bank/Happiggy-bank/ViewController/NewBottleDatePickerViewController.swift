//
//  NewBottleDatePickerViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/10.
//

import UIKit

import Then

/// 새 유리병 개봉 시점 선택하는 피커 뷰 컨트롤러
final class NewBottleDatePickerViewController: UIViewController {
    
    // MARK: Properties
    
    /// 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 상단 라벨
    @IBOutlet weak var topLabel: UILabel!
    
    /// 개봉 시점 선택하는 피커 뷰
    @IBOutlet weak var pickerView: UIPickerView!
    
    /// 개봉 날짜 표시하는 라벨
    @IBOutlet weak var openDateLabel: UILabel!
    
    /// 유리병 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    /// 데이터 가공해 전달하는 뷰모델
    var viewModel: NewBottleDatePickerViewModel = NewBottleDatePickerViewModel()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePickerView()
        initializeLabel()
        makeNavigationBarClear()
        setPickerHighlightWhite()
    }
    
    /// 새 유리병 개봉 멘트 필드 뷰 컨트롤러로 이동하기 전 유리병 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewBottleMessageField {
            guard let newBottleMessageFieldViewController: NewBottleMessageFieldViewController =
                    segue.destination as? NewBottleMessageFieldViewController
            else { return }
            
            newBottleMessageFieldViewController.delegate = self
            newBottleMessageFieldViewController.bottleData = self.viewModel.bottleData
        }
    }
    
    // MARK: IBAction
    
    /// 새 유리병 이름 입력하는 뷰 컨트롤러로 돌아가는 back button 액션
    /// 이전으로 돌아가도 현재 입력된 피커의 값이 저장되어야 하므로 델리게이트 함수 사용
    @IBAction func backButtonDidTap(_ sender: UIBarButtonItem) {
        // 이전 화면으로 돌아가기
        self.delegate?.sendNewBottleData(self.viewModel.bottleData ?? NewBottle())
        
        self.fadeOut()
        self.dismiss(animated: false)
    }
    
    /// 새 유리병 개봉 멘트 입력 뷰 컨트롤러로 이동하는 next button 액션
    @IBAction func nextButtonDidTap(_ sender: Any) {
        self.performSegue(
            withIdentifier: SegueIdentifier.presentNewBottleMessageField,
            sender: sender
        )
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 투명하게 만드는 함수
    private func makeNavigationBarClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 라벨 초기 세팅하는 함수
    private func initializeLabel() {
        setTopLabel()
        setOpenDateLabel()
    }
    
    /// 상단 라벨 세팅
    private func setTopLabel() {
        self.topLabel.text = StringLiteral.topLabel
        self.topLabel.font = .systemFont(ofSize: FontSize.topLabelText)
        self.topLabel.textColor = .customLabel
    }
    
    /// 개봉 예정일 라벨 세팅
    private func setOpenDateLabel() {
        guard let periodIndex = self.viewModel.bottleData?.periodIndex
        else { return }
        let endDate = viewModel.endDate(
            from: Date(),
            after: periodIndex
        )
        self.openDateLabel.text = viewModel.openDateString(of: endDate)
        self.openDateLabel.font = .systemFont(ofSize: FontSize.openDateLabelText)
        self.openDateLabel.textColor = .customTint
    }
    
    /// 피커 뷰 초기 상태 세팅하는 함수
    /// 처음엔 가운데로, 이후엔 선택된 행의 인덱스에 따라 설정됨
    private func initializePickerView() {
        let row = self.viewModel.bottleData?.periodIndex ??
        NewBottleDatePickerViewController.pickerValues.count / 2
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.selectRow(
            row,
            inComponent: 0,
            animated: false
        )
        self.updateSelectedRow(
            self.pickerView,
            row: row,
            component: 0
        )
        self.viewModel.bottleData?.periodIndex = row
        self.viewModel.bottleData?.endDate = viewModel.endDate(from: Date(), after: row)
    }
    
    /// 피커 선택 하이라이트 뷰 흰색으로 설정하는 함수
    private func setPickerHighlightWhite() {
        let defaultHightlightView = self.pickerView.subviews[1]
        defaultHightlightView.backgroundColor = .clear
        
        let highlightView = UIView().then {
            $0.backgroundColor = .pickerSelectionColor
            $0.layer.cornerRadius = defaultHightlightView.layer.cornerRadius
            $0.frame = defaultHightlightView.frame
        }
        
        self.view.insertSubview(highlightView, belowSubview: self.pickerView)
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            highlightView.centerXAnchor.constraint(
                equalTo: defaultHightlightView.centerXAnchor
            ),
            highlightView.centerYAnchor.constraint(
                equalTo: defaultHightlightView.centerYAnchor
            ),
            highlightView.widthAnchor.constraint(
                equalTo: defaultHightlightView.widthAnchor
            ),
            highlightView.heightAnchor.constraint(
                equalTo: defaultHightlightView.heightAnchor
            )
        ])
    }
}

extension NewBottleDatePickerViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func sendNewBottleData(_ data: NewBottle) {
        self.viewModel.bottleData = data
    }
}

extension NewBottleDatePickerViewController: UIPickerViewDataSource {
    
    /// 피커 뷰의 휠 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// 피커 뷰의 선택지 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NewBottleDatePickerViewController.pickerValues.count
    }
}

extension NewBottleDatePickerViewController: UIPickerViewDelegate {
    
    /// 피커 각 행 구성
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        
        return UILabel().then {
            $0.text = NewBottleDatePickerViewController.pickerValues[row]
            $0.font = .systemFont(ofSize: FontSize.rowText)
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
                as? UILabel
        else { return }

        rowView.textColor = .customTint
        setOpenDateLabel()
    }
}
