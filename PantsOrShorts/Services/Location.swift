//
//  Location.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation
import CoreLocation

public class Location: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private var currentLocationCallback: ((CurrentLocation?) -> Void)?
    
    public override init() {
        super.init()
        
        self.locationManager.delegate = self
    }
    
    public func getCurrentLocation(completion: @escaping (CurrentLocation?) -> Void) {
        locationManager.requestLocation()
        self.currentLocationCallback = completion
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude {
            Logger.shared.log(.info, anything: "USER COORDINATES: (lon, lat): (\(longitude), \(latitude)")
            
            lookUpCurrentLocation { geoLocation in
                Logger.shared.log(.info, anything: "USER CITY: \(geoLocation?.locality ?? "Unavailable")")
                
                if let callback = self.currentLocationCallback {
                    callback(CurrentLocation(longitude: longitude, latitude: latitude, city: geoLocation?.locality ?? "Unknown"))
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.shared.log(.error, anything: error)
    }
    
    // MARK: - Helpers
    
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
