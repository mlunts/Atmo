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
    
//    func setTimeZone(coord : CLLocationCoordinate2D) {
//        self.timeZone = TimezoneMapper.latLngToTimezone(coord)
//    }
    
    

}
