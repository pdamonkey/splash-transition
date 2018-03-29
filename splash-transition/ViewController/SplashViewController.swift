//
//  SplashViewController.swift
//  splash-transition
//
//  Created by Gallagher, Matthew on 27/03/2018.
//  Copyright © 2018 PDA Monkey. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    @IBOutlet var leftLogoImageView: UIImageView!
    @IBOutlet var rightLogoImageView: UIImageView!
    @IBOutlet var separatorHoriztonalConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Slight delay prior to performing transition
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.performSegue(withIdentifier: "splashToMainView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Use the transitioning delegate
        segue.destination.transitioningDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension SplashViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Use BasicSplitTransition for the simple transition or FinalSplitTransition for the more complex transition
        return FinalSplitTransition(with: 2)
    }
}
