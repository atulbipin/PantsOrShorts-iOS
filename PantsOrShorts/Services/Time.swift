//
//  Time.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public enum TimeOfDay {
    case day
    case night
    
    private static var currentUTCTimestamp: Double {
        get {
            return NSDate().timeIntervalSince1970
        }
    }
    
    public static func get(sunrise: Double, sunset: Double) -> TimeOfDay {
        // TODO: Account for case when sunrise or sunset doesn't exist, i.e. it is -1
        if currentUTCTimestamp < sunrise || currentUTCTimestamp >= sunset {
            return .night
        } else {
            return .day
        }
    }
}
