//
//  SequenceViewController.swift
//  SequenceViewControllerDemo
//
//  Created by Robin Charlton on 11/02/2017.
//
//

import UIKit

/// Transition direction.
enum Direction {
    case forwards
    case backwards
}

private extension Direction {
    
    /// Sign of the direction in Core Graphics coordinate space.
    var sign: CGFloat {
        switch self {
            case .forwards:
                return 1.0
            case .backwards:
                return -1.0
        }
    }
}

/**
 A container view controller that provides forwards and backwards sideways 
 transitions for child view controllers.
 */
class SequenceViewController: UIViewController {

    /// The currently presented child view controller.
    var sequencedViewController: UIViewController?
    
    /**
     Present the given view controller immediately (with no transition).
     
     The view controller becomes a child of this view controller and its view
     is attached to this view controller's view hierarchy. Any existing
     sequenced view controller is transitioned out and removed from the both
     the view controller and the view hierarchies.

     - parameter viewController: The view controller to present; may be nil.
                                 If nil, any existing sequenced controller is
                                 transitioned out.
     */
    func sequence(viewController: UIViewController?) {
        sequence(viewController: viewController, direction: .forwards, animated: false)
    }

    /**
     Present the given view controller with a sequence transition.
     
     The view controller becomes a child of this view controller and its view
     is attached to this view controller's view hierarchy. Any existing
     sequenced view controller is transitioned out and removed from the both
     the view controller and the view hierarchies.

     - parameter viewController: The view controller to present; may be nil.
                                 If nil, any existing sequenced controller is
                                 transitioned out.
     - parameter direction:      .forwards -> transition in from the right,
                                 .backwards -> transition in from the left.
     - parameter animated:       Pass true to animate the presentation;
                                 or false to present immediately.
     - parameter completion:     The block to execute after the presentation 
                                 finishes. May be nil.
     */
    func sequence(
        viewController: UIViewController?,
        direction: Direction,
        animated: Bool,
        completion: (() -> Void)? = nil) {

        var interstitialDelay: TimeInterval = 0.0
        
        let outgoingCompletion = {
            /* The completion block is always called on the incoming transition;
               however if there is no incoming view controller the outgoing
               transition must call it.
               */
            if viewController == nil {
                completion?()
            }
        }
        
        if let outgoingViewController = sequencedViewController,
            let outgoingView = outgoingViewController.view {
            
            if (animated) {
                UIView.animate(
                    after: 0.0,
                    animations: { outgoingView.transitionOut(with: direction) }) {
                    _ in
                    outgoingViewController.view.removeFromSuperview()
                    outgoingViewController.willMove(toParentViewController: nil)
                    outgoingViewController.removeFromParentViewController()
                    outgoingCompletion()
                }

                // Creates a little gap between the outgoing and incoming views.
                interstitialDelay = 0.5 * UIView.animationDuration
                
            } else {
                outgoingView.transitionOut(with: direction)
                outgoingViewController.view.removeFromSuperview()
                outgoingViewController.willMove(toParentViewController: nil)
                outgoingViewController.removeFromParentViewController()
                outgoingCompletion()
            }
        }
        
        sequencedViewController = viewController
        
        if let incomingViewController = viewController,
            let incomingView = incomingViewController.view {
            
            addChildViewController(incomingViewController)
            view.addSubview(incomingViewController.view)

            incomingView.prepareForIncomingTransition(with: direction)
            
            if (animated) {
            
                UIView.animate(
                    after: interstitialDelay,
                    animations: { incomingView.transitionIn() }) {
                    _ in
                    incomingViewController.didMove(toParentViewController: self)
                    completion?()
                }
            } else {
                incomingView.transitionIn()
                incomingViewController.didMove(toParentViewController: self)
                completion?()
            }
        }
    }
}

private extension UIView {

    static let animationDuration = 0.8

    /**
     Standardised spring animation method.
     */
    class func animate(after delay: TimeInterval,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil) {
        
        animate(
            withDuration: animationDuration,
            delay: delay,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: [UIViewAnimationOptions.curveEaseInOut],
            animations: animations,
            completion: completion)
    }

    /**
     Returns a scalar determining the forwards direction corresponding to the
     currently enabled system language.
     */
    var userInterfaceLayoutDirectionSign: CGFloat {
        let direction = UIView.userInterfaceLayoutDirection(
            for: self.semanticContentAttribute)
        
        return (direction == .leftToRight) ? 1.0 : -1.0;
    }

    /**
     Move this view into the "in" state.
     */
    func prepareForIncomingTransition(with direction: Direction) {
        let offset = direction.sign * bounds.size.width * userInterfaceLayoutDirectionSign
        transform = CGAffineTransform(translationX: offset, y: 0.0)
        alpha = 0.0
    }
    
    /**
	 Move this view into the "in" state.
     */
    func transitionIn() {
        transform = .identity
        alpha = 1.0
    }

    /**
     Move this view into the "out" state.
     
     - parameter direction: The direction of the transition.
     */
    func transitionOut(with direction: Direction) {
        let offset = -direction.sign * bounds.size.width * userInterfaceLayoutDirectionSign
        transform = CGAffineTransform(translationX: offset, y: 0.0)
        alpha = 0.0
    }
}
