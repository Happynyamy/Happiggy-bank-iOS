//
//  HomeViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import CoreData
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
    
    /// 탭 해서 쪽지 추가 라벨
    @IBOutlet weak var tapToAddNoteLabel: UILabel!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.observe(selector: #selector(refetch), name: .NSManagedObjectContextDidSave)
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
            self.present(self.bottleOpenConfirmationAlert(), animated: true)
            self.bottleViewController.alertOrModalDidAppear()
            return
        }
        if !bottle.hasEmptyDate {
            self.present(self.noEmptyDateAlert(), animated: true)
            return
        }
        if !bottle.isEmtpyToday {
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
        
        // 저금통 이름 바꿨을 때
        self.bottleTitleLabel.text = self.viewModel.bottle?.title
        
        // 쪽지 최초 추가
        if self.viewModel.bottle?.notes.count == 1 {
            self.homeCharacter.isHidden = true
            self.tapToAddNoteLabel.isHidden = true
        }
        
        // 저금통 없을 때
        guard self.viewModel.bottle == nil
        else { return }
        
        // TODO: 1안 -> Notification + Object, 2안 -> refetch
        self.viewModel.executeFetchRequest()
        self.bottleViewController.viewModel.bottle = self.viewModel.bottle
        self.bottleViewController.initializeBottleView()
        
        // 최초에 만들었을 때
        // 캐릭터 교체, 라벨 추가
        hideLabelIfNeeded()
        initializeLabel()
    }
    
    // swiftlint:disable force_cast
    /// 저금통 제목 라벨 탭했을 때 실행되는 함수
    @objc private func bottleTitleLabelDidTap(_ sender: UITapGestureRecognizer) {
        // go to title label edit view
        let bottleNameEditViewController = self.storyboard?.instantiateViewController(
            withIdentifier: StringLiteral.bottleNameEditViewController
        ) as! BottleNameEditViewController
        
        bottleNameEditViewController.bottle = self.viewModel.bottle
        self.present(bottleNameEditViewController, animated: true)
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
                  let (fakeBackground, bottle) = sender as? (UIView, Bottle)
            else { return }
            
            bottleMessageController.bottle = bottle
            bottleMessageController.fakeBackground = fakeBackground
            bottleMessageController.fadeInOutduration = Duration.bottleOpeningAnimation
            bottleMessageController.mainTabBarController = self.tabBarController
        }
    }
    
    
    // MARK: - Initialize View
    
    // 저금통 없음: 저금통 추가해주셈 + 하단라벨 + 플러스 냠냠
    // 저금통 있음, 쪽지 없음: D-day + 제목 + 그냥냠냠 + 탭해서 추가해주셈
    // 저금통 있음, 쪽지 있음: D-day + 제목 + 쪽지
    
    /// 조건에 따라 라벨 감추기
    private func hideLabelIfNeeded() {
        
        showLabels()
        
        // 저금통 없는 상태
        if !self.viewModel.hasBottle {
            self.bottleDdayLabel.isHidden = true
            self.bottleTitleLabel.isHidden = true
            self.tapToAddNoteLabel.isHidden = true
            return
        }
        
        // 저금통 있는 상태, 쪽지는 없음
        if self.viewModel.hasBottle && !self.viewModel.hasNotes {
            self.emptyTopLabel.isHidden = true
            self.emptyBottomLabel.isHidden = true
            return
        }
        
        // 저금통 있고, 쪽지도 있음
        if self.viewModel.hasBottle && self.viewModel.hasNotes {
            self.emptyTopLabel.isHidden = true
            self.emptyBottomLabel.isHidden = true
            self.homeCharacter.isHidden = true
            self.tapToAddNoteLabel.isHidden = true
            return
        }
    }
    
    private func showLabels() {
        self.emptyTopLabel.isHidden = false
        self.emptyBottomLabel.isHidden = false
        self.homeCharacter.isHidden = false
        self.bottleDdayLabel.isHidden = false
        self.bottleTitleLabel.isHidden = false
        self.tapToAddNoteLabel.isHidden = false
    }
    
    /// 라벨 초기화
    private func initializeLabel() {
        
        // 저금통 있을 때
        if self.viewModel.hasBottle {
            addTapGestureToTitleLabel()
            self.bottleTitleLabel.text = self.viewModel.bottle?.title
            self.bottleDdayLabel.text = self.viewModel.dDay()
            
            // 추가된 쪽지가 없을 때
            if !self.viewModel.hasNotes {
                self.tapToAddNoteLabel.text = StringLiteral.tapToAddNoteLabelText
                self.homeCharacter.image = UIImage(named: StringLiteral.homeCharacterInitialName)
                return
            }
            
            // 오늘이 개봉 날일 때
            if self.viewModel.isTodayEndDate {
                self.bottleDdayLabel.textColor = .customWarningLabel
                return
            }
            
            // 이미 개봉날이 지났을 때
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
            // 비었을 때
            self.emptyTopLabel.text = StringLiteral.emptyTopLabelText
            self.emptyBottomLabel.text = StringLiteral.emptyBottomLabelText
            self.homeCharacter.image = UIImage(named: StringLiteral.homeCharacterEmpty)
        }
    }
    
    /// 저금통 제목 라벨 탭 제스처 추가
    private func addTapGestureToTitleLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(bottleTitleLabelDidTap))
        self.bottleTitleLabel.isUserInteractionEnabled = true
        self.bottleTitleLabel.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Functions
    
    /// 저금통 개봉 의사를 물어보는 알림을 띄움
    private func bottleOpenConfirmationAlert() -> UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(
            title: StringLiteral.bottleOpenAlertOpenButtonTitle
        ) { _ in
            self.bottleDidOpen()
        }
            
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.bottleViewController.restoreStateBeforeAlertOrModalDidAppear()
        }
        
        return UIAlertController.basic(
            alertTitle: StringLiteral.bottleOpenAlertTitle,
            alertMessage: StringLiteral.bottleOpenAlertMessage,
            confirmAction: confirmAction,
            cancelAction: cancelAction
        )
    }
    
    /// 저금통 개봉
    private func bottleDidOpen() {
        guard let bottle = self.viewModel.bottle
        else { return }
        
        let fakeBackground = self.tabBarController?.view.snapshotView(afterScreenUpdates: false)
        bottle.image = self.viewModel.takeBottleSnapshot(
            inContainerView: self.bottleViewController.view
        )
        HapticManager.instance.notification(type: .success)
        self.bottleViewController.bottleDidOpen(withDuration: Duration.bottleOpeningAnimation)
        self.performSegue(
            withIdentifier: SegueIdentifier.presentBottleMessageView,
            sender: (fakeBackground, bottle)
        )
        self.viewModel.bottle = nil
    }
    
    /// 모든 날짜에 쪽지를 작성했다는 알림을 띄움
    private func noEmptyDateAlert() -> UIAlertController {
        UIAlertController.basic(
            alertTitle: StringLiteral.noEmptyDateAlertTitle,
            alertMessage: StringLiteral.noEmptyDateAlertMessage,
            confirmAction: UIAlertAction.confirmAction()
        )
    }
}
