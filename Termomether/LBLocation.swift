//
//  LBLocation.swift
//  Termomether
//
//  Created by Lucian Boboc on 01/05/16.
//  Copyright © 2016 Lucian Boboc. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationCompletion = (location:CLLocation?, error:NSError?) -> ()

class LBLocation: NSObject {
    var locationManager = CLLocationManager()
    weak var vc:ViewController?
    private var completion:LocationCompletion?
    
    init(vc:ViewController) {
        super.init()
        self.vc = vc
        locationManager.delegate = self
    }

    func getCurrentLocation(completion:LocationCompletion) {
        self.completion = completion
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if status != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }else {
            locationManager.startUpdatingLocation()
        }
    }
}


extension LBLocation: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.completion != nil {
            self.completion?(location: locations.first, error: nil)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        if self.completion != nil {
            self.completion?(location: nil, error: error)
        }
        locationManager.stopUpdatingLocation()
    }
}