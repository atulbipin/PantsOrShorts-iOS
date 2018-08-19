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
    var tempScaleString: String { get }
    
    func updateTempPreference()
    func toggleTempScale()
}

public protocol PantsOrShortsViewModelDelegate: AnyObject {
    func updateUI() -> Void
}

public class PantsOrShortsViewModel: NSObject, PantsOrShortsViewModelProtocol {
    private let weatherAPI = WeatherAPI()
    private let pantsOrShortsRecommender = PantShortRecommender()
    private var currentTemp: Temperature?
    
    private var tempScale: TemperatureScale? = TemperatureScale(rawValue: UserSettings.tempScale.getSetting() ?? "") {
        didSet {
            if let currentTemp = self.currentTemp, let tempScale = tempScale {
                self.currentTempString = currentTemp.getPrettyString(in: tempScale)
                UserSettings.tempScale.changeSetting(to: tempScale.rawValue)
            }
        }
    }
    
    public var tempScaleString: String {
        get {
            guard let tempScale = tempScale else {
                return TemperatureScale.celsius.rawValue
            }
            
            switch tempScale {
            case .celsius:
                return TemperatureScale.farenheit.rawValue
            case .farenheit:
                fallthrough
            default:
                return TemperatureScale.celsius.rawValue
            }
        }
    }
    
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
            if let weather = weather, let tempScale = self.tempScale {
                let currentTemp = Temperature(weather.temp, in: .kelvin)
                
                self.currentTemp = currentTemp
                self.currentTempString = currentTemp.getPrettyString(in: tempScale) // TODO: Add setting here
                self.recommendation = self.pantsOrShortsRecommender.getRecommendation(for: currentTemp)
                self.timeOfDay = TimeOfDay.get(sunrise: weather.sunriseUTCTimestamp, sunset: weather.sunsetUTCTimestamp)
                
                completion()
            }
        }
    }
    
    public func updateTempPreference() {
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
    
    public func toggleTempScale() {
        guard let tempScale = tempScale else {
            return
        }
        
        switch tempScale {
        case .celsius:
            self.tempScale = .farenheit
        case .farenheit:
            self.tempScale = .celsius
        default:
            self.tempScale = .celsius
        }
    }
}
