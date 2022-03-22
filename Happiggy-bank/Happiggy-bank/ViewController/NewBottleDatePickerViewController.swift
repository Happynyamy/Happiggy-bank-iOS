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
    
    /// 저장할 유리병 데이터
    var bottleData: NewBottle?
    
    /// 유리병 데이터 전달하는 델리게이트
    var delegate: DataProvider?
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabel()
        initializePickerView()
        makeNavigationBarClear()
        setPickerHighlightWhite()
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
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindFromNewBottlePopupToBottleView,
            sender: sender
        )
        self.fadeOut()
        
        // TODO: Save Data
//        saveNewBottle()
    }
    
    
    // MARK: Functions
    
    /// 새 저금통 저장하는 메서드
    private func saveNewBottle() {
        guard let title = self.bottleData?.name,
              let periodIndex = self.bottleData?.periodIndex
        else { return }
        
        Bottle(
            title: title,
            startDate: Date(),
            endDate: endDate(from: Date(), after: periodIndex)
        )
        PersistenceStore.shared.save()
    }
    
    /// 선택된 period의 index에 따라 종료 날짜 생성
    private func endDate(from startDate: Date, after periodIndex: Int) -> Date {
        let period = NewBottleDatePickerViewController.pickerValues[periodIndex]
        let constant = NewBottleDatePickerViewController.pickerConstants[period]
        
        // week
        if periodIndex == 0 {
            guard let endDate = Calendar.current.date(
                byAdding: DateComponents(day: constant),
                to: startDate
            )
            else { return Date() }
            return endDate
        }
        
        // month
        if (1...3) ~= periodIndex {
            guard let endDate = Calendar.current.date(
                byAdding: DateComponents(month: constant),
                to: startDate
            )
            else { return Date() }
            return endDate
        }
        
        // year
        if periodIndex == 4 {
            guard let endDate = Calendar.current.date(
                byAdding: DateComponents(year: constant),
                to: startDate
            )
            else { return Date() }
            return endDate
        }
        
        return Date()
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 투명하게 만드는 함수
    private func makeNavigationBarClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    private func initializeLabel() {
        self.topLabel.text = StringLiteral.topLabel
        self.topLabel.font = .systemFont(ofSize: FontSize.topLabelText)
    }
    
    /// 피커 뷰 초기 상태 세팅하는 함수
    /// 처음엔 가운데로, 이후엔 선택된 행의 인덱스에 따라 설정됨
    // TODO: 갑자기 안됨..
    private func initializePickerView() {
        let row = bottleData?.periodIndex ??
        NewBottleDatePickerViewController.pickerValues.count / 2
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.selectRow(
            row,
            inComponent: 0,
            animated: false
        )
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
