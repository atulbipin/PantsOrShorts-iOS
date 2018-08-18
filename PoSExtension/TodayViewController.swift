////
////  TodayViewController.swift
////  PoSExtension
////
////  Created by Justin Park on 8/17/18.
////  Copyright © 2018 Atul Bipin. All rights reserved.
////
//
//import UIKit
//import NotificationCenter
//import CoreLocation
//
//class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
//
//    let locationManager = CLLocationManager()
//    let pantShortRecommender = PantShortRecommender()
//    let weatherAPI = Weather()
//    var currentWeather: Celsius?
//
//    @IBOutlet weak var recommendationLabel: UILabel!
//    @IBAction func onButtonPress() {
//        locationManager.requestLocation()
//    }
//    
//    @IBAction func tooCold() {
//        if let currentWeather = self.currentWeather {
//            pantShortRecommender.updateUserPreference(with: .tooCold, for: currentWeather)
//            locationManager.requestLocation()
//        }
//    }
//
//    @IBAction func tooHot() {
//        if let currentWeather = self.currentWeather {
//            pantShortRecommender.updateUserPreference(with: .tooHot, for: currentWeather)
//            locationManager.requestLocation()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
//
//        locationManager.requestLocation()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - CLLocationManagerDelegate
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude {
//            print("\(latitude),\(longitude)")
//
//            // TODO: Figure out async stuff going on here
//
//            weatherAPI.getWeather(lon: longitude, lat: latitude) { currentWeather in
//                if let currentWeather = currentWeather {
//                    self.currentWeather = Celsius(temp: currentWeather.temp)
//                    debugPrint("Current weather: \(Celsius(temp: currentWeather.temp).value)°C")
//
//                    self.recommendationLabel.text = "You should wear " +  self.pantShortRecommender.getMessage(for: self.currentWeather!) + " today!"
//                    self.recommendationLabel.sizeToFit()
//                    debugPrint(self.pantShortRecommender.getRecommendation(for: self.currentWeather!))
//                }
//            }
//
//            lookUpCurrentLocation { geoLocation in
//                print(geoLocation?.locality ?? "Unknown geo location")
//            }
//        } else {
//            print("No coordinates")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//
//    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
//        // Use the last reported location.
//        if let lastLocation = self.locationManager.location {
//            let geocoder = CLGeocoder()
//
//            // Look up the location and pass it to the completion handler
//            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
//                if error == nil {
//                    let firstLocation = placemarks?[0]
//                    completionHandler(firstLocation)
//                }
//                else {
//                    // An error occurred during geocoding.
//                    completionHandler(nil)
//                }
//            })
//        }
//        else {
//            // No location was available.
//            completionHandler(nil)
//        }
//    }
//
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        // Perform any setup necessary in order to update the view.
//
//        // If an error is encountered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//
//        completionHandler(NCUpdateResult.newData)
//    }
//
//}
