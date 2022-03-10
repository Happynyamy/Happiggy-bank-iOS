//
//  NewBottleNameFieldViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/03/10.
//

import UIKit

import Then

/// 새 유리병 이름 입력하는 뷰 컨트롤러
final class NewBottleNameFieldViewController: UIViewController {
    
    // MARK: Properties
    
    /// 내비게이션 바
    @IBOutlet var navigationBar: UINavigationBar!
    
    lazy var topLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.topLabel
        $0.font = .systemFont(ofSize: FontSize.topLabelText)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // TODO: 15글자 제한
    lazy var textField: UITextField = UITextField().then {
        $0.placeholder = StringLiteral.placeholder
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var bottomLabel: UILabel = UILabel().then {
        $0.text = StringLiteral.bottomLabel
        $0.font = .systemFont(ofSize: FontSize.bottomLabelText)
        $0.textColor = UIColor(hex: Color.bottomLabelText)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 유리병 데이터
    var bottleData: NewBottle?
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarcy()
        configureConstraints()
        makeNavigationBarClear()
    }
    
    /// 새 유리병 개봉 시점 선택 뷰 컨트롤러로 이동하기 전 유리병 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.presentNewBottleDatePicker {
            guard let newBottleDatePickerViewController: NewBottleDatePickerViewController =
                    segue.destination as? NewBottleDatePickerViewController
            else { return }
            
            let bottleName = textField.text
            if bottleName == "" {
                // TODO: Alert
                print("Need to set bottle name")
                return
            }
            newBottleDatePickerViewController.delegate = self
            newBottleDatePickerViewController.bottleData = NewBottle(
                name: bottleName,
                periodIndex: self.bottleData?.periodIndex
            )
        }
    }
    
    
    // MARK: IBAction
    
    /// 취소 버튼을 눌렀을 때 실행되는 액션
    @IBAction func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.fadeOut()
        self.dismiss(animated: false)
    }
    
    /// 새 유리병 개봉 시점 선택하는 뷰 컨트롤러로 이동하는 next button 액션
    @IBAction func nextButtonDidTap(_ sender: UIBarButtonItem) {
        self.performSegue(
            withIdentifier: SegueIdentifier.presentNewBottleDatePicker,
            sender: sender
        )
    }
    
    
    // MARK: View Hierarcy
    
    /// 뷰 계층 설정하는 함수
    private func configureViewHierarcy() {
        self.view.addSubview(topLabel)
        self.view.addSubview(textField)
        self.view.addSubview(bottomLabel)
    }
    
    
    // MARK: View Configuration
    
    /// 내비게이션 바 투명하게 만드는 함수
    private func makeNavigationBarClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    
    // MARK: Constraints
    
    /// 하위 뷰 오토레이아웃 지정하는 함수 모두 호출하는 함수
    private func configureConstraints() {
        topLabelConstraints()
        textFieldConstraints()
        bottomLabelConstraints()
    }
    
    /// 상단 라벨 오토레이아웃 설정
    private func topLabelConstraints() {
        NSLayoutConstraint.activate([
            self.topLabel.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: Metric.topLabelTopAnchor
            ),
            self.topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    /// 텍스트필드 오토레이아웃 설정
    private func textFieldConstraints() {
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(
                equalTo: self.topLabel.bottomAnchor,
                constant: Metric.textFieldTopAnchor
            ),
            self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    /// 하단 라벨 오토레이아웃 설정
    private func bottomLabelConstraints() {
        NSLayoutConstraint.activate([
            self.bottomLabel.topAnchor.constraint(
                equalTo: self.textField.bottomAnchor,
                constant: Metric.bottomLabelTopAnchor
            ),
            self.bottomLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

extension NewBottleNameFieldViewController: DataProvider {
    
    /// 유리병 데이터에 delegate를 통해 받아온 데이터를 대입해주는 함수
    func sendNewBottleData(_ data: NewBottle) {
        self.bottleData = data
    }
}
