//
//  PopAnimator.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 18/12/2022.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    //MARK: - Properties
    let duration = 0.9
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (() -> Void)?
    
    
    //MARK: - Methods
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let productView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : productView.frame
        let finalFrame = presenting ? productView.frame : originFrame
        
        let xScaleFactor = presenting ?
        initialFrame.width / finalFrame.width :
        finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
        initialFrame.height / finalFrame.height :
        finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            productView.transform = scaleTransform
            productView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            productView.clipsToBounds = true
        }
        
        productView.layer.cornerRadius = presenting ? 20.0 : 0.0
        productView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(productView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            animations: {
                productView.transform = self.presenting ? .identity : scaleTransform
                productView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                productView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        if !self.presenting {
            self.dismissCompletion?()
        }
    }
}

