//
//  UIViewController+Extension.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 11/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Embeds the `child`-viewController as a Child ViewController  to `self`. Add's `child`'s view to `self`'s view hierarchy and adds contraints to all four edges.
    public func addFullScreen(childViewController child: UIViewController) {
        guard child.parent == nil else { return }
        
        addChild(child)
        view.addSubview(child.view)
        view.pinEdges(to: child.view)
        child.didMove(toParent: self)
    }
    
    /// Removes `Child` as a Child ViewController from `self`.
    public func remove(childViewController child: UIViewController?) {
        guard let child = child else { return }
        guard child.parent != nil else { return }
        
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    /**
     Adds a child view controller (`contentVC`) in the specified `containerView`. It's adding constraints between the containerView and the contentView and returning the constraints. These should be removed when removing the child vc with `hideContent(viewController:, edgeConstraints:)`
     - returns: Array of the constraints added between container view and content view
     - parameter contentVC: The View Controller that will be added
     - parameter containerView: The view that will hold the bounds of the added content view controller
     */
    @discardableResult
    func displayContent(viewController contentVC: UIViewController, in containerView: UIView) -> [NSLayoutConstraint] {
        addChild(contentVC)
        containerView.addSubview(contentVC.view)
        let constraints = containerView.pinEdges(to: contentVC.view)
        contentVC.didMove(toParent: self)
        return constraints
    }
    
    /// Wraps `self` in a Navigation Controller
    func inNavigationController() -> UIViewController {
        return UINavigationController.init(rootViewController: self)
    }
}
