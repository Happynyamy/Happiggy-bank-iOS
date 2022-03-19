//
//  NewNoteColorPickerViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

/// 새로운 쪽지를 추가하기 위한 컬러 피커 뷰를 관리하는 뷰 컨트롤러
class NewNoteColorPickerViewController: UIViewController {
    
    // MARK: - @IBOulet
    
    /// 취소 버튼과 다음 버튼을 담고 있는 내비게이션 바
    @IBOutlet var navigationBar: UINavigationBar!
    
    /// 색깔 버튼들의 배열
    @IBOutlet var colorButtons: [ColorButton]!
    
    /// 새로 추가할 쪽지의 날짜, 색깔, 저금통 정보
    var newNote: NewNote!
    
    /// 선택 가능한 색깔들
    private var colors = NoteColor.allCases
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureColorButtons()
    }
    
    
    // MARK: - @IBAction
    
    /// 뒤로가기 버튼(<)을 눌렀을 때 호출되는 액션 메서드 : 날짜 피커로 돌아감
    @IBAction func backButtonDidTap(_ sender: UIBarButtonItem) {
        self.performSegue(
            withIdentifier: SegueIdentifier.unwindToNewNoteDatePicker,
            sender: sender
        )
    }
    
    /// 다음 버튼(>)을 눌렀을 때 호출되는 액션 메서드 : 쪽지 작성 뷰를 띄움
    @IBAction func nextButtonDidTap(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SegueIdentifier.presentNewNoteTextView, sender: sender)
    }
    
    /// 선택한 색깔이 바뀌었을 때 호출되는 액션 메서드 : 선택에 따라 UI 업데이트 및 선택 색깔 기록
    @IBAction func colorButtonDidTap(_ sender: ColorButton) {
        guard sender.color != self.newNote.color
        else { return }
        
        self.colorButtons.forEach { $0.updateState(isSelected: $0.color == sender.color)}
        self.newNote.color = sender.color
    }

    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 설정
    private func configureNavigationBar() {
        /// 투명 배경
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        /// 하단 선 제거
        self.navigationBar.shadowImage = UIImage()
    }
    
    /// 색깔 버튼들 초기 상태 설정
    private func configureColorButtons() {
        for (button, color) in zip(self.colorButtons, self.colors) {
            button.color = color
            button.initialSetup(isSelected: button.color == self.newNote.color)
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewNoteTextView {
            
            guard let textViewController = segue.destination as? NewNoteTextViewController
            else { return }
            
            let viewModel = NewNoteTextViewModel(newNote: self.newNote)
            textViewController.viewModel = viewModel
        }
    }
}
