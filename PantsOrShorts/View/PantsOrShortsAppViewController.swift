//
//  PantsOrShortsAppViewController.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

class PantsOrShortsAppViewController: PantsOrShortsViewController {
    @IBOutlet weak var tempScaleToggleButton: UIButton!

    @IBAction func tempScaleToggle() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.toggleTempScale()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fillUI() {
        super.fillUI()
        
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        self.tempScaleToggleButton.setTitle(viewModel.tempScaleString, for: .normal)
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
        self.tempScaleToggleButton.titleLabel?.textColor = colors.secondaryTextColor
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
