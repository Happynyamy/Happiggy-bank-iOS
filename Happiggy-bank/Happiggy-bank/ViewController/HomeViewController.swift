//
//  HomeViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

// TODO: Then 사용해서 property 초기화
/// 메인 화면 전체를 관리하는 컨트롤러
final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    /// HomeViewController의 뷰
    @IBOutlet var homeView: UIView!
    
    /// 환경설정 버튼
    var settingsButton: UIButton!
    
    /// 개봉 버튼
    var openBeforeFinishedButton: UIButton!
    
    /// 유리병 리스트 버튼
    var bottleListButton: UIButton!
    
    /// 현재까지의 쪽지와 목표치를 나타내는 라벨
    var noteProgressLabel: UIView!
    
    /// 유리병 뷰를 관리하는 컨트롤러
    var bottleViewController: BottleViewController!
    
    /// 홈 뷰의 뷰모델
    private var homeViewModel: HomeViewModel = HomeViewModel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
        if !homeViewModel.hasBottle {
            hideUnusedButtonAndLabels()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Button Actions(@objc functions)
    
    /// 환경설정 버튼 탭할 시 실행되는 함수
    @objc func settingsButtonDidTap(_ sender: UIButton) {
        print("Move to Settings View")
    }
    
    /// 개봉 버튼 탭할 시 실행되는 함수
    @objc func openBeforeFinishedButtonDidTap(_ sender: UIButton) {
        print("Open the jar")
    }
    
    /// 유리병 리스트 버튼 탭할 시 실행되는 함수
    @objc func userJarListButtonDidTap(_ sender: UIButton) {
        let bottleListViewController: BottleListViewController = BottleListViewController()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(bottleListViewController, animated: true)
    }
    
    /// 진행중인 유리병이 없을 시에 나타나는 초기 이미지 탭할 시 실행되는 함수
    @objc func initialImageViewDidTap(_ sender: UITapGestureRecognizer) {
        let createNewBottleViewController: CreateNewBottlePopupViewController
        = CreateNewBottlePopupViewController()
        
        createNewBottleViewController.modalPresentationStyle = .overCurrentContext
        present(createNewBottleViewController, animated: false)
    }
    
    
    // MARK: - Actions
    
    /// 현재 인덱스로 BottleViewController 생성
    func makeBottleViewController() -> BottleViewController {
        let bottleViewController: BottleViewController = BottleViewController()
        let bottleViewModel = BottleViewModel()
        // TODO: currentIndex 의 bottleID 넘겨주기
        bottleViewModel.bottleID = UUID().hashValue
        bottleViewController.viewModel = bottleViewModel
        return bottleViewController
    }
    
    
    // MARK: - UI Configurations
    
    /// 홈 뷰 UI 요소들 생성 및 HomeViewController의 하위 뷰로 추가
    private func configureView() {
        configureHomeView()
        configureButtons()
        configureLabel()
    }
    
    /// 홈 뷰 생성 및 추가
    private func configureHomeView() {
        navigationItem.backButtonTitle = ""
        configureBottleViewController()

    }
    
    /// 버튼 생성,  타겟 설정 및 추가
    private func configureButtons() {
        self.settingsButton = DefaultButton(imageName: "gearshape")
        self.openBeforeFinishedButton = DefaultButton(imageName: "hammer")
        self.bottleListButton = DefaultButton(imageName: "list.bullet")
        self.homeView.addSubview(settingsButton)
        self.homeView.addSubview(openBeforeFinishedButton)
        self.homeView.addSubview(bottleListButton)
        self.settingsButton.addTarget(
            self,
            action: #selector(settingsButtonDidTap(_:)),
            for: .touchUpInside
        )
        self.openBeforeFinishedButton.addTarget(
            self,
            action: #selector(openBeforeFinishedButtonDidTap(_:)),
            for: .touchUpInside
        )
        self.bottleListButton.addTarget(
            self,
            action: #selector(userJarListButtonDidTap(_:)),
            for: .touchUpInside
        )
    }
    
    /// 라벨 생성 및 추가
    private func configureLabel() {
        self.noteProgressLabel = NoteProgressLabel()
        self.homeView.addSubview(noteProgressLabel)
    }
    
    
    // MARK: - Controller Configurations
    
    /// PageViewController 구성
    private func configureBottleViewController() {
        self.bottleViewController = BottleViewController()
        let bottleViewModel = BottleViewModel()
        // TODO: currentIndex 의 bottleID 넘겨주기
        bottleViewModel.bottleID = UUID().hashValue
        bottleViewController.viewModel = bottleViewModel
        
        self.addChild(bottleViewController)
        self.homeView.addSubview(bottleViewController.view)
    }
    
    
    // MARK: - Constraints
    
    /// 홈 뷰 UI 요소(버튼, 라벨)의 오토레이아웃 적용
    private func configureConstraints() {
        configureButtonConstraints()
        configureLabelConstraints()
        configureBottleViewConstraints()
    }
    
    /// 버튼의 오토 레이아웃 적용
    private func configureButtonConstraints() {
        self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.openBeforeFinishedButton.translatesAutoresizingMaskIntoConstraints = false
        self.bottleListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(
                equalTo: self.homeView.safeAreaLayoutGuide.topAnchor
            ),
            settingsButton.trailingAnchor.constraint(
                equalTo: self.homeView.trailingAnchor,
                constant: -Metric.verticalPadding
            ),
            openBeforeFinishedButton.leadingAnchor.constraint(
                equalTo: self.homeView.leadingAnchor,
                constant: Metric.verticalPadding
            ),
            openBeforeFinishedButton.bottomAnchor.constraint(
                equalTo: self.homeView.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metric.verticalPadding
            ),
            bottleListButton.leadingAnchor.constraint(
                equalTo: self.homeView.leadingAnchor,
                constant: Metric.listButtonLeadingPadding
            ),
            bottleListButton.bottomAnchor.constraint(
                equalTo: self.homeView.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metric.verticalPadding
            ),
            settingsButton.widthAnchor.constraint(equalToConstant: Metric.buttonWidth),
            settingsButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeight),
            openBeforeFinishedButton.widthAnchor.constraint(
                equalToConstant: Metric.buttonWidth
            ),
            openBeforeFinishedButton.heightAnchor.constraint(
                equalToConstant: Metric.buttonHeight
            ),
            bottleListButton.widthAnchor.constraint(equalToConstant: Metric.buttonWidth),
            bottleListButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeight)
        ])
    }
    
    /// BottleViewController의 뷰 오토 레이아웃 적용
    private func configureBottleViewConstraints() {
        self.bottleViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottleViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottleViewController.view.heightAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: Metric.pageViewHeightWidthRatio),
            bottleViewController.view.bottomAnchor.constraint(
                equalTo: self.noteProgressLabel.topAnchor,
                constant: -Metric.spacing),
            bottleViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        bottleViewController.view.backgroundColor = .systemOrange
    }
    
    /// 라벨의 오토 레이아웃 적용
    private func configureLabelConstraints() {
        self.noteProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteProgressLabel.bottomAnchor.constraint(
                equalTo: self.homeView.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metric.verticalPadding
            ),
            noteProgressLabel.trailingAnchor.constraint(
                equalTo: self.homeView.trailingAnchor,
                constant: -Metric.verticalPadding
            ),
            noteProgressLabel.widthAnchor.constraint(
                equalToConstant: Metric.noteProgressLabelWidth
            ),
            noteProgressLabel.heightAnchor.constraint(equalToConstant: Metric.labelHeight)
        ])
    }
    
    
    // MARK: - Initial View Setting
    
    /// 진행중이 유리병이 없을시, 하단 버튼과 라벨 숨김
    private func hideUnusedButtonAndLabels() {
        self.openBeforeFinishedButton.isHidden = true
        self.bottleListButton.isHidden = true
        self.noteProgressLabel.isHidden = true
    }
}
