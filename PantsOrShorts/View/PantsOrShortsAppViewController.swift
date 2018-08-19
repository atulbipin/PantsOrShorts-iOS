//
//  PantsOrShortsAppViewController.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

class PantsOrShortsAppViewController: PantsOrShortsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func styleUI() {
        super.styleUI()
        
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
    
        let colors = getThemeColors(for: viewModel.timeOfDay)
        
        self.view.backgroundColor = colors.backgroundColor
        self.cityLabel.textColor = colors.textColor
        self.recommendationLabel.textColor = colors.textColor
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func getThemeColors(for timeOfDay: TimeOfDay) -> ThemeColors {
        switch timeOfDay {
        case .day:
            return Theme.day.getColors()
        case .night:
            return Theme.night.getColors()
        }
    }
}
