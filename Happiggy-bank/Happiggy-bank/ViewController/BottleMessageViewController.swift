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
    
    /// 저금통 메세지 라벨
    @IBOutlet weak var bottleMessageLabel: UILabel!
    
    /// 화면을 누르면 리스트로 넘어갈 수 있음을 안내하는 라벨
    @IBOutlet weak var tapToContinueLabel: UILabel!
    
    /// 스택뷰에 적용된 탭 제스처
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!

    
    // MARK: - Properties
    
    /// 개봉중인 저금통
    var bottle: Bottle!
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fadeInContents()
    }
    
    
    // MARK: - @IBActions
    
    /// 유저가 화면을 탭하면 호출되는 액션 메서드
    @IBAction func viewDidTap(_ sender: UITapGestureRecognizer) {
        
        self.unwindToBottleListWithAnimation()
    }
    
    
    // MARK: - Functions
    
    /// 제목 라벨, 메세지 라벨의 내용을 저금통 데이터로 업데이트
    private func configureLabels() {
        self.bottleTitleLabel.text = self.bottle.title
        self.bottleMessageLabel.text = self.bottle.message
    }
    
    /// 하위 뷰들을 페이드인
    private func fadeInContents() {
        self.view.fadeIn(withDuration: Duration.contentsFadeInOut, options: .curveEaseIn) { _ in
            self.animateTapToContinueLabel()
            /// 탭 안내 라벨이 나타날 때 탭 인식 허용
            self.tapGestureRecognizer.isEnabled = true
        }
    }
    
    /// 탭 안내 라벨 페이드인/아웃 반복
    private func animateTapToContinueLabel() {
        UIView.animate(
            withDuration: Duration.tapToContinueLabel,
            delay: Duration.tapToContinueLabelDelay,
            options: [.autoreverse, .repeat, .allowUserInteraction, .curveEaseIn]
        ) {
            self.tapToContinueLabel.alpha = .one
        }
    }
    
    /// 저금통 리스트를 띄우기 전에 자연스러운 전환을 위해 애니메이션 효과를 줌
    private func unwindToBottleListWithAnimation() {
        UIView.animate(
            withDuration: Duration.contentsFadeInOut,
            delay: .zero,
            options: [.curveEaseIn, .beginFromCurrentState]
        ) {
            self.view.backgroundColor = .white
            self.clearContents()
        } completion: { _ in
            self.performSegue(
                withIdentifier: SegueIdentifier.unwindFromBottleMessageViewToBottleList,
                sender: self.bottle
            )
        }
    }
    
    /// 배경 이미지와 라벨들을 모두 투명도 0으로 변경
    private func clearContents() {
        self.backgroundImageView.alpha = .zero
        self.bottleTitleLabel.alpha = .zero
        self.bottleMessageLabel.alpha = .zero
        self.tapToContinueLabel.alpha = .zero
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier.unwindFromBottleMessageViewToBottleList {
            guard let bottleListViewController = segue.destination as? BottleListViewController
            else { return }
            
            bottleListViewController.viewModel.openingBottle = self.bottle
        }
    }
}
