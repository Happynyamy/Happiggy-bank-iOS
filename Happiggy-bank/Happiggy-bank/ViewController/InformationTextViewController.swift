//
//  InformationTextViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/21.
//

import UIKit

/// 정보를 담은 단일 텍스트 뷰를 나타내는 컨트롤러
final class InformationTextViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    /// 정보를 담을 텍스트뷰 
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - Properties
    
    /// 뷰모델
    private var viewModel: InformationTextViewDataSource!
    
    
    // MARK: - Inits
    
    init?(coder: NSCoder, viewModel: InformationTextViewDataSource) {
        super.init(coder: coder)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("don't use me!")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.configureTextView()
    }
    
    
    // MARK: - Functions
    
    /// 내비게이션 바 초기 설정
    private func configureNavigationBar() {
        self.navigationItem.title = self.viewModel.navigationTitle
        self.removeNavigationBarSeperator()
    }
    
    /// 내비게이션 바 하단 구분 선 제거
    private func removeNavigationBarSeperator() {
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
    }
    
    /// 텍스트뷰 초기 설정
    private func configureTextView() {
        self.textView.attributedText = self.viewModel.attributedInformationString
        self.textView.textColor = .label
    }
}
