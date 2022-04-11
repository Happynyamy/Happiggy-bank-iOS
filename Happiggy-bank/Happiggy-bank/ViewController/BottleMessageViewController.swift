//
//  BottleMessageViewController.swift
//  Happiggy-bank
//
//  Created by sun on 2022/04/02.
//

import UIKit

/// 저금통 개봉 시 미리 작성했던 메시지를 확인하는 뷰를 관리하는 컨트롤러
final class BottleMessageViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    /// 배경 이미지 뷰
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    /// 저금통 제목 라벨
    @IBOutlet weak var bottleTitleLabel: UILabel!
    
    /// 빈 저금통 라벨
    @IBOutlet weak var emptyBottleLabel: UILabel!
    
    /// 저금통 메세지 라벨
    @IBOutlet weak var bottleMessageLabel: UILabel!
    
    /// 화면을 누르면 리스트로 넘어갈 수 있음을 안내하는 라벨
    @IBOutlet weak var tapToContinueLabel: UILabel!
    
    /// 스택뷰에 적용된 탭 제스처
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!

    
    // MARK: - Properties
    
    /// 개봉중인 저금통
    var bottle: Bottle!
    
    /// 뷰컨트롤러 등장/퇴장 시간
    var fadeInOutduration: TimeInterval!
    
    /// 앱의 탭바 컨트롤러
    weak var mainTabBarController: UITabBarController?
    
    /// 자연스러운 페이드인 효과를 위한 이전 뷰 스냅샷
    var fakeBackground: UIView?
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLabels()
        
        guard let fakeBackground = fakeBackground
        else { return }

        self.view.insertSubview(fakeBackground, at: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fadeInContents()
    }
    
    
    // MARK: - @IBActions
    
    /// 유저가 화면을 탭하면 호출되는 액션 메서드
    @IBAction func viewDidTap(_ sender: UITapGestureRecognizer) {
        
        self.tapGestureRecognizer.isEnabled.toggle()
        HapticManager.instance.selection()
        self.saveBottleUpdatesAndDismiss()
    }
    
    
    // MARK: - Functions
    
    /// 제목 라벨, 메세지 라벨의 내용을 저금통 데이터로 업데이트
    private func configureLabels() {
        self.bottleTitleLabel.text = self.bottle.title
        self.bottleMessageLabel.text = self.bottle.message
        
        guard self.bottle.notes.isEmpty
        else { return }
        
        self.emptyBottleLabel.isHidden.toggle()
        self.tapToContinueLabel.text = StringLiteral.emptyBottleTapToContinueLabelText
    }
    
    /// 하위 뷰들을 페이드인
    private func fadeInContents() {
        
        UIView.animate(withDuration: self.fadeInOutduration, delay: .zero, options: .curveEaseIn) {
            self.backgroundImageView.alpha = .one
            self.bottleTitleLabel.alpha = .one
            self.emptyBottleLabel.alpha = .one
            self.bottleMessageLabel.alpha = .one
        } completion: { _ in
            self.animateTapToContinueLabel()
            self.fakeBackground?.removeFromSuperview()
        }
    }
    
    /// 탭 안내 라벨 페이드인/아웃 반복
    private func animateTapToContinueLabel() {
        UIView.animateKeyframes(
            withDuration: Duration.tapToContinueLabel,
            delay: Duration.tapToContinueLabelDelay,
            options: [.autoreverse, .repeat, .allowUserInteraction]
        ) {
                /// 탭 안내 라벨이 나타날 때 탭 인식 허용
                self.tapGestureRecognizer.isEnabled.toggle()
                
                UIView.addKeyframe(
                    withRelativeStartTime: .zero,
                    relativeDuration: Duration.tapToContinueLabelRelativeFadeIn
                ) {
                    self.tapToContinueLabel.alpha = .one
                }
            }
    }
    
    /// 쪽지 리스트를 띄우기 전에 자연스러운 전환을 위해 애니메이션 효과를 줌
    private func moveToNoteListWithAnimation() {
        UIView.animate(
            withDuration: self.fadeInOutduration,
            delay: .zero,
            options: [.curveEaseIn, .beginFromCurrentState]
        ) {
            self.view.backgroundColor = .reversedLabel
            self.clearContents()
        } completion: { _ in
            self.moveToNoteList()
        }
    }
    
    /// 쪽지리스트로 이동
    private func moveToNoteList() {
        
        /// 메인 탭바의 선택 인덱스를 저금통 리스트 인덱스로 변경
        self.mainTabBarController?.selectedIndex = TabItem.bottleList.rawValue

        let storyboard = UIStoryboard(name: mainStoryboardName, bundle: Bundle.main)

        /// 저금통 리스트를 건너뛰고 쪽지리스트가 바로 보이는 것처럼 보이도록 스토리보드를 사용해서 뷰 컨트롤러를 생성하여 뷰 체계 설정
        guard let navigationController = self.mainTabBarController?.selectedViewController as?
                UINavigationController,
              let noteListViewController = storyboard.instantiateViewController(
                withIdentifier: NoteListViewController.name
              ) as? NoteListViewController
        else { return }
        
        let bottleListViewController = storyboard.instantiateViewController(
            withIdentifier: BottleListViewController.name
        )
        let noteListViewModel = NoteListViewModel(
            bottle: self.bottle,
            fadeIn: true,
            fetchedResultContollerDelegate: noteListViewController
        )
        noteListViewController.viewModel = noteListViewModel
        
        navigationController.setViewControllers(
            [bottleListViewController, noteListViewController],
            animated: false
        )
        navigationController.navigationBar.backItem?.backButtonTitle = .empty
        
        self.dismiss(animated: false, completion: nil)
    }
    
    /// 배경 이미지와 라벨들을 모두 투명도 0으로 변경
    private func clearContents() {
        self.view.subviews.forEach { $0.alpha = .zero }
    }
    
    /// 저금통 상태를 업데이트하고 다른 뷰 컨트롤러로 이동
    private func saveBottleUpdatesAndDismiss() {
        self.bottle.isOpen.toggle()

        if !self.bottle.notes.isEmpty {
            self.moveToNoteListWithAnimation()
        }

        if self.bottle.notes.isEmpty {
            PersistenceStore.shared.delete(self.bottle)
            self.dismiss(animated: false)
            self.fadeOut()
        }
        
        PersistenceStore.shared.save()
    }
}
