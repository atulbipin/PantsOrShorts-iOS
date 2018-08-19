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
    private let DEFAULT_THRESHOLD_TEMP = Temperature(21.0, in: .celsius)
    private let USER_THRESHOLD_KEY = "shorts_threshold"
    
    private let sharedDefaults = UserDefaults.init(suiteName: "group.com.POSShared")
    
    private var thresholdTemp: Temperature {
        get {
            if let thresholdValue = sharedDefaults?.string(forKey: USER_THRESHOLD_KEY), let thresholdDouble = Double(thresholdValue) {
                return Temperature(thresholdDouble, in: .celsius)
            } else {
                return DEFAULT_THRESHOLD_TEMP
            }
        }
        
        set(newThreshold) {
            sharedDefaults?.set(String(newThreshold.celsius), forKey: USER_THRESHOLD_KEY)
            sharedDefaults?.synchronize() // TODO: Potentially move this to destructor?
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
