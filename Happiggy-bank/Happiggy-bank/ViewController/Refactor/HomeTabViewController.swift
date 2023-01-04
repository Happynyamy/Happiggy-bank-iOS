//
//  HomeTabViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/12/23.
//

import UIKit

import Then

// TODO: - 기존에 있는 HomeViewController 삭제

/// Home Tab 뷰 컨트롤러
final class HomeTabViewController: UIViewController {
    
    // MARK: - Properties
    
    var homeView: HomeView!

    /// 저금통이 진행중일 때 나타나는 더보기 버튼
    lazy var moreButton: UIButton = BaseButton().then {
        $0.setImage(AssetImage.more, for: .normal)
    }
    
    private var viewModel: HomeTabViewModel = HomeTabViewModel()
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.homeView = HomeView(
            title: self.viewModel.bottle?.title,
            dDay: self.viewModel.dDay(),
            hasNotes: self.viewModel.hasNotes
        )
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeView()
        configureButton()
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Objc Functions
    // TODO: - 화면 연결
    
    /// 화면 탭했을 때 액션
    @objc private func viewDidTap(_ sender: UITapGestureRecognizer) {
        print("view Did Tap")
    }
    
    /// 버튼 탭했을 때 액션
    @objc private func buttonDidTap(_ sender: BaseButton) {
        print("button Did Tap")
    }
    
    
    // MARK: - Functions
    
    private func configureHomeView() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.viewDidTap)
        )
        self.homeView.addGestureRecognizer(tap)
        self.homeView.title = self.viewModel.bottle?.title
        self.homeView.dDay = self.viewModel.dDay()
        self.homeView.hasNotes = self.viewModel.hasNotes
    }
    
    /// 더보기 버튼 세팅
    private func configureButton() {
        guard self.viewModel.hasBottle == true
        else { return }

        self.moreButton.addTarget(
            self,
            action: #selector(buttonDidTap),
            for: .touchUpInside
        )
        self.view.addSubview(self.moreButton)
        
        self.moreButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.centerY.equalTo(self.homeView.dDayLabel.snp.centerY)
        }
    }
}
