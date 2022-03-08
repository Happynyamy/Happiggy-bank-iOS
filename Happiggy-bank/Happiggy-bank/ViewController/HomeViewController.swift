//
//  HomeViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

// TODO: Bottle Label 디자인 확정시 추가
/// 메인 화면 전체를 관리하는 컨트롤러
final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    /// HomeViewController의 뷰
    @IBOutlet var homeView: UIView!
    
    /// 유리병 뷰를 관리하는 컨트롤러
    var bottleViewController: BottleViewController!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        configureBottleViewController()
        configureViewHierarchy()
        configureBottleViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Controller Configurations
    
    /// BottleViewController 구성 및 추가
    private func configureBottleViewController() {
        self.bottleViewController = BottleViewController()
        let bottleViewModel = BottleViewModel()
        // TODO: 현재 진행중인 유리병의 bottleID 넘겨주기
        bottleViewModel.bottleID = UUID().hashValue
        bottleViewController.viewModel = bottleViewModel
    }
    
    
    // MARK: - View Hierarchy
    
    private func configureViewHierarchy() {
        self.addChild(bottleViewController)
        self.homeView.addSubview(bottleViewController.view)
    }
    
    
    // MARK: - Constraints

    // TODO: UI 디자인 확정시 변경
    /// BottleViewController의 뷰 오토 레이아웃 적용
    private func configureBottleViewConstraints() {
        self.bottleViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottleViewController.view.widthAnchor.constraint(
                equalTo: view.widthAnchor
            ),
            bottleViewController.view.heightAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: Metric.pageViewHeightWidthRatio
            ),
            bottleViewController.view.bottomAnchor.constraint(
                equalTo: self.homeView.safeAreaLayoutGuide.bottomAnchor,
                constant: -Metric.spacing
            ),
            bottleViewController.view.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            )
        ])
        bottleViewController.view.backgroundColor = .systemOrange
    }
}
