//
//  Location.swift
//  PantsOrShorts
//
//  Created by Atul Bipin on 2018-08-18.
//  Copyright © 2018 Atul Bipin. All rights reserved.
//

import Foundation
import CoreLocation

public struct CurrentLocation {
    public let longitude: Double
    public let latitude: Double
    public let city: String
}

public class Location: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private var currentLocationCallback: ((CurrentLocation?) -> Void)?
    
    public override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func getCurrentLocation(completion: @escaping (CurrentLocation?) -> Void) {
        self.currentLocationCallback = completion
        self.startReceivingLocationChanges()
    }
    
    private func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        if let location = locations.last {

            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            Logger.shared.log(.info, anything: "USER COORDINATES: (lon, lat): (\(longitude), \(latitude))")
            
            lookUpCurrentCity(for: location) { geoLocation in
                Logger.shared.log(.info, anything: "USER CITY: \(geoLocation?.locality ?? "Unavailable")")
                
                if let callback = self.currentLocationCallback {
                    callback(CurrentLocation(longitude: longitude, latitude: latitude, city: geoLocation?.locality ?? "Unknown City"))
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.shared.log(.error, anything: error)
    }
    
    // MARK: - Helpers
    
    func lookUpCurrentCity(for location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
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
}
