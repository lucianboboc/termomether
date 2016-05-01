//
//  WeatherDatasource.swift
//  Termomether
//
//  Created by Lucian Boboc on 01/05/16.
//  Copyright © 2016 Lucian Boboc. All rights reserved.
//

import UIKit

typealias APICompletion = (data:NSDictionary?, error:NSError?) -> ()

class WeatherDatasource {
    
    let key:String
    
    init(apiKey:String) {
        self.key = apiKey
    }
    
    func dataForLocationWithLatitude(latitude:Double, longitude:Double, completion: APICompletion) {
        let apiStr = "http://api.wunderground.com/api/\(self.key)/conditions/q/\(latitude),\(longitude).json"
        
        let url = NSURL(string: apiStr)
        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            
            if error != nil {
                completion(data: nil, error: error)
            }else {
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    completion(data: dict as! NSDictionary, error: nil)
                }catch {
                    completion(data: nil, error: error as NSError)
                }
            }
        }.resume()
    }
}
