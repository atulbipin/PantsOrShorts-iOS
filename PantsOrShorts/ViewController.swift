//
//  ViewController.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-16.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let pantShortRecommender = PantShortRecommender()
    let weatherAPI = Weather()
//    let recommendation: Recommendation?
    
    @IBAction func onButtonPress() {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude {
            print("\(latitude),\(longitude)")
            
            weatherAPI.getWeather(lon: longitude, lat: latitude) { currentWeather in
                if let currentWeather = currentWeather {
                    debugPrint("Current weather: \(Celsius(temp: currentWeather.temp).value)")
                    debugPrint(self.pantShortRecommender.getRecommendation(for: Celsius(temp: currentWeather.temp)))
                }
            }
            
            lookUpCurrentLocation { geoLocation in
                print(geoLocation?.locality ?? "Unknown geo location")
            }
        } else {
            print("No coordinates")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}

