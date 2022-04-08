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
    
    /// 저금통이 비었을 때 나타나는 배경 캐릭터
    @IBOutlet weak var homeCharacter: UIImageView!
    
    /// 저금통이 비었을 때 나타나는 상단 라벨
    @IBOutlet weak var emptyTopLabel: UILabel!
    
    /// 저금통이 비었을 때 나타나는 아래 라벨
    @IBOutlet weak var emptyBottomLabel: UILabel!
    
    /// 디데이 표시하는 라벨
    @IBOutlet weak var bottleDdayLabel: UILabel!
    
    /// 디데이 이름 표시하는 라벨
    @IBOutlet weak var bottleTitleLabel: UILabel!
    
    /// 유리병 뷰를 관리하는 컨트롤러
    var bottleViewController: BottleViewController!
    
    /// 데이터를 홈뷰에 맞게 변환해주는 ViewModel
    private var viewModel = HomeViewModel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        hideLabelIfNeeded()
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
            self.presentBottleOpenConfirmationAlert()
            self.bottleViewController.bottleOpenConfirmationAlertDidAppear()
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
    
    /// 새 저금통 생성 창에서 홈 뷰로 언와인드
    @IBAction func unwindCallToHomeViewFromNewBottleView(segue: UIStoryboardSegue) {
        // unwind from new bottle view controller to home view controller
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
    
    // swiftlint:disable force_cast
    /// 저금통 제목 라벨 탭했을 때 실행되는 함수
    @objc private func bottleTitleLabelDidTap(_ sender: UITapGestureRecognizer) {
        // go to title label edit view
        if self.viewModel.hasFixedTitle {
            presentBottleTitleAlreadyFixedAlert()
        } else {
            let bottleNameEditViewController = self.storyboard?.instantiateViewController(
                withIdentifier: StringLiteral.bottleNameEditViewController
            ) as! BottleNameEditViewController
            
            bottleNameEditViewController.bottle = self.viewModel.bottle
            self.present(bottleNameEditViewController, animated: true)
        }
    }
    // swiftlint:enable force_cast
    
    
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
    
    /// 조건에 따라 라벨 감추기
    private func hideLabelIfNeeded() {
        if self.viewModel.hasBottle {
            self.emptyTopLabel.isHidden = true
            self.emptyBottomLabel.isHidden = true
            self.homeCharacter.isHidden = true
        } else {
            self.bottleDdayLabel.isHidden = true
            self.bottleTitleLabel.isHidden = true
        }
    }
    
    /// 라벨 초기화
    private func initializeLabel() {
        if self.viewModel.hasBottle {
            addTapGestureToTitleLabel()
            self.bottleTitleLabel.text = self.viewModel.bottle?.title
            self.bottleDdayLabel.text = self.viewModel.dDay()
            if self.viewModel.isTodayEndDate {
                self.bottleDdayLabel.textColor = .customWarningLabel
                return
            }
            if self.viewModel.isEndDatePassed {
                let openDatePassedLabel = UILabel().then {
                    $0.text = StringLiteral.openDatePassedMessage
                    $0.font = .systemFont(ofSize: FontSize.openDatePassedLabelFont)
                    $0.textColor = .customWarningLabel
                    $0.translatesAutoresizingMaskIntoConstraints = false
                }
                self.view.addSubview(openDatePassedLabel)
                NSLayoutConstraint.activate([
                    openDatePassedLabel.centerYAnchor.constraint(
                        equalTo: self.bottleDdayLabel.centerYAnchor
                    ),
                    openDatePassedLabel.leadingAnchor.constraint(
                        equalTo: self.bottleDdayLabel.trailingAnchor,
                        constant: Metric.openDatePassedLabelLeadingPadding
                    )
                ])
                return
            }
        } else {
            self.emptyTopLabel.text = StringLiteral.emptyTopLabelText
            self.emptyBottomLabel.text = StringLiteral.emptyBottomLabelText
        }
    }
    
    /// 저금통 제목 라벨 탭 제스처 추가
    private func addTapGestureToTitleLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(bottleTitleLabelDidTap))
        self.bottleTitleLabel.isUserInteractionEnabled = true
        self.bottleTitleLabel.addGestureRecognizer(tap)
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
    
    
    // MARK: - Functions
    
    /// 저금통 개봉 의사를 물어보는 알림을 띄움
    private func presentBottleOpenConfirmationAlert() {
        let alert = self.makeBottleOpenConfirmationAlert()
        self.present(alert, animated: true)
    }
    
    /// 저금통 개봉 의사를 물어보는 알림을 생성
    private func makeBottleOpenConfirmationAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: StringLiteral.bottleOpenAlertTitle,
            message:StringLiteral.bottleOpenAlertMessage,
            preferredStyle: .alert
        )
        
        let openAction = UIAlertAction(
            title: StringLiteral.bottleOpenAlertOpenButtonTitle,
            style: .default
        ) { _ in
            self.bottleDidOpen()
        }
        
        let cancelAction = UIAlertAction(
            title: StringLiteral.bottleOpenAlertCancelButtonTitle,
            style: .cancel
        ) { _ in
            self.bottleViewController.bottleDidNotOpen()
        }
        
        alert.addAction(openAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    /// 저금통 이름을 이미 변경했을 때 표시하는 알림
    private func presentBottleTitleAlreadyFixedAlert() {
        let alert = makeBottleTitleAlreadyFixedAlert()
        self.present(alert, animated: true)
    }
    
    /// 저금통 이름을 이미 변경했을 때 표시하는 알림 생성
    private func makeBottleTitleAlreadyFixedAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: StringLiteral.bottleNameFixedAlertTitle,
            message: nil,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: StringLiteral.bottleNameFixedAlertConfirm,
            style: .default
        )
        
        alert.addAction(confirmAction)
        return alert
    }
    
    /// 저금통 개봉
    private func bottleDidOpen() {
        guard let bottle = self.viewModel.bottle
        else { return }
        
        self.viewModel.saveOpenedBottle(inContainerView: self.bottleViewController.view, bottle)
        HapticManager.instance.notification(type: .success)
        self.bottleViewController.bottleDidOpen(withDuration: Duration.bottleOpeningAnimation)
        self.performSegue(
            withIdentifier: SegueIdentifier.presentBottleMessageView,
            sender: self
        )
    }
}
