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
    @IBOutlet weak var topConstraint:NSLayoutConstraint!
    @IBOutlet weak var temperatureTotalView:UIView!
    @IBOutlet weak var temperatureValueView:UIView!
    @IBOutlet weak var termometherView:UIImageView!
    
    @IBOutlet weak var cityLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = LBLocation(vc: self)
        topConstraint.constant = 0
        self.temperatureValueView.backgroundColor = UIColor.whiteColor()
        self.cityLabel.text = ""
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
                let city = json.dictionary?["current_observation"]?.dictionary?["display_location"]?.dictionary?["city"]?.str
                
                print(celsius!)
                print(farenheit!)
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.configureViewWithCelsius(Double(celsius!))
                    self.configureCity(city)
                }
            }
        }
    }
    
    func configureViewWithCelsius(celsiusValue:Double?) {
        
        if let cel = celsiusValue {
            let celsius = CGFloat(cel)
            
            let minusDegreesValue:CGFloat = 40.0
            let totalDegreesValue:CGFloat = 100.0
            let tempValue:CGFloat = celsius + minusDegreesValue
            let procent = tempValue * 100.0 / totalDegreesValue
            
            let distance = self.temperatureTotalView.frame.size.height * procent / 100.0;
            
            UIView.animateWithDuration(1.0, animations: {
                self.topConstraint.constant = self.temperatureTotalView.frame.size.height - distance
                self.temperatureValueView.backgroundColor = UIColor.redColor()
            })
        }
    }
    
    func configureCity(cityValue:String?) {
        if let city = cityValue {
            self.cityLabel.text = city
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

