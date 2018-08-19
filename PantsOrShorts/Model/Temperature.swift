//
//  Temperature.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public enum TemperatureScale {
    case celsius
    case farenheit
    case kelvin
}

public enum TemperatureError: Error {
    case invalidTemp(invalidTempInKelvin: Double)
}

public struct Temperature: Comparable {
    private var celsius: Double
    private var kelvin: Double
    private var farenheit: Double
    private var scale: TemperatureScale
    
    private static func toCelsius(from scale: TemperatureScale, temp: Double) -> Double {
        switch scale {
        case .celsius:
            return temp
        case .farenheit:
            return (temp - 32.0) * (5.0 / 9.0)
        case .kelvin:
            return temp - 273.15
        }
    }
    
    private static func toFarenheit(from scale: TemperatureScale, temp: Double) -> Double {
        switch scale {
        case .celsius:
            return (temp * (9.0 / 5.0)) + 32.0
        case .farenheit:
            return temp
        case .kelvin:
            return (temp * (9.0 / 5.0)) - 459.67
        }
    }
    
    private static func toKelvin(from scale: TemperatureScale, temp: Double) -> Double {
        switch scale {
        case .celsius:
            return temp + 273.15
        case .farenheit:
            return (temp + 459.67) * (5.0 / 9.0)
        case .kelvin:
            return (temp * (9.0 / 5.0)) - 459.67
        }
    }
    
    public init (_ value: Double, in scale: TemperatureScale) {
        celsius = Temperature.toCelsius(from: scale, temp: value)
        farenheit = Temperature.toFarenheit(from: scale, temp: value)
        kelvin = Temperature.toKelvin(from: scale, temp: value)
        self.scale = scale
        
        do {
            try self.validate()
        } catch TemperatureError.invalidTemp(let tempInKelvin) {
            Logger.shared.log(.error, anything: "Invalid temperature in Kelvin: \(tempInKelvin)")
        } catch {
            // Do nothing
        }
    }
    
    public func getPrettyString(in scale: TemperatureScale) -> String {
        switch scale {
        case .celsius:
            return "\(self.celsius)°C"
        case .farenheit:
            return "\(self.farenheit)°F"
        case .kelvin:
            return "\(self.kelvin)K"
        }
    }
    
    // MARK: Validation
    
    private func isValid() -> Bool {
        return self.kelvin >= 0
    }
    
    private func validate() throws {
        if !isValid() {
            throw TemperatureError.invalidTemp(invalidTempInKelvin: self.kelvin)
        }
    }
    
    public static func kelvinToCelsius(temp: Double) -> Double {
        guard temp > 0 else {
            Logger.shared.log(.error, anything: "Temperature in Kelvin must be > 0, it was \(temp)")
            return 0
        }
        
        return temp - 273.15
    }
    
    // MARK: - Comparable
    
    public static func < (lhs: Temperature, rhs: Temperature) -> Bool {
        return lhs.kelvin < rhs.kelvin
    }
}
