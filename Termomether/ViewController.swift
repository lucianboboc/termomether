//
//  ViewController.swift
//  Termomether
//
//  Created by Lucian Boboc on 01/05/16.
//  Copyright © 2016 Lucian Boboc. All rights reserved.
//

import UIKit
import LBJSON
import CoreLocation

class ViewController: UIViewController {
    
    var apiKey:String?
    var location:LBLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = LBLocation(vc: self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        location?.getCurrentLocation { [unowned self] (location, error) in
            if location != nil {
                self.getDegreesForLocation(location!)
            }else {
                let alertVC = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alertVC.addAction(ok)
                self.presentViewController(alertVC, animated: true, completion: nil)

            }
        }
    }
    
    
    func getDegreesForLocation(location:CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let weather = WeatherDatasource(apiKey: self.apiKey!)
        weather.dataForLocationWithLatitude(latitude, longitude: longitude) { (data, error) in
            print(data)
            if let json = LBJSON(object: data) {
                let celsius = json.dictionary?["current_observation"]?.dictionary?["feelslike_c"]?.str
                let farenheit = json.dictionary?["current_observation"]?.dictionary?["feelslike_f"]?.str
                print(celsius!)
                print(farenheit!)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

