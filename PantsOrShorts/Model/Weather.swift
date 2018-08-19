//
//  Weather.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

// NOTE: Temperature in Kelvin
public struct Weather {
    let temp: Double;
    let tempMin: Double;
    let tempMax: Double;
    let sunriseUTCTimestamp: Double;
    let sunsetUTCTimestamp: Double;
}
