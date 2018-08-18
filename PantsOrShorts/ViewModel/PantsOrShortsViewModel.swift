//
//  PantsOrShortsViewModel.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

protocol PantsOrShortsViewModelProtocol {
    var currentCity: String { get }
    var currentTemp: String { get }
    var recommendation: PantsOrShorts { get }
}

public protocol PantsOrShortsViewModelDelegate: AnyObject {
    func updateUI() -> Void
}

public class PantsOrShortsViewModel: NSObject, PantsOrShortsViewModelProtocol {
    private let weather = WeatherAPI()
    private let pantsOrShortsRecommender = PantShortRecommender()
    
    public weak var delegate: PantsOrShortsViewModelDelegate?
    
    // MARK: - PantsOrShortsViewModelProtocol
    
    var currentCity: String
    var currentTemp: String
    var recommendation: PantsOrShorts
    
    public init(withLocation location: CurrentLocation) {
        self.currentCity = location.city
        self.currentTemp = "..."
        self.recommendation = .pants
        
        super.init()
        
        self.weather.getWeather(lon: location.longitude, lat: location.latitude) { weather in
            if let weather = weather {
                self.currentTemp = "\(Int(Temperature.kelvinToCelsius(temp: weather.temp)))°C"
                self.recommendation = self.pantsOrShortsRecommender.getRecommendation(for: Celsius(temp: weather.temp))
                
                if let delegate = self.delegate {
                    delegate.updateUI()
                }
            }
        }
    }
}
