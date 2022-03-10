//
//  NewNoteColorPickerViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

class NewNoteColorPickerViewController: UIViewController {
    
    // MARK: - @IBOulet
    
    // 취소 버튼과 다음 버튼을 담고 있는 내비게이션 바
    @IBOutlet var navigationBar: UINavigationBar!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
    }
    
    
    // MARK: - @IBAction
    
    /// 뒤로가기 버튼(<)을 눌렀을 때 호출되는 액션 메서드 : 날짜 피커로 돌아감
    @IBAction func backButtonDidTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 다음 버튼(>)을 눌렀을 때 호출되는 액션 메서드 : 쪽지 작성 뷰를 띄움
    @IBAction func nextButtonDidTap(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SegueIdentifier.presentNewNoteTextView, sender: sender)
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 설정
    private func configureNavigationBar() {
        /// 투명 배경
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        /// 하단 선 제거
        self.navigationBar.shadowImage = UIImage()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
