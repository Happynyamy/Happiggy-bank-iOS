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
    
    /// 컬러피커로 넘어가는 버튼
    @IBOutlet var nextButton: UIBarButtonItem!
    
    /// 새로 쪽지를 작성할 날짜를 나타내는 날짜 피커
    @IBOutlet var datePickerView: UIPickerView!
    
    
    // MARK: - Properties
    
    /// 날짜 피커에서 필요한 형태로 데이터를 변환해주는 뷰모델
    var viewModel: NewNoteDatePickerViewModel!
    
    /// 새로 추가할 쪽지의 날짜, 색깔, 저금통 정보
    private lazy var newNote = NewNote(
        date: self.viewModel.mostRecentEmptyDate,
        bottle: self.viewModel.bottle
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.datePickerView.selectRow(
            self.viewModel.mostRecentEmptyDateIndex,
            inComponent: Metric.defaultComponentIndex,
            animated: false
        )
    }

    
    // MARK: - @IBAction
    
    /// 취소 버튼(x)을 눌렀을 때 호출되는 액션 메서드 : 보틀뷰(홈뷰)로 돌아감
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.fadeOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    /// 다음 버튼(>) 을 눌렀을 때 호출되는 액션 메서드 : 컬러 피커를 띄움
    @IBAction func nextButtonDidTap(_ sender: UIBarButtonItem) {
        self.performSegue(
            withIdentifier: SegueIdentifier.presentNewNoteColorPicker,
            sender: sender
        )
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
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewNoteColorPicker {
            
            guard let colorPickerviewController = segue.destination as? NewNoteColorPickerViewController
            else { return }
            
            colorPickerviewController.newNote = self.newNote
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
        let source = self.viewModel.data[row]
        
        rowView.dateLabel.text = source.date.customFormatted(type: .dots)
        
        if let color = source.color {
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
            self.nextButton.isEnabled = false
            return
        }
        
        self.nextButton.isEnabled = true
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
