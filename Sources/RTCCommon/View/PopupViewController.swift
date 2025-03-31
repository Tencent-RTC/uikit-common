//
//  PopupViewController.swift
//  TUILiveKit
//
//  Created by aby on 2024/3/20.
//

import UIKit

public class PopupViewController: UIViewController {
    private let contentView: UIView
    private let supportBlurView: Bool
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = UIScreen.main.bounds
        view.alpha = 0
        return view
    }()
    
    public init(contentView: UIView, supportBlurView: Bool = true) {
        self.contentView = contentView
        self.supportBlurView = supportBlurView
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = contentView
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension PopupViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
        let transitionAnimator = AlertTransitionAnimator()
        transitionAnimator.alertTransitionStyle = .present
        if WindowUtils.isPortrait {
            transitionAnimator.alertTransitionPosition = .bottom
        } else {
            transitionAnimator.alertTransitionPosition = .right
        }
        if supportBlurView {
            showBlurEffectView(source: source, duration: transitionAnimator.duration)
        }
        return transitionAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionAnimator = AlertTransitionAnimator()
        transitionAnimator.alertTransitionStyle = .dismiss
        if WindowUtils.isPortrait {
            transitionAnimator.alertTransitionPosition = .bottom
        } else {
            transitionAnimator.alertTransitionPosition = .right
        }
        if supportBlurView {
            hiddenBlurEffectView(duration: transitionAnimator.duration)
        }
        return transitionAnimator
    }
    
    private func showBlurEffectView(source: UIViewController, duration: TimeInterval) {
        source.view.addSubview(blurEffectView)
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.blurEffectView.alpha = 1
        }
    }
    
    private func hiddenBlurEffectView(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.blurEffectView.alpha = 0
        } completion: { [weak self] finished in
            guard let self = self else { return }
            if finished {
                self.blurEffectView.removeFromSuperview()
            }
        }
    }
}
