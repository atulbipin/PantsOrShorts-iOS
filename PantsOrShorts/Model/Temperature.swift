//
//  Temperature.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public struct Temperature {
    public static func kelvinToCelsius(temp: Double) -> Double {
        guard temp > 0 else {
            Logger.shared.log(.error, anything: "Temperature in Kelvin must be > 0, it was \(temp)")
            return 0
        }
        
        return temp - 273.15
    }
}
