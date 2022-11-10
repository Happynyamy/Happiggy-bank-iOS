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
    
    
    // MARK: - Properties
    
    /// BottleViewController 에 필요한 형태로 데이터를 가공해주는 View Model
    var viewModel: BottleViewModel!
    
    /// 애니메이션을 위한 중력 객체
    var gravity: Gravity?
    
    /// 쪽지를 넣기 위해 bottle note view 의 영역을 나눠줄 그리드
    private lazy var grid: Grid = self.makeGrid()
    
    /// 쪽지 노드
    private var noteNodes: [NoteView] {
        self.bottleNoteView.subviews.compactMap { $0 as? NoteView }
    }
    
    /// 쪽지가 최초로 다른 쪽지 혹은 바운더리와 부딪힐 때 한번만 모션 효과를 주기 위한 프로퍼티
    private var activateHapticOnlyOnceForNewlyAddedNote = false
    
    /// 새로운 쪽지가 추가될 때 상단 중앙에서 떨어지는 효과를 위해 지정할 프레임
    private var topCenterFrame: CGRect {
        let origin = CGPoint(
            x: self.bottleNoteView.bounds.midX - self.grid.cellSize.width / 2,
            y: .zero
        )
        
        return CGRect(origin: origin, size: self.grid.cellSize)
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gravity?.enable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.gravity?.disable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard self.gravity == nil,
              self.bottleNoteView != nil
        else { return }
        self.initializeBottleView()
    }
    
    
    // MARK: - @objc
    
    /// 쪽지 새로 추가되었다는 알림을 받았을 때 호출되는 메서드
    @objc private func noteDidAdd(_ notification: Notification) {
        
        guard let noteAndDelay = notification.object as? (note: Note, delay: TimeInterval)
        else { return }

        self.dropNewNoteFromTopCenter(noteAndDelay.note, delay: noteAndDelay.delay)
    }
    
    
    // MARK: - Functions
    
    /// 새로운 저금통이 추가되었을 때 호출되는 메서드
    func bottleDidAdd(_ bottle: Bottle) {
        self.viewModel.bottle = bottle
        self.initializeBottleView()
    }
    
    /// 현재 뷰 컨트롤러로 unwind 하라는 호출을 받았을 때 실행되는 액션메서드로, 중력 효과 재개
    func unwindCallDidArrive() {
        self.gravity?.startDeviceMotionUpdates()
    }

    /// 홈뷰에서 다른 뷰를 띄울 때 보틀뷰에 이를 알리기 위해 호출하는 메서드
    func prepareForSegue() {
        /// 새 쪽지가 떨어질 영역을 확보하기 위해 해당 탭 내에서 다른 뷰를 띄우면 중력 방향을 하단으로 변경해 기존 쪽지를 전부 하단으로 이동
        self.gravity?.resetAndBindGravityDirection()
    }

    /// 현재 뷰 컨트롤러로 unwind 하라는 호출을 받았을 때 실행되는 액션메서드로, 중력 효과 재개
    func unwindCallDidArrive() {
        self.gravity?.startDeviceMotionUpdates()
    }

    /// 알림/모달이 떴을 때 호출되는 메서드
    func alertOrModalDidAppear() {
        self.gravity?.disable()
    }
    
    /// 알림/모달이 내려가고, 이전 상태 그대로 나타내면 될 때 호출되는 메서드
    func restoreStateBeforeAlertOrModalDidAppear() {
        self.gravity?.enable()
    }

    /// 저금통 개봉 시 호출되는 메서드
    /// 중력 해제, 저금통 nil 처리, 쪽지 노드 제거
    func bottleDidOpen(withDuration duration: TimeInterval) {
        self.gravity = nil
        self.viewModel.bottle = nil
        UIView.transition(
            with: self.view,
            duration: duration,
            options: [.curveEaseIn, .transitionCrossDissolve]
        ) {
            self.noteNodes.forEach { $0.removeFromSuperview() }
        }
    }
    
    /// 저금통 유리병 애니메이션 초기 세팅: 쪽지 작성이 가능한 상태로 변경
    private func initializeBottleView() {
        guard let bottle = self.viewModel.bottle
        else { return }
        
        self.grid = self.makeGrid()
        self.fillBottleNoteView(fromNotes: bottle.notes)
        self.addGravity()
        self.gravity?.enable()
    }
    
    /// 저금통 기간에 따른 그리드 생성
    private func makeGrid() -> Grid {
        guard let bottle = self.viewModel.bottle
        else { return Grid(frame: .zero, cellCount: .zero) }
        
        self.bottleNoteView.frame = self.viewModel.gridFrame(forView: self.view)
        return Grid(frame: self.bottleNoteView.bounds, cellCount: bottle.duration)
    }
    
    /// NotificationCenter.default 에 observer 들을 추가
    private func addObservers() {
        self.observe(
            selector: #selector(noteDidAdd(_:)),
            name: .noteDidAdd
        )
    }
    
    /// BottleNoteView 에 쪽지 이미지들을 추가
    private func fillBottleNoteView(fromNotes notes: [Note]) {
        
        for (index, note) in notes.enumerated() {
            let frame = self.grid[index] ?? .zero
            let noteView = self.createNoteView(note, frame: frame)
            self.bottleNoteView.addSubview(noteView)
        }
    }
    
    /// 그리드를 사용해서 bottleNoteView 의 해당 좌표에 들어갈 NoteView 생성
    private func createNoteView(_ note: Note, frame: CGRect) -> NoteView {
        NoteView(frame: frame, image: .note(color: note.color))
    }
    
    /// 쪽지 이미지들에 중력 효과 추가
    /// 유저가 폰을 기울이는 방향으로 쪽지들이 떨어짐
    private func addGravity() {
        gravity = Gravity(
            dynamicItems: self.noteNodes,
            referenceView: self.view,
            collisionBoundaryInsets: Metric.collisionBoundaryInsets,
            queue: nil
        )
        
        self.gravity?.collision.collisionDelegate = self
    }
    
    /// 새로운 쪽지를 추가하고 화면 상단 중앙에서 떨어트림
    private func dropNewNoteFromTopCenter(_ note: Note, delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let noteView = self.createNoteView(note, frame: self.topCenterFrame)
            self.bottleNoteView.addSubview(noteView)
            self.gravity?.addDynamicItem(noteView)
            self.activateHapticOnlyOnceForNewlyAddedNote.toggle()
        }
    }
}


// MARK: - UICollisionBehaviorDelegate
extension BottleViewController: UICollisionBehaviorDelegate {
    
    // MARK: - Functions
    
    func collisionBehavior(
        _ behavior: UICollisionBehavior,
        endedContactFor item1: UIDynamicItem,
        with item2: UIDynamicItem
    ) {
        guard self.activateHapticOnlyOnceForNewlyAddedNote
        else { return }
        
        self.activateHapticForNewlyAddedNoteAndResumeMotionUpdates()
    }
    
    func collisionBehavior(
        _ behavior: UICollisionBehavior,
        beganContactFor item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying?,
        at point: CGPoint
    ) {
        guard self.activateHapticOnlyOnceForNewlyAddedNote
        else {
            HapticManager.instance.impact(style: .light, intensity: Metric.impactHapticIntensity)
            return
        }
        
        self.activateHapticForNewlyAddedNoteAndResumeMotionUpdates()
    }
    
    /// 새로운 쪽지가 추가되었을떄 최초로 다른 아이템 혹은 바운더리와 부딪히는 경우에만 햅틱 반응
    private func activateHapticForNewlyAddedNoteAndResumeMotionUpdates() {
        
        self.activateHapticOnlyOnceForNewlyAddedNote.toggle()
        HapticManager.instance.notification(type: .success)
        /// 쪽지가 하단 바운더리 혹은 다른 쪽지와 부딪히면 디바이스 모션 업데이트 재개
        self.gravity?.startDeviceMotionUpdates()
    }
}
