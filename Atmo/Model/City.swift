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


class City {
    var coordinates : CLLocationCoordinate2D!
    var timeZone : TimeZone!
    
    func setTimeZone() {
        self.timeZone = TimezoneMapper.latLngToTimezone(coordinates)
    }
}
