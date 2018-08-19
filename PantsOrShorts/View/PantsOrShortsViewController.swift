//
//  PantsOrShortsViewController.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit

class PantsOrShortsViewController: UIViewController, PantsOrShortsViewModelDelegate {
    var viewModel: PantsOrShortsViewModelProtocol? {
        didSet {
            styleUI()
            fillUI()
        }
    }

    @IBAction func changeUserPreference() {
        viewModel?.updatePreference()
    }
    
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var preferenceButton: UIButton!

    @IBOutlet weak var pantsOrShortsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        fillUI()
    }
    
    private func fillUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        self.weatherLabel.text = viewModel.currentTempString
        self.cityLabel.text = viewModel.currentCity
        self.recommendationLabel.text = "You should wear \(viewModel.recommendation.rawValue) today"
        self.pantsOrShortsImageView.image = UIImage(named: viewModel.recommendation.rawValue)
        
        self.setPreferenceButtonText(for: viewModel.recommendation)
    }
    
    func styleUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel.recommendation {
        case .pants:
            self.weatherLabel.textColor = UIColor.coldBlue
            self.preferenceButton.backgroundColor = UIColor.hotRed
        case .shorts:
            self.weatherLabel.textColor = UIColor.hotRed
            self.preferenceButton.backgroundColor = UIColor.coldBlue
        }
    }
    
    private func setPreferenceButtonText(for recommendation: PantsOrShorts) {
        switch recommendation {
        case .pants:
            self.preferenceButton.setTitle("IT'S TOO HOT FOR PANTS", for: .normal)
        case .shorts:
            self.preferenceButton.setTitle("IT'S TOO COLD FOR SHORTS", for: .normal)
        }
    }
    
    // MARK: - PantsOrShortsViewModelDelegate
    
    public func updateUI() {
        styleUI()
        fillUI()
    }
}
