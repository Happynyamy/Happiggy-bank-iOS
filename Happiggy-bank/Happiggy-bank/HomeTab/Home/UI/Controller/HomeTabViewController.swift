//
//  HomeTabViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/12/23.
//

import Combine
import CoreData
import UIKit

import Then

// TODO: - 기존에 있는 HomeViewController 삭제

/// Home Tab 뷰 컨트롤러
final class HomeTabViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 홈 뷰
    var homeView: HomeView!
    
    /// 저금통이 진행중일 때 나타나는 더보기 버튼
    lazy var moreButton: UIButton = BaseButton().then {
        $0.setImage(AssetImage.more, for: .normal)
    }
    
    /// 유리병 뷰를 관리하는 컨트롤러
    private var bottleViewController: BottleViewController!
    
    /// 뷰모델
    var viewModel: HomeTabViewModel = HomeTabViewModel()
    
    /// Bottle에 대한 Subscriber 저장
    private var cancellableBag = Set<AnyCancellable>()
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.homeView = HomeView(
            title: self.viewModel.bottle?.title,
            dDay: self.viewModel.dDay(),
            hasNotes: self.viewModel.hasNotes
        )
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.controller.delegate = self
        configureHomeView()
        configureButton()
        configureButtonMenu()
        configureBottleViewController()
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
    
    
    // MARK: - Objc Functions
    // TODO: - 화면 연결
    
    /// 화면 탭했을 때 액션
    @objc private func viewDidTap(_ sender: UITapGestureRecognizer) {
        guard let bottle = self.viewModel.bottle
        else {
            self.navigationController?.pushViewControllerWithFade(
                to: NewBottleNameViewController()
            )
            return
        }
        
        if !bottle.isInProgress {
            return self.present(tapMoreButtonToOpenBottleAlert(), animated: true)
        }
        if !bottle.hasEmptyDate {
            return self.present(self.noEmptyDateAlert(), animated: true)
        }
        if bottle.isEmtpyToday {
            self.navigationController?.pushViewControllerWithFade(
                to: NewNoteInputViewController(
                    viewModel: .init(newNote: .init(date: Date(), bottle: bottle))
                )
            )
        } else {
            self.navigationController?.pushViewControllerWithFade(
                to: NewNoteDatePickerViewController(
                    viewModel: .init(newNote: .init(date: Date(), bottle: bottle)),
                    parent: .home)
            )
        }
    }
    
    
    // MARK: - Functions
    
    /// 새로 fetch한 Bottle이 있다면, 그 내용을 받아서 업데이트
    private func observePublishedValue() {
        guard let publishedBottle = self.viewModel.fetchAndPublish()
        else { return }
        
        publishedBottle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bottle in
                guard let viewModel = self?.viewModel
                else {
                    return
                }

                self?.viewModel.bottle = bottle
                self?.homeView = HomeView(
                    title: viewModel.bottle?.title,
                    dDay: viewModel.dDay(),
                    hasNotes: viewModel.hasNotes
                )
                self?.view = self?.homeView
                self?.configureHomeView()
                self?.configureButton()
            }
            .store(in: &cancellableBag)
    }
    
    /// BottleViewController 설정
    private func configureBottleViewController() {
        let bottleViewController = BottleViewController()
        let viewModel = BottleViewModel()
        
        viewModel.bottle = self.viewModel.bottle
        bottleViewController.viewModel = viewModel
        self.bottleViewController = bottleViewController
    }
    
    /// 모든 날짜에 쪽지를 작성했다는 알림
    private func noEmptyDateAlert() -> UIAlertController {
        UIAlertController.basic(
            alertTitle: StringLiteral.noEmptyDateAlertTitle,
            alertMessage: StringLiteral.noEmptyDateAlertMessage,
            confirmAction: UIAlertAction.confirmAction()
        )
    }
    
    // MARK: - Configurations
    
    /// UI 업데이트시 홈뷰 재설정
    private func configureHomeView() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.viewDidTap)
        )
        self.homeView.addGestureRecognizer(tap)
        self.homeView.title = self.viewModel.bottle?.title
        self.homeView.dDay = self.viewModel.dDay()
        self.homeView.hasNotes = self.viewModel.hasNotes
    }
    
    /// 더보기 버튼 초기화
    private func configureButton() {
        guard self.viewModel.hasBottle == true
        else { return }

        configureButtonMenu()
        self.view.addSubview(self.moreButton)
        
        self.moreButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.centerY.equalTo(self.homeView.dDayLabel.snp.centerY)
        }
    }
}


// MARK: - More Button
extension HomeTabViewController {
    
    // TODO: - 메뉴별 액션 설정!
    /// 더보기 버튼 설정
    private func configureButtonMenu() {
        guard let bottle = self.viewModel.bottle
        else { return }
        let attributes: UIMenuElement.Attributes = (Date() >= bottle.startDate) ? .destructive : .disabled
        
        let changeBottleName = UIAction(
            title: MoreButton.changeBottleName.title
        ) { [weak self] _ in
            self?.changeBottleNameItemDidTap()
        }
        let openBottle = UIAction(
            title: MoreButton.openBottle(bottle.isInProgress ? .inProgress : .complete).title,
            attributes: attributes
        ) { [weak self] _ in
            self?.openBottleItemDidTap(bottle)
        }
        
        self.moreButton.menu = UIMenu(children: [changeBottleName, openBottle])
        self.moreButton.showsMenuAsPrimaryAction = true
    }
    
    /// 메뉴 버튼에서 저금통 제목 변경을 선택했을 때 실행되는 함수
    private func changeBottleNameItemDidTap() {
        self.navigationController?.pushViewControllerWithFade(
            to: UIViewController().then { $0.view.backgroundColor = .blue }
        )
        self.bottleViewController.alertOrModalDidAppear()
    }
    
    /// 유저가 저금통을 개봉하려고 할 때 호출되는 함수
    private func openBottleItemDidTap(_ bottle: Bottle) {
        self.bottleViewController.alertOrModalDidAppear()
        self.present(self.bottleOpenConfirmationAlertController(for: bottle), animated: true)
    }
    
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
        self.navigationController?.pushViewControllerWithFade(
            to: UIViewController().then { $0.view.backgroundColor = .red }
        )
        
        // TODO: - bottle = nil일 때 UI update
//        removeAllRemindNotifications()
    }
    
    /// 더보기 버튼을 눌러 저금통을 개봉하라고 알려주는 알림
    private func tapMoreButtonToOpenBottleAlert() -> UIAlertController {
        return UIAlertController.basic(
            alertTitle: StringLiteral.tapMoreButtonToOpenBottleAlertTitle,
            confirmAction: .confirmAction()
        )
    }
}

extension HomeTabViewController: NSFetchedResultsControllerDelegate {
    
    /// fetchedResultsController에 수정사항이 생겼을 때 실행되는 함수
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.observePublishedValue()
    }
}

// MARK: - Presenter
extension HomeTabViewController: Presenter {
    
    func presentedViewControllerDidDismiss(withResult: CustomResult) {
        self.bottleViewController.restoreStateBeforeAlertOrModalDidAppear()
    }
}

extension HomeTabViewController {
    
    /// HomeViewController 에서 사용하는 상수값
    enum Metric {
        
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
        /// 작성 가능한 날짜가 없음을 알리는 알람의 제목
        static let noEmptyDateAlertTitle = "이미 모든 날짜에 행복을 기록했어요"
        
        /// 작성 가능한 날짜가 없음을 알리는 알람의 메시지
        static let noEmptyDateAlertMessage = "미래의 날짜는 작성 불가능합니다."
        
        /// 더보기 버튼을 눌러서 저금통 개봉이 가능함을 알리는 알림의 제목
        static let tapMoreButtonToOpenBottleAlertTitle =
        "오른쪽 위 더보기 버튼을 눌러 저금통을 개봉할 수 있어요!"
        
        /// 노티피케이션 식별자
        static let notificationIdentifier: String = "repeatingNotification"
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
