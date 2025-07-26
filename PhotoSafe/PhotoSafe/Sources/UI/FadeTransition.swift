//
//  FadeTransition.swift
//  PhotoSafe
//
//  Created by Sarah Clark on 7/26/25.
//

import UIKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = transitionDuration(using: transitionContext)
        toView.layer.add(animation, forKey: nil)

        toView.alpha = 1
        transitionContext.completeTransition(true)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

}
