//
//  Gravity.swift
//  Created by Pasca Alberto
//

import CoreMotion
import UIKit

public class Gravity: NSObject {

    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var motion: CMMotionManager = CMMotionManager()
    private var queue: OperationQueue!

    private var dynamicItems: [UIDynamicItem]
    private var collisionItems: [UIDynamicItem]
    
    /// reference view 를 기준으로 설정할 충돌 영역의 상하좌우 마진
    private var collisionBoundaryInsets: UIEdgeInsets
    
    /// Initialize the components
    public init(
        gravityItems: [UIDynamicItem],
        collisionItems: [UIDynamicItem]?,
        referenceView: UIView,
        collisionBoundaryInsets: UIEdgeInsets,
        queue: OperationQueue?
    ) {
        
        self.dynamicItems = gravityItems

        if let collisionItems = collisionItems {
            self.collisionItems = collisionItems
        } else {
            self.collisionItems = self.dynamicItems
        }
        
        if let queue = queue {
            self.queue = queue
        } else {
            self.queue = OperationQueue.current ?? OperationQueue.main
        }
        
        animator = UIDynamicAnimator(referenceView: referenceView)
        gravity = UIGravityBehavior(items: self.dynamicItems)
        self.collision =  UICollisionBehavior(items: self.collisionItems)
        self.collision.setTranslatesReferenceBoundsIntoBoundary(with: collisionBoundaryInsets)
        self.collisionBoundaryInsets = collisionBoundaryInsets
    }
    
    /// Enable motion and behaviors
    public func enable() {
        animator.addBehavior(self.collision)
        animator.addBehavior(gravity)
        motion.startDeviceMotionUpdates(
            to: queue,
            withHandler: motionHandler
        )
    }

    /// Disable motion and behaviors
    public func disable() {
        animator.removeAllBehaviors()
        motion.stopDeviceMotionUpdates()
    }
    
    /// Restart motion and behaviors
    public func restart() {
        disable()
        enable()
    }
    
    /// 새로운 다이나믹 아이템 추가
    func addDynamicItem(_ item: UIDynamicItem) {
        self.gravity.addItem(item)
        self.collision.addItem(item)
    }

    private func motionHandler( motion: CMDeviceMotion?, error: Error? ) {
        guard let motion = motion else { return }

        let grav: CMAcceleration = motion.gravity
        let posX = CGFloat(grav.x)
        let posY = CGFloat(grav.y)
        var position = CGPoint(x: posX, y: posY)

        if let orientation = UIApplication.shared.windows.first(
            where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            if orientation == .landscapeLeft {
                let tempPosX = position.x
                position.x = 0 - position.y
                position.y = tempPosX
            } else if orientation == .landscapeRight {
                let tempPosX = position.x
                position.x = position.y
                position.y = 0 - tempPosX
            } else if orientation == .portraitUpsideDown {
                position.x *= -1
                position.y *= -1
            }
        }

        let vector = CGVector(dx: position.x, dy: 0 - position.y)
        self.gravity.gravityDirection = vector
    }

}
