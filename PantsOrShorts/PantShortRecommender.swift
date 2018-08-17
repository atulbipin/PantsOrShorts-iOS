//
//  PantShortModel.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-17.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public struct Celsius {
    private let ABS_ZERO_K_IN_CELSIUS = -273.15

    private let _value: Double

    public var value: Double {
        get {
            return _value
        }
    }
    
    init(temp: Double) {
        _value = temp + ABS_ZERO_K_IN_CELSIUS
    }
}

public enum Recommendation {
    case pant
    case shorts
}

public enum UserPreference {
    case tooHot
    case tooCold
}

public class PantShortRecommender {
    private let DEFAULT_THRESHOLD_TEMP = 21.0 // In Celsius
    private let USER_THRESHOLD_KEY = "shorts_thresh_hold"
    
    public var thresholdTemp: Double {
        get {
            if let thresholdValue = UserDefaults.standard.string(forKey: USER_THRESHOLD_KEY), let thresholdDouble = Double(thresholdValue) {
                return thresholdDouble
            } else {
                return DEFAULT_THRESHOLD_TEMP
            }
        }
        
        set(newThreshold) {
            UserDefaults.standard.set(String(newThreshold), forKey: USER_THRESHOLD_KEY)
            UserDefaults.standard.synchronize() // TODO: Potentially move this to destructor?
        }
    }
    
    public func getRecommendation(for temperature: Celsius) -> Recommendation {
        return temperature.value > thresholdTemp ? .shorts : .pant
    }
    
    public func tooColdForShorts(currentTemp: Celsius) {
        thresholdTemp = currentTemp.value + 1
    }
    
    public func tooHotForPants(currentTemp: Celsius) {
        thresholdTemp = currentTemp.value - 1
    }
}
