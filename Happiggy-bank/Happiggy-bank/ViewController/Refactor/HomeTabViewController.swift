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
    
    private var viewModel: HomeTabViewModel = HomeTabViewModel()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        let homeView = HomeView()
        self.view = homeView
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
