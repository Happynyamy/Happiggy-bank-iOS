//
//  HomeViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import CoreData
import UIKit

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
    
    /// 저금통 이름 뷰로, 라벨과 라벨 이미지들을 담고 있음
    @IBOutlet weak var bottleTitleView: UIView!
    
    /// 저금통 이름 표시하는 라벨
    @IBOutlet weak var bottleTitleLabel: UILabel!
    
    /// 저금통 이름 변경, 중도 개봉 기능을 담은 메뉴 버튼
    @IBOutlet weak var moreButton: UIButton!
    
    /// 유리병 뷰를 관리하는 컨트롤러
    var bottleViewController: BottleMotionViewController!
    
    /// 데이터를 홈뷰에 맞게 변환해주는 ViewModel
    private var viewModel = HomeViewModel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        hideLabelIfNeeded()
        initializeLabel()
        self.observe(selector: #selector(refetch), name: .NSManagedObjectContextDidSave)
        self.observe(
            selector: #selector(updateWhenEnterForeground),
            name: UIApplication.willEnterForegroundNotification
        )
        self.observeCustomFontChange()
        self.configureMoreButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.observe(selector: #selector(refetch), name: .NSManagedObjectContextDidSave)
        self.observe(
            selector: #selector(updateWhenEnterForeground),
            name: UIApplication.willEnterForegroundNotification
        )
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
            return self.performSegue(
                withIdentifier: SegueIdentifier.presentNewBottleNameField,
                sender: sender
            )
        }
        if !bottle.isInProgress {
            return self.present(self.tapMoreButtonToOpenBottleAlert(), animated: true)
        }
        if !bottle.hasEmptyDate {
            return self.present(self.noEmptyDateAlert(), animated: true)
        }
        if !bottle.isEmtpyToday {
            return self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteDatePicker,
                sender: sender
            )
        }
        if bottle.isEmtpyToday {
            return self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteTextView,
                sender: sender
            )
        }
    }

    /// 홈 뷰로 언와인드할 떄 호출되는 액션 메서드
    @IBAction func unwindCallToHomeViewDidArrive(segue: UIStoryboardSegue) {
        self.bottleViewController.unwindCallDidArrive()
    }
    
    /// 새 저금통 생성 창에서 홈 뷰로 언와인드
    @IBAction func unwindCallToHomeViewFromNewBottleView(segue: UIStoryboardSegue) {}
    
    /// 더보기 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func moreButtonDidTap(_ sender: UIButton) {
        self.configureMoreButton()
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
        
        // 최초에 만들었을 때
        // 캐릭터 교체, 라벨 추가, 더보기 버튼에 항목 추가
        hideLabelIfNeeded()
        initializeLabel()
        
        guard let bottle = self.viewModel.bottle
        else { return }
        
        self.bottleViewController.bottleDidAdd(bottle)
        self.configureMoreButton()
    }
    
    /// 백그라운드에서 포어그라운드로 돌아왔을 때 실행되는 메서드
    @objc private func updateWhenEnterForeground() {
        hideLabelIfNeeded()
        initializeLabel()
        self.configureMoreButton()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.bottleViewController?.prepareForSegue()
        
        if segue.identifier == SegueIdentifier.showBottleView {
            guard let bottleViewController = segue.destination as? BottleMotionViewController
            else { return }

            if let bottle = self.viewModel.bottle {
                bottleViewController.bottleDidAdd(bottle)
            }
            self.bottleViewController = bottleViewController
        }
        if segue.identifier == SegueIdentifier.presentNewNoteDatePicker {
            guard let dateViewController = segue.destination as? NewNoteDatePickerViewController,
                  let bottle = self.viewModel.bottle
            else { return }
            
            let viewModel = NewNoteDatePickerViewModel(newNote: .init(date: Date(), bottle: bottle))
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
            self.moreButton.isHidden = true
            self.bottleTitleView.isHidden = true
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
        self.moreButton.isHidden = false
        self.bottleTitleView.isHidden = false
        self.tapToAddNoteLabel.isHidden = false
    }
    
    /// 라벨 초기화
    private func initializeLabel() {
        // 저금통 있을 때
        if self.viewModel.hasBottle {
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
        } else {
            // 비었을 때
            self.emptyTopLabel.text = StringLiteral.emptyTopLabelText
            self.emptyBottomLabel.text = StringLiteral.emptyBottomLabelText
            self.homeCharacter.image = UIImage(named: StringLiteral.homeCharacterEmpty)
        }
    }
    
    
    // MARK: - Functions
    
    /// 저금통 개봉 의사를 물어보는 알림을 띄움
    private func bottleOpenConfirmationAlertController(for bottle: Bottle) -> UIAlertController {
        let confirmAction = UIAlertAction.confirmAction(
            title: BottleOpenAlert.openButtonTitle,
            style: bottle.isInProgress ? .destructive : .default
        ) { _ in
            self.bottleDidOpen()
        }
        let cancelAction = UIAlertAction.cancelAction { _ in
            self.bottleViewController.restoreStateBeforeAlertOrModalDidAppear()
        }
        let title = bottle.isInProgress ?
        BottleOpenAlert.midOpen.title : BottleOpenAlert.default.title
        let message = bottle.isInProgress ?
        BottleOpenAlert.midOpen.message : BottleOpenAlert.default.message
        return UIAlertController.basic(
            alertTitle: title,
            alertMessage: message,
            preferredStyle: bottle.isInProgress ? .actionSheet : .alert,
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
        
        removeAllRemindNotifications()
    }
    
    /// 모든 날짜에 쪽지를 작성했다는 알림
    private func noEmptyDateAlert() -> UIAlertController {
        UIAlertController.basic(
            alertTitle: StringLiteral.noEmptyDateAlertTitle,
            alertMessage: StringLiteral.noEmptyDateAlertMessage,
            confirmAction: UIAlertAction.confirmAction()
        )
    }
    
    // swiftlint:disable force_cast
    /// 메뉴 버튼에서 저금통 제목 변경을 선택했을 때 실행되는 함수
    private func changeBottleNameItemDidTap() {
        guard let bottle = self.viewModel.bottle
        else { return }
        
        // go to title label edit view
        let bottleNameEditViewController = self.storyboard?.instantiateViewController(
            withIdentifier: StringLiteral.bottleNameEditViewController
        ) as! BottleNameEditViewController
        
        bottleNameEditViewController.bottle = bottle
        bottleNameEditViewController.delegate = self
        self.present(bottleNameEditViewController, animated: true)
        self.bottleViewController.alertOrModalDidAppear()
    }
    // swiftlint:enable force_cast
    
    /// 유저가 저금통을 개봉하려고 할 때 호출되는 함수
    private func openBottleItemDidTap(_ bottle: Bottle) {
        self.bottleViewController.alertOrModalDidAppear()
        self.present(self.bottleOpenConfirmationAlertController(for: bottle), animated: true)
    }
    
    /// 더보기 버튼 설정
    private func configureMoreButton() {
        guard let bottle = self.viewModel.bottle
        else { return }
        
        let changeBottleName = UIAction(title: MoreButton.changeBottleName.title) { [weak self] _ in
            self?.changeBottleNameItemDidTap()
        }
        let openBottle = self.configureOpenBottleItem(forBottle: bottle)
        self.moreButton.menu = UIMenu(children: [changeBottleName, openBottle])
    }
    
    /// 더보기 버튼의 저금통 개봉 아이템 설정
    private func configureOpenBottleItem(forBottle bottle: Bottle) -> UIAction {
        let title = MoreButton.openBottle(bottle.isInProgress ? .inProgress : .complete).title
        var attributes: UIMenuElement.Attributes = []
        
        if bottle.isInProgress {
            attributes = (Date() >= bottle.startDate) ? .destructive : .disabled
        }
        
        return UIAction(title: title, attributes: attributes) { [weak self] _ in
            self?.openBottleItemDidTap(bottle)
        }
    }
    
    /// 더보기 버튼을 눌러 저금통을 개봉하라고 알려주는 알림
    private func tapMoreButtonToOpenBottleAlert() -> UIAlertController {
        return UIAlertController.basic(
            alertTitle: StringLiteral.tapMoreButtonToOpenBottleAlertTitle,
            confirmAction: .confirmAction()
        )
    }
    
    // TODO: - 중도개봉 후 리마인드 알림 버튼 UI가 자동으로 OFF되지 않는 현상 수정
    /// 전달된, 대기중인 모든 노티피케이션 삭제
    private func removeAllRemindNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        for day in 0...Metric.repeatingDays {
            notificationCenter.removeDeliveredNotifications(
                withIdentifiers: [StringLiteral.notificationIdentifier + "\(day)"]
            )
            notificationCenter.removePendingNotificationRequests(
                withIdentifiers: [StringLiteral.notificationIdentifier + "\(day)"]
            )
        }
        UserDefaults.standard.set(
            false,
            forKey: NotificationSettingsViewModel.Content.userDefaultsKey[.reminder] ?? ""
        )
    }
}


// MARK: - Presenter
extension HomeViewController: Presenter {
    func presentedViewControllerDidDismiss(withResult: CustomResult) {
        self.bottleViewController.restoreStateBeforeAlertOrModalDidAppear()
    }
}

extension HomeViewController {
    
    /// HomeViewController 에서  설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {
        
        /// 좌우 패딩 값 : 24
        static let verticalPadding: CGFloat = 24
        
        /// 버튼 높이 : 48
        static let buttonHeight: CGFloat = 48
        
        /// 버튼 길이(높이와 동일)
        static let buttonWidth: CGFloat = buttonHeight
        
        /// Bottle Label의 Border Width
        static let bottleLabelBorderWidth: CGFloat = 1
        
        /// Bottle Label의 Corner Radius
        static let bottleLabelCornerRadius: CGFloat = 10
        
        /// Bottle Label의 배경 투명도
        static let bottleLabelBackgroundOpacity: CGFloat = 0.6
        
        /// 기한이 지났는데 저금통을 열지 않은 경우 나타내는 라벨 앞쪽 패딩
        static let openDatePassedLabelLeadingPadding: CGFloat = 16
        
        /// 리마인드 알림이 반복되는 날짜
        static let repeatingDays: Int = 3
    }
    
    /// 애니메이션 시간
    enum Duration {
        
        /// 저금통 개봉 애니메이션 시간
        static let bottleOpeningAnimation: TimeInterval = 1.0
    }
    
    /// 문자열
    enum StringLiteral {
        
        /// 저금통이 없는 경우 나타나는 상단 라벨 문자열
        static let emptyTopLabelText: String = "저금통이 없습니다."
        
        /// 저금통이 없는 경우 나타나는 아래 라벨 문자열
        static let emptyBottomLabelText: String = "탭해서 행복저금통을 추가해주세요."
        
        /// 기한이 지났는데 저금통을 열지 않은 경우 나타내는 문자열
        static let openDatePassedMessage: String = "저금통을 개봉해주세요!"
        
        /// BottleNameEditViewController identifier
        static let bottleNameEditViewController = "BottleNameEditViewController"
        
        /// 저금통 생성 후 쪽지가 없을 때 나타내는 라벨 문자열
        static let tapToAddNoteLabelText: String = "화면을 탭해서 첫 행복을 작성하세요."
        
        /// 저금통 생성 후 쪽지가 없을 때 나타내는 캐릭터 이미지 이름
        static let homeCharacterInitialName: String = "homeCharacterInitial"
        
        /// 작성 가능한 날짜가 없음을 알리는 알람의 제목
        static let noEmptyDateAlertTitle = "이미 모든 날짜에 행복을 기록했어요"
        
        /// 작성 가능한 날짜가 없음을 알리는 알람의 메시지
        static let noEmptyDateAlertMessage = "미래의 날짜는 작성 불가능합니다."
        
        /// 저금통이 없을 때 나타나는 캐릭터 이미지 이름
        static let homeCharacterEmpty = "homeCharacter"
        
        /// 더보기 버튼을 눌러서 저금통 개봉이 가능함을 알리는 알림의 제목
        static let tapMoreButtonToOpenBottleAlertTitle =
        "오른쪽 위 더보기 버튼을 눌러 저금통을 개봉할 수 있어요!"
        
        /// 노티피케이션 식별자
        static let notificationIdentifier: String = "repeatingNotification"
    }
    
    /// 폰트 크기
    enum FontSize {
        
        /// 기한이 지났는데 저금통을 열지 않은 경우 나타내는 라벨 폰트 크기
        static let openDatePassedLabelFont: CGFloat = 15
    }
    
    /// 저금통 개봉 알림 관련 문자열
    enum BottleOpenAlert {
        
        /// 디데이 이후 개봉하는 경우
        case `default`
        
        /// 디데이 전에 개봉하는 경우
        case midOpen
        
        /// 알림 제목
        var title: String {
            switch self {
            case .default:
                return "저금통 개봉날이에요! 개봉하시겠어요?"
            case .midOpen:
                return "지금 저금통을 개봉하시겠어요?"
            }
        }
        
        /// 알림 메시지
        var message: String {
            switch self {
            case .default:
                return "현재 저금통 모습이 그대로 저장됩니다"
            case .midOpen:
                return """
중도 개봉 시 더 이상 추가로 작성할 수 없으며,
현재 저금통 모습이 그대로 저장됩니다
"""
            }
        }
        
        /// 저금통 개봉 확인 알림 개봉 버튼 제목
        static let openButtonTitle = "개봉"
    }
    
    /// 더보기 버튼
    enum MoreButton {
        /// 저금통 이름 변경
        case changeBottleName
        /// 저금통 개봉
        case openBottle(BottleStatus)
        
        /// 아이템 별 제목
        var title: String {
            switch self {
            case .changeBottleName:
                return "이름 변경"
            case .openBottle(let bottleStatus):
                if bottleStatus == .inProgress {
                    return "중도 개봉"
                }
                if bottleStatus == .complete {
                    return "개봉"
                }
                return .empty
            }
        }
    }
    
    /// 저금통 상태
    enum BottleStatus {
        /// 진행 중
        case inProgress
        
        /// 디데이 지남
        case complete
    }
}
