//
//  WeatherAPI.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-16.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Weather {
    private let API_KEY = "572a6acca7b36cc3b77ec5ab99658f3c"
    private let OPEN_WEATHER_BASE_URL = "https://api.openweathermap.org"
    private let WEATHER_API_ENDPOINT = "/data/2.5/weather"
    
    private func extractCurrentTemperature(from responseJSON: JSON) -> CurrentWeather {
        return CurrentWeather(
            temp: responseJSON["main"]["temp"].double ?? -1,
            tempMin: responseJSON["main"]["temp_min"].double ?? -1,
            tempMax: responseJSON["main"]["temp_max"].double ?? -1
        )
    }

    public func getWeather(lon: Double, lat: Double, completion: @escaping (CurrentWeather?) -> Void) {
        let params = [
            "appid": API_KEY,
            "lat": lat,
            "lon": lon
            ] as [String : Any]
        
        Alamofire.request("\(OPEN_WEATHER_BASE_URL)\(WEATHER_API_ENDPOINT)", method: .get, parameters: params, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(self.extractCurrentTemperature(from: JSON(response.data ?? Data())))
            case .failure(let error):
                completion(nil)
                print(error)
            }
            
        }
    }
}

// NOTE: Temperature in Kelvin
public struct CurrentWeather {
    let temp: Double;
    let tempMin: Double;
    let tempMax: Double;
}
