//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Yao Li on 11/26/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        containerView.addSubview(toView)
        toView.alpha = 0.0
        UIView.animate(withDuration: duration,
                animations: {
                    toView.alpha = 1.0
                },
                completion: { _ in
                    transitionContext.completeTransition(true)
                }
        )
    }
}
