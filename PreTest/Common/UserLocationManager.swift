//
//  UserLocationManager.swift
//  PreTest
//
//  Created by alpiopio on 16/01/20.
//  Copyright © 2020 alpiopio. All rights reserved.
//

import Foundation
import CoreLocation

protocol UserLocationDelegate {
    func locationDidUpdateToLocation(location : CLLocation)
}

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    static let instance = UserLocationManager()
    private var locationManager = CLLocationManager()
    var delegate : UserLocationDelegate!

    private override init () {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        self.delegate.locationDidUpdateToLocation(location: currentLocation)
    }
}
