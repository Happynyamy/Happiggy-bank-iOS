//
//  BottleViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

import Then

// TODO: 진행중인 유리병 있는지 없는지에 따라 초기 화면 구성 및 동작 수행 필요
/// 각 bottle 의 뷰를 관리하는 컨트롤러
final class BottleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 유리병 순서(현재 페이지) 인덱스
    var index: Int!

    /// BottleViewController 에 필요한 형태로 데이터를 가공해주는 View Model
    var viewModel: BottleViewModel!

    /// 유리병 이미지를 보여주는 뷰
    private var imageView: UIImageView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.configureImageView()
        self.configureImageViewConstraints()
    }
    
    
    // MARK: - @objc
    
    // FIXME: 단순히 개봉, 미개봉이 아니고 4가지 상태 고려 필요 BottleViewModel 의 isOpen 도 같이 수정 필요
    /// bottle 이미지를 탭할 시 실행되는 메서드
    /// bottle 이 개봉된 경우 note 리스트를 보여주고,
    /// 개봉되지 않았고, 아직 오늘의 note 를 안 쓴 경우 경우 새로운 쪽지를 추가함
    @objc private func bottleDidTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            
            // TODO: 데이터 바인딩 후 지우기
            // 테스트 용으로 첫번째 화면에서만 리스트, 나머지에서는 팝업을 보기 위한 코드
            self.viewModel.isOpen = (self.index == 0) ? true : false
            
            if self.viewModel.isOpen {
                let notesViewController = NotesViewController(title: viewModel.bottleName).then {
                    $0.viewModel = NotesViewModel()
                }
                self.show(notesViewController, sender: self)
                return
            }
            if self.viewModel.hasTodaysNote {
                print("already wrote a note today")
                return
            }
            if !self.viewModel.hasTodaysNote {
                self.showNewNotePopup()
                print("show add new note popup")
                return
            }
        }
    }
    
    /// 쪽지 진행 정도가 바뀌었다는 알림을 받았을 때 호출되는 메서드
    @objc private func noteProgressDidChange(_ notification: Notification) {
        self.view.backgroundColor = .systemIndigo
        print("update bottle image")
    }
    
    
    // MARK: - Functions
    
    /// NotificationCenter.default 에 observer 들을 추가
    private func addObservers() {
        self.observe(
            selector: #selector(noteProgressDidChange(_:)),
            name: .noteProgressDidUpdate
        )
    }
    
    /// bottle 이미지가 나타날 imageView 를 생성하고 추가하는 메서드
    /// 유저의 탭 제스처를 인식할 수 있도록 타겟-액션 추가
    private func configureImageView() {
        self.imageView = BottleImageView(image: viewModel.image)
        self.imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(bottleDidTap(_:))
        )
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(imageView)
    }
    
    /// imageView 에 오토 레이아웃 적용
    private func configureImageViewConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                constant: -Metric.verticalPadding * 2
            ),
            self.imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
