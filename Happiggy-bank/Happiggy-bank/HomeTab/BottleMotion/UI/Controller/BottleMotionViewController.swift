//
//  BottleMotionViewController.swift
//  Happiggy-bank
//
//  Created by 권은빈 on 2022/02/16.
//

import UIKit

// TODO: 진행중인 유리병 있는지 없는지에 따라 초기 화면 구성 및 동작 수행 필요
/// 각 bottle 의 뷰를 관리하는 컨트롤러
final class BottleMotionViewController: UIViewController {

    // MARK: - Properties

    private var bottle: Bottle?
    
    /// 애니메이션을 위한 중력 객체
    private var gravity: Gravity?
    
    /// 쪽지를 넣기 위해 bottle note view 의 영역을 나눠줄 그리드
    private lazy var grid: Grid = self.makeGrid()
    
    /// 쪽지 노드
    private var noteNodes: [NoteView] { self.view.subviews.compactMap { $0 as? NoteView } }
    
    /// 쪽지가 최초로 다른 쪽지 혹은 바운더리와 부딪힐 때 한번만 모션 효과를 주기 위한 프로퍼티
    private var activateHapticOnlyOnceForNewlyAddedNote = false
    
    /// 새로운 쪽지가 추가될 때 상단 중앙에서 떨어지는 효과를 위해 지정할 프레임
    private var topCenterFrame: CGRect {
        let origin = CGPoint(
            x: self.view.bounds.midX - self.grid.cellSize.width / 2,
            y: .zero
        )
        
        return CGRect(origin: origin, size: self.grid.cellSize)
    }


    // MARK: - Inits

    // FIXME: - get rid of default value
    init(bottle: Bottle?) {
        self.bottle = bottle
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    // MARK: - View Lifecycle

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()

        self.configureBottleMotionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.gravity?.enable()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.gravity?.disable()
    }

    
    // MARK: - Functions
    
    /// 새로운 저금통이 추가되었을 때 호출되는 메서드
    func bottleDidAdd(_ bottle: Bottle) {
        self.bottle = bottle
        self.configureBottleMotionView()
    }

    // FIXME: 홈탭 뷰컨 리팩토링 후 연결 메서드 전체적으로 고치기...쪽지 연동도 아직 미완
    func noteDidAdd(_ note: Note, delay: TimeInterval) {
        self.dropNewNoteFromTopCenter(note, delay: delay)
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
        self.bottle = nil
        UIView.transition(
            with: self.view,
            duration: duration,
            options: [.curveEaseIn, .transitionCrossDissolve]
        ) {
            self.noteNodes.forEach { $0.removeFromSuperview() }
        }
    }


    // MARK: - Configuration Functions

    /// 저금통이 있는 경우 기간에 맞게 그리드를 생성해 쪽지 뷰를 추가하고 중력 효과 생성
    private func configureBottleMotionView() {
        guard let bottle
        else {
            return
        }

        self.noteNodes.forEach { $0.removeFromSuperview() }
        self.grid = self.makeGrid()
        self.fillBottleNoteView(fromNotes: bottle.notes)
        self.gravity = self.makeGravity().then { $0.enable() }
    }
    
    /// 저금통 기간에 따른 그리드 생성
    private func makeGrid() -> Grid {
        guard let bottle
        else {
            return Grid(frame: .zero, cellCount: .zero)
        }

        let addtionalTopInset = bottle.duration < Metric.durationCap ? Metric.additionalTopInset : .zero
        let gridFrame = self.view.bounds.inset(
            by: .init(
                top: Metric.topInset + addtionalTopInset,
                left: Metric.horizontalInset,
                bottom: Metric.bottomInset,
                right: Metric.horizontalInset
            )
        )

        return Grid(frame: gridFrame, cellCount: bottle.duration)
    }

    /// BottleNoteView 에 쪽지 이미지들을 추가
    private func fillBottleNoteView(fromNotes notes: [Note]) {
        for (index, note) in notes.enumerated() {
            let frame = self.grid[index] ?? .zero
            let noteView = self.createNoteView(note, frame: frame)
            self.view.addSubview(noteView)
        }
    }
    
    /// 그리드를 사용해서 bottleNoteView 의 해당 좌표에 들어갈 NoteView 생성
    private func createNoteView(_ note: Note, frame: CGRect) -> NoteView {
        NoteView(frame: frame, image: AssetImage.note(ofColor: note.color) ?? UIImage())
    }
    
    /// 쪽지 이미지들에 중력 효과 추가
    /// 유저가 폰을 기울이는 방향으로 쪽지들이 떨어짐
    private func makeGravity() -> Gravity {
        Gravity(
            dynamicItems: self.noteNodes,
            referenceView: self.view,
            collisionBoundaryInsets: Metric.collisionBoundaryInsets,
            queue: nil
        ).then {
            $0.collision.collisionDelegate = self
        }
    }
    
    /// 새로운 쪽지를 추가하고 화면 상단 중앙에서 떨어트림
    private func dropNewNoteFromTopCenter(_ note: Note, delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let noteView = self.createNoteView(note, frame: self.topCenterFrame)
            self.view.addSubview(noteView)
            self.gravity?.addDynamicItem(noteView)
            self.activateHapticOnlyOnceForNewlyAddedNote.toggle()
        }
    }
}


// MARK: - UICollisionBehaviorDelegate
extension BottleMotionViewController: UICollisionBehaviorDelegate {
    
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


// MARK: - Constants
fileprivate extension BottleMotionViewController {

    /// BottleMotionViewController 에서 설정하는 layout 에 적용할 상수값들을 모아놓은 enum
    enum Metric {

        /// 현재 뷰를 기준으로 충돌 영역 설정을 위해 넣을 상하좌우 마진
        static let collisionBoundaryInsets = UIEdgeInsets(top: .zero, left: 3, bottom: 3, right: 3)

        /// 쪽지들이 바운더리와 부딪칠 때 햅틱 반응의 강도: 0.4
        static let impactHapticIntensity: CGFloat = 0.4

        /// 그리드 인셋
        static let topInset: CGFloat = 30
        static let bottomInset: CGFloat = 0
        static let horizontalInset: CGFloat = 7

        /// 1년 짜리 제외 다 영역 축소
        static let durationCap = 300

        /// 일주일, 한 달인 경우 높이를 축소하기 위해 감산해줄 값: 40
        static let additionalTopInset: CGFloat = 40
    }
}
