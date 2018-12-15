//
//  City.swift
//  Atmo
//
//  Created by Marina Lunts on 11/19/18.
//  Copyright © 2018 earine. All rights reserved.
//

import Foundation
import CoreLocation
import LatLongToTimezone
import Alamofire
import SwiftyJSON

class City {
    var cityName : String = ""
    var coordinates : CLLocationCoordinate2D!
    var timeZone : TimeZone!
    var localHours : Int!
    
    func setTimeZone(coord : CLLocationCoordinate2D) {
        self.timeZone = TimezoneMapper.latLngToTimezone(coord)
    }
    
    func setCoordinatesByCity(selectedCity : String, city : City, label : UILabel) {
        print("fdfdfdf")
        let parameters : [String : String] = ["address" : selectedCity, "language" : "ru",  "key" : PLACES_API]
        Alamofire.request(PLACES_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let placeJSON : JSON = JSON(response.result.value!)
                
                city.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(placeJSON["results"][0]["geometry"]["location"]["lat"].floatValue), longitude: CLLocationDegrees(placeJSON["results"][0]["geometry"]["location"]["lng"].floatValue))
                
                city.setTimeZone(coord: self.coordinates)
                city.cityName = placeJSON["results"][0]["address_components"][0]["long_name"].stringValue
                print(city.cityName)
                print(city.timeZone)
                label.text = city.cityName
            } else {
                print("error")
            }
        }
        print(self.coordinates)
    }

}
