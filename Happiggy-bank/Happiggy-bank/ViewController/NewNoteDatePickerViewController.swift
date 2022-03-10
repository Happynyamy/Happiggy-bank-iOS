//
//  NewNoteDatePickerViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/10.
//

import UIKit

class NewNoteDatePickerViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    // 취소 버튼과 다음 버튼을 담고 있는 내비게이션 바
    @IBOutlet var navigationBar: UINavigationBar!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
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
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 UI 설정
    private func configureNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
