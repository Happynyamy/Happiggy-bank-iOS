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
    @IBOutlet var navigationBar: UINavigationBar!
    
    /// 상단 라벨
    lazy var topLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.topLabel
        $0.font = .systemFont(ofSize: FontSize.topLabelText)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 개봉 시점 선택하는 피커 뷰
    lazy var pickerView: UIPickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 저장할 유리병 데이터
    var bottleData: NewBottle?
    
    /// 유리병 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarcy()
        configureConstraints()
        setPickerView()
        makeNavigationBarClear()
    }
    
    
    // MARK: IBAction
    
    /// 새 유리병 이름 입력하는 뷰 컨트롤러로 돌아가는 back button 액션
    /// 이전으로 돌아가도 현재 입력된 피커의 값이 저장되어야 하므로 델리게이트 함수 사용
    @IBAction func backButtonDidTap(_ sender: UIBarButtonItem) {
        // 이전 화면으로 돌아가기
        self.delegate?.sendNewBottleData(self.bottleData ?? NewBottle())
        
        self.fadeOut()
        self.dismiss(animated: false)
    }
    
    /// 새 유리병 데이터를 코어데이터에 저장하고 Bottle 뷰 컨트롤러로 되돌아가는 save button 액션
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        // TODO: Save Data
        
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindFromNewBottlePopupToBottleView,
            sender: sender
        )
        self.fadeOut()
    }
    
    
    // MARK: View Hierarcy
    
    /// 뷰 계층 설정하는 함수
    private func configureViewHierarcy() {
        self.view.addSubview(topLabel)
        self.view.addSubview(pickerView)
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 투명하게 만드는 함수
    private func makeNavigationBarClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 피커 뷰 초기 상태 세팅하는 함수
    /// 처음엔 가운데로, 이후엔 선택된 행의 인덱스에 따라 설정됨
    private func setPickerView() {
        let row = bottleData?.periodIndex ??
        NewBottleDatePickerViewController.pickerValues.count / 2
        
        self.pickerView.selectRow(
            row,
            inComponent: 0,
            animated: false
        )
    }
    
    
    // MARK: Constraints
    
    /// 하위 뷰 오토레이아웃 지정하는 함수 모두 호출하는 함수
    private func configureConstraints() {
        topLabelConstraints()
        pickerViewConstraints()
    }
    
    /// 상단 라벨 오토레이아웃
    private func topLabelConstraints() {
        NSLayoutConstraint.activate([
            self.topLabel.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: Metric.topLabelTopAnchor
            ),
            self.topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    /// 피커 뷰 오토레이아웃
    private func pickerViewConstraints() {
        NSLayoutConstraint.activate([
            self.pickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.pickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
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
    
    /// 피커 뷰의 선택지 텍스트
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return NewBottleDatePickerViewController.pickerValues[row]
    }
    
    /// 피커 뷰의 선택된 항목
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        self.bottleData?.periodIndex = row
    }
}
