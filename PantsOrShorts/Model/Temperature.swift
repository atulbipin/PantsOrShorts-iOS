//
//  Temperature.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation

public enum TemperatureScale: String {
    case celsius = "°C"
    case farenheit = "°F"
    case kelvin = "K"
}

public enum TemperatureError: Error {
    case invalidTemp(invalidTempInKelvin: Double)
}

public struct Temperature: Comparable  {
    private var _celsius: Double
    private var _kelvin: Double
    private var _farenheit: Double
    private var scale: TemperatureScale
    
    public var celsius: Double {
        get {
            return _celsius
        }
    }
    
    public var kelvin: Double {
        get {
            return _kelvin
        }
    }
    
    public var farenheit: Double {
        get {
            return _farenheit
        }
    }
    
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
            return temp
        }
    }
    
    public init(_ value: Double, in scale: TemperatureScale) {
        _celsius = Temperature.toCelsius(from: scale, temp: value)
        _farenheit = Temperature.toFarenheit(from: scale, temp: value)
        _kelvin = Temperature.toKelvin(from: scale, temp: value)
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
            return "\(Int(self.celsius))°C"
        case .farenheit:
            return "\(Int(self.farenheit))°F"
        case .kelvin:
            return "\(Int(self.kelvin))K"
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
