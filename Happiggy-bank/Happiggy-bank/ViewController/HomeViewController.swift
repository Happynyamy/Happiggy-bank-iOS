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
    
    /// 저금통 정보 표시하는 상단 라벨
    @IBOutlet var bottleInfoLabel: UILabel!
    
    /// 유리병 뷰를 관리하는 컨트롤러
    var bottleViewController: BottleViewController!
    
    /// 데이터를 홈뷰에 맞게 변환해주는 ViewModel
    private var viewModel = HomeViewModel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        initializeLabel()
        
        self.observe(
            selector: #selector(refetch),
            name: .NSManagedObjectContextDidSave
        )
        self.configureBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - @IBAction
    
    /// 홈 뷰를 탭했을 떄 호출되는 액션 메서드
    @IBAction func viewDidTap(_ sender: UITapGestureRecognizer) {
        
        guard let bottle = self.viewModel.bottle
        else {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewBottleNameField,
                sender: sender
            )
            return
        }
        if !bottle.isInProgress {
            // TODO: create alert
            bottle.isOpen.toggle()
            self.bottleViewController.bottleIsOpened(withDuration: Duration.bottleOpeningAnimation)
            self.performSegue(
                withIdentifier: SegueIdentifier.presentBottleMessageView,
                sender: sender
            )
            return
        }
        if !bottle.hasEmptyDate {
            print("show some alert that no notes are writable")
            return
        }
        if !bottle.isEmtpyToday {
            /// 날짜 피커 띄우기
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteDatePicker,
                sender: sender
            )
            return
        }
        if bottle.isEmtpyToday {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteTextView,
                sender: sender
            )
        }
    }
    
    // FIXME: - sender 인식 안되므로 제거 필요, bottleViewController 의 unwindCallDidArrive 도 수정 필요 
    /// 홈 뷰로 언와인드할 떄 호출되는 액션 메서드
    @IBAction func unwindCallToHomeViewDidArrive(segue: UIStoryboardSegue, sender: Any? = nil) {
        
        let note = sender as? Note
        self.bottleViewController.unwindCallDidArrive(withNote: note)
        
    }
    
    
    // MARK: - @objc
    
    // TODO: 삭제 (새로운 저금통 추가했을 때 보기 위한 임시 메서드)
    @objc private func refetch() {
        guard self.bottleViewController.viewModel.bottle == nil
        else { return }
        
        // TODO: 1안 -> Notification + Object, 2안 -> refetch
        self.viewModel.executeFetchRequest()
        self.bottleViewController.viewModel.bottle = self.viewModel.bottle
        self.bottleViewController.initializeBottleView()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.bottleViewController?.prepareForSegue()
        
        if segue.identifier == SegueIdentifier.showBottleView {
            guard let bottleViewController = segue.destination as? BottleViewController
            else { return }
            
            let viewModel = BottleViewModel()
            viewModel.bottle = self.viewModel.bottle
            bottleViewController.viewModel = viewModel
            
            self.bottleViewController = bottleViewController
        }
        
        if segue.identifier == SegueIdentifier.presentNewNoteDatePicker {
            guard let dateViewController = segue.destination as? NewNoteDatePickerViewController,
                  let bottle = self.viewModel.bottle
            else { return }
            
            let viewModel = NewNoteDatePickerViewModel(initialDate: Date(), bottle: bottle)
            dateViewController.viewModel = viewModel
        }
        
        if segue.identifier == SegueIdentifier.presentNewNoteTextView {
            guard let textViewController = segue.destination as? NewNoteTextViewController,
                  let bottle = self.viewModel.bottle
            else { return }
            
            let viewModel = NewNoteTextViewModel(date: Date(), bottle: bottle)
            textViewController.viewModel = viewModel
        }
        
        if segue.identifier == SegueIdentifier.presentBottleMessageView {
            guard let bottleMessageController = segue.destination as? BottleMessageViewController,
                  let bottle = self.viewModel.bottle
            else { return }
            
            bottleMessageController.bottle = bottle
            bottleMessageController.fadeInOutduration = Duration.bottleOpeningAnimation
        }
    }
    
    
    // MARK: - Initialize View
    
    private func initializeLabel() {
        self.bottleInfoLabel.backgroundColor = UIColor(
            white: 1,
            alpha: Metric.bottleLabelBackgroundOpacity
        )
        self.bottleInfoLabel.layer.borderColor = UIColor.white.cgColor
        self.bottleInfoLabel.layer.borderWidth = Metric.bottleLabelBorderWidth
        self.bottleInfoLabel.layer.cornerRadius = Metric.bottleLabelCornerRadius
        self.bottleInfoLabel.layer.masksToBounds = true
    }
    
    /// 저금통 상태에 따른 저금통 이미지/애니메이션 등을 나타냄
    /// 저금통을 새로 추가하는 경우, 현재 진행중인 저금통이 있는 경우, 개봉을 기다리는 경우의 세 가지 상태가 있음
    private func configureBackgroundImage() {
        guard let bottle = self.viewModel.bottle
        else {
            print("show add new bottle image")
            return
        }
        
        /// 현재 채우는 저금통 있음
        if bottle.isInProgress {
            print("show bottle in progress")
            return
        }
        
        /// 기한 종료로 개봉 대기중
        if !bottle.isInProgress {
            print("show bottle ready to open")
        }
    }

}
