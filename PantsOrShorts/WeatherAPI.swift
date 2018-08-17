//
//  WeatherAPI.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-16.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation
import Alamofire

public class Weather {
    private let API_KEY = "572a6acca7b36cc3b77ec5ab99658f3c"
    private let BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
    
    public func getWeather(long: Double, lat: Double) {
        let params = [
            "appid": API_KEY,
            "lat": lat,
            "lon": long
            ] as [String : Any]
        
        Alamofire.request(BASE_URL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            debugPrint(response)
        }
    }
}
