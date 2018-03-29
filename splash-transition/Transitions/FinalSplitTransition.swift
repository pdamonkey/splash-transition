//
//  FinalSplitTransition.swift
//  splash-transition
//
//  Created by Gallagher, Matthew on 28/03/2018.
//  Copyright © 2018 PDA Monkey. All rights reserved.
//

import UIKit

class FinalSplitTransition: NSObject, UIViewControllerAnimatedTransitioning {
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
            let leftView = fromViewController.leftView,
            let rightView = fromViewController.rightView,
            let launchLeftLogoImageView = fromViewController.leftLogoImageView,
            let launchRightLogoImageView = fromViewController.rightLogoImageView,
            let separatorHorizontalConstraint = fromViewController.separatorHoriztonalConstraint
        else { return }
        
        // Retrieve the to view
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        // Add the to view to the container view
        containerView.insertSubview(toView, at: 0)
        
        // Add left logo image to left view
        let leftLogoImageView = UIImageView(image: launchLeftLogoImageView.image)
        leftLogoImageView.contentMode = launchLeftLogoImageView.contentMode
        leftLogoImageView.frame = fromViewController.view.convert(launchLeftLogoImageView.frame, from: launchLeftLogoImageView.superview)
        leftView.addSubview(leftLogoImageView)
        
        // Hide the original left icon
        launchLeftLogoImageView.isHidden = true
        
        // Add right logo image to right view
        let rightLogoImageView = UIImageView(image: launchRightLogoImageView.image)
        rightLogoImageView.contentMode = launchRightLogoImageView.contentMode
        rightLogoImageView.frame = fromViewController.view.convert(launchRightLogoImageView.frame, from: launchRightLogoImageView.superview)
        let logoGapFromDivider: CGFloat = 8
        rightLogoImageView.frame.origin.x = logoGapFromDivider
        rightView.addSubview(rightLogoImageView)
        
        // Hide the original right icon
        launchRightLogoImageView.isHidden = true
        
        // Add the to view to the container view underneath our snapshots
        containerView.insertSubview(toView, at: 0)
        
        // Calculate the amount to move to centre the separator
        let centreHorizontalMovementAmount = fromView.frame.midX - leftView.frame.width
        
        // Adjust the separator using the amount above
        separatorHorizontalConstraint.constant = -centreHorizontalMovementAmount
        
        // Animation timing constants
        let animationStartBufferInterval: TimeInterval = 0.2  // 0.2 second buffer to allow animations to start correclty
        let animationEndBufferInterval: TimeInterval = 0.1  // 0.1 second buffer to allow animations to fit in to the allotted time
        let animationDuration: TimeInterval = duration - animationStartBufferInterval - animationEndBufferInterval
        let animationHideLogoInterval: TimeInterval = animationDuration * 0.5
        let animationSplitInterval: TimeInterval = animationDuration * 0.43
        let animationSplitDelayInterval: TimeInterval = duration - animationEndBufferInterval - animationSplitInterval
        
        // First animation: center the seperator and hide the logo images
        UIView.animate(withDuration: animationHideLogoInterval, delay: animationStartBufferInterval, options: [], animations: {
            // Animate the seperator move (using auto layout)
            fromView.layoutIfNeeded()
            
            // Hide the logo images
            leftLogoImageView.frame.origin = CGPoint(x: leftLogoImageView.frame.minX + leftLogoImageView.frame.width + centreHorizontalMovementAmount + logoGapFromDivider, y: leftLogoImageView.frame.minY)
            rightLogoImageView.frame.origin = CGPoint(x: rightLogoImageView.frame.minX - rightLogoImageView.frame.width + centreHorizontalMovementAmount - logoGapFromDivider, y: rightLogoImageView.frame.minY)
        }) { (finished) in
            let rightMaskLayer = CALayer()
            rightMaskLayer.backgroundColor = UIColor.black.cgColor
            rightMaskLayer.frame = CGRect(x: centreHorizontalMovementAmount, y: 0, width: rightView.frame.width, height: rightView.frame.height)
            rightView.layer.mask = rightMaskLayer
        }
        
        // Calculate the amount required to slide the views to the sides
        let sidesHorizontalHideAmount = (fromView.bounds.width / 2)
        
        // Second animation: split the views and transition them to the sides
        UIView.animate(withDuration: animationSplitInterval, delay: animationSplitDelayInterval, options: [], animations: {
            // Animte the views of the screen
            leftView.frame.origin = CGPoint(x: leftView.frame.minX - sidesHorizontalHideAmount, y: leftView.frame.minY)
            rightView.frame.origin = CGPoint(x: rightView.frame.minX + sidesHorizontalHideAmount, y: rightView.frame.minY)
        }, completion: { (finished) in
            // Unhide the logo images
            launchLeftLogoImageView.isHidden = false
            launchRightLogoImageView.isHidden = false
            
            // Remove temporary views
            leftLogoImageView.removeFromSuperview()
            rightLogoImageView.removeFromSuperview()
            
            // Remove the right layer mask
            rightView.layer.mask = nil
            
            // Reset the seporator constraint
            separatorHorizontalConstraint.constant = 0
            
            // Complete the transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
