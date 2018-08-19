//
//  PantsOrShorts.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public enum PantsOrShorts: String {
    case pants = "pants"
    case shorts = "shorts"
}

public enum UserPreference {
    case tooHot
    case tooCold
}

public class PantShortRecommender: NSObject {
    private let defaultShortsThreshold = Temperature(21.0, in: .celsius)
    
    private var thresholdTemp: Temperature {
        get {
            if let thresholdValue = UserSettings.shortsThreshold.getSetting(), let thresholdDouble = Double(thresholdValue) {
                return Temperature(thresholdDouble, in: .celsius)
            } else {
                return defaultShortsThreshold
            }
        }
        
        set(newThreshold) {
            UserSettings.shortsThreshold.changeSetting(to: String(newThreshold.celsius))
        }
    }
    
    public func getRecommendation(for temp: Temperature) -> PantsOrShorts {
        return temp > thresholdTemp ? .shorts : .pants
    }
    
    public func updateUserPreference(with preference: UserPreference, for currentTemp: Temperature) {
        switch preference {
        case .tooCold:
            thresholdTemp = Temperature(currentTemp.celsius + 1, in: .celsius)
        case .tooHot:
            thresholdTemp = Temperature(currentTemp.celsius - 1, in: .celsius)
        }
    }
}
