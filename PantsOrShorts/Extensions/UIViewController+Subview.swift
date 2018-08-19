//
//  UIViewController+Subview.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func insertChildController(_ childController: UIViewController, intoParentView parentView: UIView) {
        childController.willMove(toParentViewController: self)
        
        self.addChildViewController(childController)
        childController.beginAppearanceTransition(true, animated: true)
        childController.view.frame = parentView.bounds
        parentView.addSubview(childController.view)
        childController.view.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
            childController.view.alpha = 1
        }, completion: { finished in
            childController.didMove(toParentViewController: self)
        })
    }
    
}


