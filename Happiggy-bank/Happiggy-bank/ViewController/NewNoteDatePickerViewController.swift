//
//  NewNoteDatePickerViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

// FIXME: - 다른 앱 갔다 오면 선택 시 색깔 바꾼 게 사라짐
/// 새로운 쪽지를 추가하기 위한 날짜 피커 뷰를 관리하는 뷰 컨트롤러
final class NewNoteDatePickerViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    /// 취소 버튼과 다음 버튼을 담고 있는 내비게이션 바
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /// 컬러피커로 넘어가거나 쪽지 텍스트뷰로 돌아가는 버튼
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    /// 새로 쪽지를 작성할 날짜를 나타내는 날짜 피커
    @IBOutlet weak var datePickerView: UIPickerView!
    
    /// 이미 쪽지를 작성한 날짜를 선택했을 때 나타나는 경고 라벨
    @IBOutlet weak var warningLabel: UILabel!
    
    
    // MARK: - Properties
    
    /// 날짜 피커에서 필요한 형태로 데이터를 변환해주는 뷰모델
    var viewModel: NewNoteDatePickerViewModel!
    
    /// source 가 어디인지에 따라 기본 셋팅과 메서드 작동 방식 다르게 하기 위함
    var isFromNoteTextView = false
    
    /// 경고 라벨 애니메이션을 위해 필요
    var showWarningLabel = false
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.scrollToInitialPosition()
        self.configureRightButton()
        self.configureSelectionIndicator()
        self.observe(
            selector: #selector(viewWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard !self.isFromNoteTextView
        else { return }
        
        self.fadeInWarningLabel()
    }
    
    
    // MARK: - @IBAction
    
    /// 취소 버튼(x)을 눌렀을 때 호출되는 액션 메서드 : 보틀뷰(홈뷰)/쪽지 텍스트뷰로 돌아감
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.fadeOut()
        if self.isFromNoteTextView {
            self.dismiss(animated: false, completion: nil)
            return
        }
        if !self.isFromNoteTextView {
            self.performSegue(
                withIdentifier: SegueIdentifier.unwindFromNoteDatePickerToHomeView,
                sender: self
            )
        }
    }
    
    /// 오른쪽 버튼을 눌렀을 때 호출되는 액션 메서드 : 컬러 피커를 띄우거나 쪽지 텍스트뷰로 돌아감
    @IBAction func rightButtonDidTap(_ sender: UIBarButtonItem) {
        
        let row = self.datePickerView.selectedRow(inComponent: .zero)
        
        guard row >= .zero,
              self.viewModel.selectedDateIsAvailable(for: row)
        else {
            /// 이미 작성한 날짜를 선택한 상태에서 오른쪽 버튼을 누르는 경우 햅틱 알림
            HapticManager.instance.notification(type: .error)
            return
        }
        
        if !self.isFromNoteTextView {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteTextViewFromDatePicker,
                sender: sender
            )
            return
        }
        if self.isFromNoteTextView {
            self.performSegue(
                withIdentifier: SegueIdentifier.unwindFromNoteDatePickerToTextView,
                sender: sender)
        }
    }
    
    
    // MARK: - @objc
    
    /// 다시 앱으로 돌아왔을 때 호출
    @objc private func viewWillEnterForeground() {
        self.restoreTintColorAndWarningLabelStatus()
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 설정
    private func configureNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 날짜 피커의 셀렉션 인디케이터를 흰색으로 변경
    private func configureSelectionIndicator() {
        /// 기존 인디케이터 투명 처리
        let formerSelectionIndicator = self.datePickerView.subviews[1]
        formerSelectionIndicator.backgroundColor = .clear
        
        /// 흰색의 새로운 인디케이터 생성
        let newSelectionIndictor = UIView().then {
            $0.frame = formerSelectionIndicator.frame
            $0.layer.cornerRadius = formerSelectionIndicator.layer.cornerRadius
            $0.backgroundColor = .pickerSelectionColor
        }
        
        /// 뷰 체계에 삽입 및 오토 레이아웃 설정
        self.view.insertSubview(newSelectionIndictor, belowSubview: self.datePickerView)
        newSelectionIndictor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newSelectionIndictor.centerXAnchor.constraint(
                equalTo: formerSelectionIndicator.centerXAnchor
            ),
            newSelectionIndictor.centerYAnchor.constraint(
                equalTo: formerSelectionIndicator.centerYAnchor
            ),
            newSelectionIndictor.widthAnchor.constraint(
                equalTo: formerSelectionIndicator.widthAnchor
            ),
            newSelectionIndictor.heightAnchor.constraint(
                equalTo: formerSelectionIndicator.heightAnchor
            )
        ])
    }
    
    /// 오늘 날짜 혹은 이전에 선택한 날짜로 스크롤
    private func scrollToInitialPosition() {
        let row = self.viewModel.initialRow
        self.datePickerView.selectRow(
            row,
            inComponent: .zero,
            animated: false
        )
        
        self.updateSelectedRowView(
            self.datePickerView,
            forRow: row,
            forComponent: .zero,
            noteData: self.viewModel.noteData[row]
        )
    }
    
    /// 소스가 보틀뷰면 그대로 사용하고 쪽지 텍스트뷰면 확인 버튼으로 변경
    private func configureRightButton() {
        if self.isFromNoteTextView {
            rightButton.image = .customCheckmark
        }
    }
    
    /// 경고 라벨 나타내는 메서드
    private func fadeInWarningLabel() {
        self.warningLabel.fadeIn()
        self.showWarningLabel = true
    }
    
    /// 선택된 행의 글자 색깔 업데이트: 작성 가능한 경우 파랑, 불가능한 경우 회색
    private func updateSelectedRowView(
        _ pickerView: UIPickerView,
        forRow row: Int,
        forComponent component: Int,
        noteData: NoteDatePickerData
    ) {
        guard let rowView = pickerView.view(forRow: row, forComponent: component)
                as? NewNoteDatePickerRowView
        else { return }
        
        rowView.dateLabel.attributedText = self.viewModel.attributedDateString(
            for: noteData,
            isSelected: true
        )
    }
    
    /// 이전 상태와 같게 틴트 컬러 및 경고 라벨 상태 복구
    private func restoreTintColorAndWarningLabelStatus() {
        let selectedRow = self.validatedRow(self.datePickerView.selectedRow(inComponent: .zero))
        let noteDatePickerData = self.viewModel.noteData[selectedRow]
        
        guard let rowView = self.datePickerView.view(
            forRow: selectedRow,
            forComponent: .zero
        ) as? NewNoteDatePickerRowView
        else { return }
        
        /// 선택 가능하면 틴트컬러 적용
        rowView.dateLabel.attributedText = self.viewModel.attributedDateString(
            for: noteDatePickerData,
               isSelected: true
        )
        
        guard noteDatePickerData.color != nil
        else { return }
        
        /// 선택 불가능하면 경고 라벨
        self.showWarningLabel = true
        self.fadeInWarningLabel()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewNoteTextViewFromDatePicker {
            
            guard let textViewController = segue.destination as? NewNoteTextViewController
            else { return }
            
            let viewModel = NewNoteTextViewModel(date: self.viewModel.selectedDate, bottle: self.viewModel.bottle)
            textViewController.viewModel = viewModel
        }
    }
}


// MARK: - UIPickerViewDataSource
extension NewNoteDatePickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Metric.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.viewModel.numberOfRows
    }
}


// MARK: - UIPickerViewDelegate
extension NewNoteDatePickerViewController: UIPickerViewDelegate {
    
    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        
        if self.showWarningLabel {
            self.warningLabel.fadeOut()
            self.showWarningLabel = false
        }
        
        let row = self.validatedRow(row)
        let noteData = self.viewModel.noteData[row]
        let rowView = view as? NewNoteDatePickerRowView ?? NewNoteDatePickerRowView()
        
        /// 데이터에 맞게 행의 모습(날짜 라벨 텍스트와 쪽지 이미지 색깔) 업데이트
        rowView.dateLabel.attributedText = self.viewModel.attributedDateString(for: noteData)
        rowView.colorImageView.image = self.viewModel.image(for: noteData)
    
        return rowView
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        let row = self.validatedRow(row)
        let noteData = self.viewModel.noteData[row]
        
        self.updateSelectedRowView(
            pickerView,
            forRow: row,
            forComponent: component,
            noteData: noteData
        )

        guard self.viewModel.selectedDateIsAvailable(for: row)
        else {
            /// 이미 작성한 날짜면 경고 라벨 띄우고 버튼 회색 처리
            self.fadeInWarningLabel()
            return
        }
        
        self.viewModel.selectedDate = noteData.date
    }
    
    /// 0보다 작은 인덱스가 들어오면 0, 최대 개수보다 큰 값이 들어오면 마지막 인덱스로 바꿔주는 메서드
    private func validatedRow(_ row: Int) -> Int {
        var selectedRow = row
        if selectedRow < .zero {
            selectedRow = .zero
        }
        if selectedRow > self.viewModel.numberOfRows {
            selectedRow = self.viewModel.numberOfRows - 1
        }
        return selectedRow
    }
}
