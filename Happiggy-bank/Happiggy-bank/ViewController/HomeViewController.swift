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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showBottleView {
            guard let bottleViewController = segue.destination as? BottleViewController
            else { return }
            
            let viewModel = BottleViewModel()
            // TODO: 홈뷰에서 데이터 넘겨받기
            viewModel.bottle = Bottle(title: "행복냠냠이", startDate: Date(), endDate: Date())
            bottleViewController.viewModel = viewModel
        }
    }
}
