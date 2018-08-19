//
//  HomeViewController.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let childVC = self.childViewControllers.last as? PantsOrShortsViewController, let timeOfDay = childVC.viewModel?.timeOfDay else {
            return .default
        }
        
        switch timeOfDay {
        case .day:
            return .default
        case .night:
            return .lightContent
        }
    }
    
    let locationService = Location()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.showPantsOrShortsViewController()
    }
    
    fileprivate func showPantsOrShortsViewController() {
        if !self.isViewLoaded {
            return
        }
        
        locationService.getCurrentLocation { currentLocation in
            if let location = currentLocation {
                let controller = UIStoryboard.loadPantsOrShortsViewController()
                
                let viewModel = PantsOrShortsViewModel(withLocation: location)
                viewModel.delegate = controller
                controller.viewModel = viewModel
                
                viewModel.loadWeather(for: location) {
                    self.insertChildController(controller, intoParentView: self.view)
                }
            }
        }
    }
}
