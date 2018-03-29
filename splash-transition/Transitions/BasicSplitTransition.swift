//
//  BasicSplitTransition.swift
//  splash-transition
//
//  Created by Gallagher, Matthew on 27/03/2018.
//  Copyright © 2018 PDA Monkey. All rights reserved.
//

import UIKit

class BasicSplitTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var duration: TimeInterval
    
    init(with duration: TimeInterval) {
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Retrieve the container view
        let containerView = transitionContext.containerView
        
        // Make sure we are dealing with a SplashViewController
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? SplashViewController else { return }
        
        // Retrieve the items to animate from the SplashViewController
        guard
            let fromView = fromViewController.view,
            let leftViewSnapshot = fromView.snapshotView(afterScreenUpdates: false),
            let rightViewSnapshot = fromView.snapshotView(afterScreenUpdates: false)
        else { return }
        
        // Hide the Splash view (we'll be using the snapshots instead)
        fromView.alpha = 0
        
        // Create left mask view and assign to snapshot
        let leftMaskView = UIView(frame: fromViewController.leftView.frame)
        leftMaskView.backgroundColor = .black
        leftViewSnapshot.mask = leftMaskView
        containerView.addSubview(leftViewSnapshot)
        
        // Create right mask view and assign to snapshot
        let rightMaskView = UIView(frame: fromViewController.rightView.frame)
        rightMaskView.backgroundColor = .black
        rightViewSnapshot.mask = rightMaskView
        containerView.addSubview(rightViewSnapshot)
        
        // Retrieve the to view
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        // Add the to view to the container view underneath our snapshots
        containerView.insertSubview(toView, at: 0)
        
        // Perform the animation to split the splash screen to reveal main screen
        UIView.animate(withDuration: duration, animations: {
            // Move the left snapshot offscreen to the left
            leftViewSnapshot.center.x -= fromViewController.leftView.bounds.width
            
            // Move the right snapshot offscreen to the right
            rightViewSnapshot.center.x += fromViewController.rightView.bounds.width
        }) { (finished) in
            // Complete the transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
