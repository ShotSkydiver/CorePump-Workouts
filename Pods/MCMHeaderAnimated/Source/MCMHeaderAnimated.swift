//
//  MCMHeaderAnimated.swift
//  MCMHeaderAnimated
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit

@objc public protocol MCMHeaderAnimatedDelegate {
    
    func headerView() -> UIView
    
    func headerCopy(_ subview: UIView) -> UIView
    
}

public class MCMHeaderAnimated: UIPercentDrivenInteractiveTransition {
    
    public var transitionMode: TransitionMode = .present
    public var transitionInteracted: Bool = false
    
    private var headerFromFrame: CGRect! = nil
    private var headerToFrame: CGRect! = nil
    
    private var enterPanGesture: UIPanGestureRecognizer!
    public var destinationViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIPanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action: #selector(self.handleOnstagePan(_:)))
            self.destinationViewController.view.addGestureRecognizer(self.enterPanGesture)
            self.transitionInteracted = true
        }
    }
    
    public enum TransitionMode: Int {
        case present, dismiss
    }
    
    func handleOnstagePan(_ pan: UIPanGestureRecognizer){
        
        let translation = pan.translation(in: pan.view!)
        let d =  translation.y / pan.view!.bounds.height * 1.5
        
        switch (pan.state) {
            case UIGestureRecognizerState.began:
            
                self.destinationViewController.dismiss(animated: true, completion: nil)
            break
            case .changed:
                
                self.update(d)
            break
            
            default: // .Ended, .Cancelled, .Failed ...
                
                self.finish()
        }
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension MCMHeaderAnimated: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.65
    }
    
    public func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
        let toView = transitionContext.view(forKey: UITransitionContextToViewKey)!
        
        let fromController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)!
        /*let fromController: UIViewController?
        do {
            fromController = try transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        } catch _ {
            print("error")
            let fromControllerParent: UITabBarController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)! as! UITabBarController
            let fromControllerView: UIViewController = fromControllerParent.selectedViewController!
            fromController = fromControllerView.childViewControllers[0]
        }*/
        let toController = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        /*let toController: UIViewController?
        do {
            toController = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        } catch _ {
            print("error")
            let toControllerParent: UITabBarController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)! as! UITabBarController
            let toControllerView: UIViewController = toControllerParent.selectedViewController!
            toController = toControllerView.childViewControllers[0]
        }*/
        
        //let vc: UINavigationController = segue.destinationViewController as! UINavigationController
        //let detailVC = vc.topViewController as! PatternDetailViewController
        

        let duration = self.transitionDuration(transitionContext)
        
        fromView.setNeedsLayout()
        fromView.layoutIfNeeded()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        let alpha: CGFloat = 0.1
        let offScreenBottom = CGAffineTransform(translationX: 0, y: container.frame.height)

        let headerTo: UIView!
        if self.transitionMode == .present {
            print("opening cell")
            
            headerTo = (toController as! MCMHeaderAnimatedDelegate).headerView()
        }
        else if self.transitionMode == .dismiss {
            print("closing cell")
            
            let toControllerParent: UITabBarController = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)! as! UITabBarController
            let toControllerView: UIViewController = toControllerParent.selectedViewController!
            let toControllerNew = toControllerView.childViewControllers[0]
            
            headerTo = (toControllerNew as! MCMHeaderAnimatedDelegate).headerView()
        }
        else {
            headerTo = (toController as! MCMHeaderAnimatedDelegate).headerView()
        }
        
        let headerFrom: UIView!
        let headerIntermediate: UIView!
        if self.transitionMode == .present {
            print("opening cell")
            let fromControllerParent: UITabBarController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)! as! UITabBarController
            let fromControllerView: UIViewController = fromControllerParent.selectedViewController!
            let fromControllerNew = fromControllerView.childViewControllers[0]
            headerFrom = (fromControllerNew as! MCMHeaderAnimatedDelegate).headerView()
            headerIntermediate = (fromControllerNew as! MCMHeaderAnimatedDelegate).headerCopy(headerFrom)
        }
        else if self.transitionMode == .dismiss {
            print("closing cell")
            
            headerFrom = (fromController as! MCMHeaderAnimatedDelegate).headerView()
            headerIntermediate = (fromController as! MCMHeaderAnimatedDelegate).headerCopy(headerFrom)
        }
        else {
            headerFrom = (fromController as! MCMHeaderAnimatedDelegate).headerView()
            headerIntermediate = (fromController as! MCMHeaderAnimatedDelegate).headerCopy(headerFrom)
        }

            
            if self.transitionMode == .present {
                self.headerToFrame = headerTo.superview!.convert(headerTo.frame, to: nil)
                self.headerFromFrame = headerFrom.superview!.convert(headerFrom.frame, to: nil)
            }
            
            headerFrom.alpha = 0
            headerTo.alpha = 0
            //let headerIntermediate = (fromController as! MCMHeaderAnimatedDelegate).headerCopy(headerFrom)
            headerIntermediate.frame = self.transitionMode == .present ? self.headerFromFrame : self.headerToFrame
            
            if self.transitionMode == .present {
                toView.transform = offScreenBottom
                
                container.addSubview(fromView)
                container.addSubview(toView)
                container.addSubview(headerIntermediate)
            } else {
                toView.alpha = alpha
                container.addSubview(toView)
                container.addSubview(fromView)
                container.addSubview(headerIntermediate)
            }
            
            // Perform de animation
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                
                if self.transitionMode == .present {
                    fromView.alpha = alpha
                    toView.transform = CGAffineTransform.identity
                    headerIntermediate.frame = self.headerToFrame
                } else {
                    fromView.transform = offScreenBottom
                    toView.alpha = 1.0
                    headerIntermediate.frame = self.headerFromFrame
                }
                
                }, completion: { finished in
                    
                    headerIntermediate.removeFromSuperview()
                    headerTo.alpha = 1
                    headerFrom.alpha = 1
                    
                    transitionContext.completeTransition(true)
                    
            })
            
            
        
        
    }
    
}

extension MCMHeaderAnimated {
    
    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
    }

}

extension MCMHeaderAnimated: UIViewControllerTransitioningDelegate {

    public func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.transitionMode = .present
        return self
    }

    public func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.transitionMode = .dismiss
        return self
        
    }
    
    public func interactionController(forDismissal animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.transitionInteracted ? self : nil
    }
    
}
