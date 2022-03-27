//
//  BottleViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

// TODO: 진행중인 유리병 있는지 없는지에 따라 초기 화면 구성 및 동작 수행 필요
/// 각 bottle 의 뷰를 관리하는 컨트롤러
final class BottleViewController: UIViewController {
    
    // MARK: - @IBOutlet

    /// 저금통 쪽지를 보여주는 애니메이션 뷰    
    @IBOutlet weak var bottleNoteView: BottleNoteView!
    
    // TODO: 나중에 불필요하면 삭제
    /// bottle Note View 의 bottom constraint
    @IBOutlet weak var bottleNoteViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    /// BottleViewController 에 필요한 형태로 데이터를 가공해주는 View Model
    var viewModel: BottleViewModel!
    
    /// 애니메이션을 위한 중력 객체
    var gravity: Gravity?
    
    /// 쪽지를 넣기 위해 bottle note view 의 영역을 나눠줄 그리드
    lazy var grid: Grid = {
        Grid(
            frame: self.bottleNoteView.bounds,
            cellCount: self.viewModel.bottle?.duration ?? .zero
        )
    }()
    
    /// 쪽지 노드
    var noteNodes: [UIDynamicItem] = []
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        configureBottleImage()
        initializeBottleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gravity?.enable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.gravity?.disable()
    }
    
    
    // MARK: - @IBActions
    
    /// 저금통 이미지를 탭할 시 실행되는 메서드
    /// 1. 저금통이 없는 경우 저금통 추가 팝업을 띄우고,
    /// 2. 저금통이 있으나 기한이 종료되어 개봉을 기다리는 경우 저금통을 개봉하고
    /// 3 - 1. 저금통이 있고 아직 진행중인 경우에는 쪽지를 쓸 수 있는 날이 있는 경우 쪽지 추가 팝업을,
    /// 3 - 2. 그 외에는 쪽지 작성 불가 알림을 띄운다.
    @IBAction func bottleDidTap(_ sender: UITapGestureRecognizer) {
        guard let bottle = self.viewModel.bottle
        else {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewBottleNameField,
                sender: sender
            )
            return
        }
        if !bottle.isInProgress {
            print("show some opening animation")
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
        }
        if bottle.isEmtpyToday {
            self.performSegue(
                withIdentifier: SegueIdentifier.presentNewNoteTextView,
                sender: sender
            )
        }
    }
    
    /// 현재 뷰 컨트롤러로 unwind 하라는 호출을 받았을 때 실행되는 액션메서드로, 중력 효과 재개
    @IBAction func unwindCallDidArrive(segue: UIStoryboardSegue) {
        self.gravity?.enable()
    }
    
    
    // MARK: - @objc
    
    /// 쪽지 진행 정도가 바뀌었다는 알림을 받았을 때 호출되는 메서드
    @objc private func noteProgressDidChange(_ notification: Notification) {
        
        guard let noteAndDelay = notification.object as? (note: Note, delay: TimeInterval),
              let index = self.viewModel.newlyAddedNoteIndex
        else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + noteAndDelay.delay) {
            let noteView = self.createNoteView(noteAndDelay.note, at: index)
            self.bottleNoteView.addSubview(noteView)
            self.gravity?.addDynamicItem(noteView)
        }
    }
    
    
    // MARK: - Functions
    
    /// NotificationCenter.default 에 observer 들을 추가
    private func addObservers() {
        self.observe(
            selector: #selector(noteProgressDidChange(_:)),
            name: .noteProgressDidUpdate
        )
    }
    
    /// 저금통 상태에 따른 저금통 이미지/애니메이션 등을 나타냄
    /// 저금통을 새로 추가하는 경우, 현재 진행중인 저금통이 있는 경우, 개봉을 기다리는 경우의 세 가지 상태가 있음
    private func configureBottleImage() {
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
    
    /// 저금통 유리병 애니메이션 초기 세팅
    private func initializeBottleView() {
        guard let bottle = self.viewModel.bottle
        else { return }
        
        self.fillBottleNoteView(forBottle: bottle)
        self.addGravity()
    }
    
    /// BottleNoteView 에 쪽지 이미지들을 추가
    private func fillBottleNoteView(forBottle bottle: Bottle) {
        
        for (index, note) in bottle.notes.enumerated() {
            let noteView = self.createNoteView(note, at: index)
            self.bottleNoteView.addSubview(noteView)
        }
    }
    
    /// 그리드를 사용해서 bottleNoteView 의 해당 좌표에 들어갈 NoteView 생성
    private func createNoteView(_ note: Note, at index: Int) -> NoteView {
        NoteView(frame: self.grid[index] ?? .zero, color: note.color)
    }
    
    /// 쪽지 이미지들에 중력 효과 추가
    /// 유저가 폰을 기울이는 방향으로 쪽지들이 떨어짐
    private func addGravity() {
        self.noteNodes = self.bottleNoteView.subviews.filter { $0 is NoteView }
                
        gravity = Gravity(
            gravityItems: self.noteNodes,
            collisionItems: nil,
            referenceView: self.view,
            collisionBoundaryInsets: Metric.collisionBoundaryInsets,
            queue: nil
        )
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// 다른 뷰를 띄우면 중력 효과 중단
        self.gravity?.disable()
        
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
    }
}
