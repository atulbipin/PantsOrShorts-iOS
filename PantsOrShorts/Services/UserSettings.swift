//
//  UserSettings.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-19.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public enum UserSettings: String {
    case shortsThreshold = "shorts_threshold"
    case tempScale = "temp_scale"
    
    public func changeSetting(to newValue: String) {
        UserDefaults.shared.save(newValue, forKey: self.rawValue)
    }
    
    public func getSetting() -> String? {
        let retVal = UserDefaults.shared.string(forKey: self.rawValue)
        return retVal
    }
}
