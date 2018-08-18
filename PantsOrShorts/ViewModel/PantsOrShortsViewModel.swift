//
//  PantsOrShortsViewModel.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public protocol PantsOrShortsViewModelProtocol {
    var currentCity: String { get }
    var currentTemp: String { get }
    var recommendation: PantsOrShorts { get }
    
    func updatePreference()
}

public protocol PantsOrShortsViewModelDelegate: AnyObject {
    func updateUI() -> Void
}

public class PantsOrShortsViewModel: NSObject, PantsOrShortsViewModelProtocol {
    private let weather = WeatherAPI()
    private let pantsOrShortsRecommender = PantShortRecommender()
    private var currentTempInCelsius: Double = 0
    
    public weak var delegate: PantsOrShortsViewModelDelegate?
    
    // MARK: - PantsOrShortsViewModelProtocol
    
    public var currentCity: String {
        didSet {
            delegate?.updateUI()
        }
    }
    public var currentTemp: String {
        didSet {
            delegate?.updateUI()
        }
    }
    public var recommendation: PantsOrShorts {
        didSet {
            delegate?.updateUI()
        }
    }
    
    public init(withLocation location: CurrentLocation) {
        self.currentCity = location.city
        self.currentTemp = "..."
        self.recommendation = .pants
        
        super.init()
    }
    
    public func loadWeather(for location: CurrentLocation, completion: @escaping () -> Void) {
        self.weather.getWeather(lon: location.longitude, lat: location.latitude) { weather in
            if let weather = weather {
                self.currentTempInCelsius = Temperature.kelvinToCelsius(temp: weather.temp)
                
                self.currentTemp = "\(Int(self.currentTempInCelsius))°C"
                self.recommendation = self.pantsOrShortsRecommender.getRecommendation(for: self.currentTempInCelsius)
                
                completion()
            }
        }
    }
    
    public func updatePreference() {
        switch recommendation {
        case .pants: // Must be too hot for pants
            pantsOrShortsRecommender.updateUserPreference(with: .tooHot, for: self.currentTempInCelsius)
        case .shorts: // Must be too cold for shorts
            pantsOrShortsRecommender.updateUserPreference(with: .tooCold, for: self.currentTempInCelsius)
        }
        
        self.recommendation = self.pantsOrShortsRecommender.getRecommendation(for: self.currentTempInCelsius)
    }
}
