//
//  HomePageViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

/// 메인 화면 전체를 관리하는 컨트롤러
class HomeViewController: UIViewController {
    
    /// 메인 뷰
    var homeView: UIView!
    
    /// 환경설정 버튼
    var settingsButton: UIButton!
    
    /// 개봉 버튼
    var openBeforeFinishedButton: UIButton!
    
    /// 유리병 리스트 버튼
    var bottleListButton: UIButton!
    
    /// 현재까지의 쪽지와 목표치를 나타내는 라벨
    var noteProgressLabel: UIView!
    
    /// 페이지 뷰를 관리하는 컨트롤러
    var pageViewController: UIPageViewController!
    
    /// 각 페이지에 들어갈 이미지 이름 배열
    var pageImages: [String]!
    
    /// 현재 페이지 인덱스
    var currentIndex: Int = 0
    
    /// 최초인지 아닌지 확인
    private var hasBottle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageImages = []
        configureView()
        configureConstraints()
        if !hasBottle {
            hideUnusedButtonAndLabels()
            setInitialImage()
        }
        if hasBottle {
            self.pageImages = ["image1", "image2", "image3", "image4"]
            configurePageViewController()
            configurePageViewConstraints()
        }
    }
    
    
    // MARK: Actions
    
    /// 현재 인덱스로 BottleViewController 생성
    func makePageContentViewController(with index: Int) -> BottleViewController {
        let pageContentViewController: BottleViewController = BottleViewController()
        let pageContentViewModel = BottleViewModel()
        // TODO: currentIndex 의 bottleID 넘겨주기
        pageContentViewModel.bottleID = UUID().hashValue
        pageContentViewController.viewModel = pageContentViewModel
        pageContentViewController.index = index
        return pageContentViewController
    }
    
    
    // MARK: UI Configurations
    
    /// 홈 뷰 UI 요소들 생성 및 HomeViewController의 하위 뷰로 추가
    private func configureView() {
        configureMainView()
        configureButtons()
        configureLabel()
    }
    
    /// 홈 뷰 생성 및 추가
    private func configureMainView() {
        self.homeView = HomeView()
        self.view.addSubview(homeView)
    }
    
    /// 버튼 생성,  타겟 설정 및 추가
    private func configureButtons() {
        self.settingsButton = SettingsButton()
        self.openBeforeFinishedButton = OpenBeforeFinishedButton()
        self.bottleListButton = UserJarListButton()
        self.view.addSubview(settingsButton)
        self.view.addSubview(openBeforeFinishedButton)
        self.view.addSubview(bottleListButton)
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
        self.view.addSubview(noteProgressLabel)
    }
    
    
    // MARK: Controller Configurations
    
    /// PageViewController 구성
    private func configurePageViewController() {
        let startViewController: BottleViewController = self.makePageContentViewController(
            with: currentIndex
        )
        let viewControllerArray: NSArray = NSArray(object: startViewController)
        
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.setViewControllers(
            viewControllerArray as? [UIViewController],
            direction: .forward,
            animated: false,
            completion: nil
        )
        self.addChild(self.pageViewController)
        self.homeView.addSubview(self.pageViewController.view)
    }
    
    
    // MARK: Constraints
    
    /// 홈 뷰 UI 요소(버튼, 라벨)의 오토레이아웃 적용
    private func configureConstraints() {
        configureButtonConstraints()
        configureLabelConstraints()
    }
    
    /// 버튼의 오토 레이아웃 적용
    private func configureButtonConstraints() {
        self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.openBeforeFinishedButton.translatesAutoresizingMaskIntoConstraints = false
        self.bottleListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            settingsButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Metric.verticalPadding
            ),
            openBeforeFinishedButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Metric.verticalPadding
            ),
            openBeforeFinishedButton.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metric.verticalPadding
            ),
            bottleListButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 88
            ),
            bottleListButton.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
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
    
    /// PageViewController의 뷰 오토 레이아웃 적용
    private func configurePageViewConstraints() {
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageViewController.view.heightAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: Metric.pageViewHeightWidthRatio),
            pageViewController.view.bottomAnchor.constraint(
                equalTo: self.noteProgressLabel.topAnchor,
                constant: -Metric.spacing),
            pageViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        pageViewController.view.backgroundColor = .systemOrange
    }
    
    /// 라벨의 오토 레이아웃 적용
    private func configureLabelConstraints() {
        self.noteProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteProgressLabel.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metric.verticalPadding
            ),
            noteProgressLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Metric.verticalPadding
            ),
            noteProgressLabel.widthAnchor.constraint(
                equalToConstant: Metric.noteProgressLabelWidth
            ),
            noteProgressLabel.heightAnchor.constraint(equalToConstant: Metric.labelHeight)
        ])
    }
    
    
    // MARK: Initial View Setting
    
    /// 진행중이 유리병이 없을시, 하단 버튼과 라벨 숨김
    private func hideUnusedButtonAndLabels() {
        self.openBeforeFinishedButton.isHidden = true
        self.bottleListButton.isHidden = true
        self.noteProgressLabel.isHidden = true
    }
    
    /// 진행중인 유리병이 없을시, 초기 이미지로 홈 뷰 구성
    private func setInitialImage() {
        let initialImageView: UIImageView = UIImageView(image: UIImage(named: "image0"))
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(initialImageViewDidTap(_:))
        )
        self.view.addSubview(initialImageView)
        initialImageView.isUserInteractionEnabled = true
        initialImageView.addGestureRecognizer(tapGesture)
        initialImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            initialImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            initialImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    
    // MARK: Button Actions
    
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
        print("Move to User Jar List View")
    }
    
    /// 진행중인 유리병이 없을 시에 나타나는 초기 이미지 탭할 시 실행되는 함수
    @objc func initialImageViewDidTap(_ sender: UITapGestureRecognizer) {
        print("Make new jar")
    }
}
