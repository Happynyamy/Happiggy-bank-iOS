//
//  HomeTabViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/12/23.
//

import UIKit


// TODO: - 기존에 있는 HomeViewController 삭제

/// Home Tab 뷰 컨트롤러
final class HomeTabViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: HomeTabViewModel = HomeTabViewModel()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
    }
    
    override func loadView() {
        let homeView = HomeView(
            title: self.viewModel.bottle?.title,
            dDay: self.viewModel.dDay(),
            hasNotes: self.viewModel.hasNotes
        )
        self.view = homeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
