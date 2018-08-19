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
    var currentTempString: String { get }
    var recommendation: PantsOrShorts { get }
    var timeOfDay: TimeOfDay { get }
    
    func updatePreference()
}

public protocol PantsOrShortsViewModelDelegate: AnyObject {
    func updateUI() -> Void
}

public class PantsOrShortsViewModel: NSObject, PantsOrShortsViewModelProtocol {
    private let weatherAPI = WeatherAPI()
    private let pantsOrShortsRecommender = PantShortRecommender()
    private var currentTemp: Temperature?
    
    public weak var delegate: PantsOrShortsViewModelDelegate?
    
    // MARK: - PantsOrShortsViewModelProtocol
    
    public var currentCity: String {
        didSet {
            delegate?.updateUI()
        }
    }
    public var currentTempString: String {
        didSet {
            delegate?.updateUI()
        }
    }
    public var recommendation: PantsOrShorts {
        didSet {
            delegate?.updateUI()
        }
    }
    public var timeOfDay: TimeOfDay {
        didSet {
            delegate?.updateUI()
        }
    }
    
    public init(withLocation location: CurrentLocation) {
        self.currentCity = location.city
        self.currentTempString = "..."
        self.recommendation = .pants
        self.timeOfDay = .day
        
        super.init()
    }
    
    public func loadWeather(for location: CurrentLocation, completion: @escaping () -> Void) {
        self.weatherAPI.getWeather(lon: location.longitude, lat: location.latitude) { weather in
            if let weather = weather {
                let currentTemp = Temperature(weather.temp, in: .kelvin)
                
                self.currentTemp = currentTemp
                self.currentTempString = currentTemp.getPrettyString(in: .celsius) // TODO: Add setting here
                self.recommendation = self.pantsOrShortsRecommender.getRecommendation(for: currentTemp)
                self.timeOfDay = TimeOfDay.get(sunrise: weather.sunriseUTCTimestamp, sunset: weather.sunsetUTCTimestamp)
                
                completion()
            }
        }
    }
    
    public func updatePreference() {
        guard let currentTemp = currentTemp else {
            return
        }
        
        switch recommendation {
        case .pants: // Must be too hot for pants
            pantsOrShortsRecommender.updateUserPreference(with: .tooHot, for: currentTemp)
        case .shorts: // Must be too cold for shorts
            pantsOrShortsRecommender.updateUserPreference(with: .tooCold, for: currentTemp)
        }
        
        self.recommendation = self.pantsOrShortsRecommender.getRecommendation(for: currentTemp)
    }
}
