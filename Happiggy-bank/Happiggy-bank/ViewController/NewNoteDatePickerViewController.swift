//
//  NewNoteDatePickerViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새로운 쪽지를 추가하기 위한 날짜 피커 뷰를 관리하는 뷰 컨트롤러
class NewNoteDatePickerViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    /// 취소 버튼과 다음 버튼을 담고 있는 내비게이션 바
    @IBOutlet var navigationBar: UINavigationBar!
    
    /// 컬러피커로 넘어가거나 쪽지 텍스트뷰로 돌아가는 버튼
    @IBOutlet var rightButton: UIBarButtonItem!
    
    /// 새로 쪽지를 작성할 날짜를 나타내는 날짜 피커
    @IBOutlet var datePickerView: UIPickerView!
    
    
    // MARK: - Properties
    
    /// 날짜 피커에서 필요한 형태로 데이터를 변환해주는 뷰모델
    var viewModel: NewNoteDatePickerViewModel!
    
    /// 새로 추가할 쪽지의 날짜, 색깔, 저금통 정보
    var newNote: NewNote!
    
    /// 텍스트뷰에서 날짜 피커로 넘어온 다음 날짜 피커를 이동했다가 그냥 취소를 눌렀을 때 선택 초기화 용도
    private var initialNote: NewNote!
    
    /// source 가 어디인지에 따라 기본 셋팅과 메서드 작동 방식 다르게 하기 위함
    var isFromNoteTextView = false
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.scrollToInitialPosition()
        self.configureRightButton()
        self.initialNote = self.newNote
    }

    
    // MARK: - @IBAction
    
    /// 취소 버튼(x)을 눌렀을 때 호출되는 액션 메서드 : 보틀뷰(홈뷰)/쪽지 텍스트뷰로 돌아감
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        if !self.isFromNoteTextView {
            self.fadeOut()
            self.dismiss(animated: false, completion: nil)
            return
        }
        if self.isFromNoteTextView {
            /// 취소했으므로 선택 초기화
            self.newNote = self.initialNote
            self.performSegue(
                withIdentifier: SegueIdentifier.unwindFromNoteDatePickerToTextView,
                sender: sender
            )
        }
    }
    
    /// 오른쪽 버튼을 눌렀을 때 호출되는 액션 메서드 : 컬러 피커를 띄우거나 쪽지 텍스트뷰로 돌아감
    @IBAction func rightButtonDidTap(_ sender: UIBarButtonItem) {
        if !self.isFromNoteTextView {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteColorPicker,
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
    
    /// 현재 뷰 컨트롤러로 unwind 하라는 호출을 받았을 때 실행되는 액션메서드
    @IBAction func unwindToNewNoteDatePickerCallDidArrive(segue: UIStoryboardSegue) {
        if segue.identifier == SegueIdentifier.unwindToNewNoteDatePicker {
            guard let colorPickerViewController = segue.source as? NewNoteColorPickerViewController
            else { return }
            
            self.newNote = colorPickerViewController.newNote
        }
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 설정
    private func configureNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 선택 가능한 가능 최근 날짜 혹은 이전에 선택한 날짜로 스크롤
    private func scrollToInitialPosition() {
        self.datePickerView.selectRow(
            Calendar.daysBetween(start: self.viewModel.bottle.startDate, end: self.newNote.date)-1,
            inComponent: Metric.defaultComponentIndex,
            animated: false
        )
    }
    
    /// 소스가 보틀뷰면 그대로 사용하고 쪽지 텍스트뷰면 확인 버튼으로 변경
    private func configureRightButton() {
        if self.isFromNoteTextView {
            rightButton.image = UIImage(systemName: "checkmark")
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewNoteColorPicker {
            
            guard let colorViewController = segue.destination as? NewNoteColorPickerViewController
            else { return }
            
            colorViewController.newNote = self.newNote
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
        
        let row = self.validatedRow(row)
        let rowView = view as? NewNoteDatePickerRowView ?? NewNoteDatePickerRowView()
        let data = self.viewModel.data[row]
        
        /// 데이터에 맞게 행의 모습(날짜 라벨 텍스트와 쪽지 이미지 색깔) 업데이트
        
        rowView.dateLabel.attributedText = self.viewModel.attributedDateString(for: data)
        
        if let color = data.color {
            // TODO: 에셋으로 갈아끼기
            rowView.colorImageView.backgroundColor = UIColor.note(color: color)
        }
    
        return rowView
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        let row = self.validatedRow(row)
        let source = self.viewModel.data[row]
        
        guard source.color == nil
        else {
            /// 쪽지를 이미 작성한 날짜는 선택 불가
            self.rightButton.isEnabled = false
            return
        }
        
        self.rightButton.isEnabled = true
        self.newNote.date = source.date
    }
    
    /// 0보다 작은 인덱스가 들어오면 0, 최대 개수보다 큰 값이 들어오면 마지막 인덱스로 바꿔주는 메서드
    private func validatedRow(_ row: Int) -> Int {
        var selectedRow = row
        if selectedRow < 0 {
            selectedRow = 0
        }
        if selectedRow > self.viewModel.numberOfRows {
            selectedRow = self.viewModel.numberOfRows - 1
        }
        return selectedRow
    }
}
