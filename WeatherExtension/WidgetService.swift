//
//  WidgetService.swift
//  WeatherExtension
//
//  Created by Marina Lunts on 12/3/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WidgetService: NSObject {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "7ea8f559ec5f1f0899b61c89d728a8b9"
    var temperature : Int = 0
    
    
    func getWeatherByCurrentLocation(location : CLLocationCoordinate2D) -> [String : String] {
        let latitude = String(location.latitude)
        let longitude = String(location.longitude)
        
        let params : [String : String] = ["lat" : latitude, "lon" : longitude, "lang" : "ru", "appid" : APP_ID]
        
        return params
    }
    func updateWeatherIcon(condition: Int) -> String {
        var hour = Calendar.current.component(.hour, from: Date())
        switch (condition) {
        case 200...232 : // шторм
            switch hour {
            case 6..<18 :
                return "storm"
            default :
                return "storm-night"
            }
            
        case 300...321 : // легкий дождь
            switch hour {
            case 6..<18 :
                return "hail"
            default :
                return "night-rain"
            }
            
        case 500...531 : // дождь
            switch hour {
            case 6..<18 :
                return "storm"
            default :
                return "night-rain"
            }
            
        case 600...622 : //снег
            switch hour {
            case 6..<18 :
                return "snowy"
            default :
                return "night-snow"
            }
            
        case 701...741 : //туман
            return "fog"
            
        case 800 : // ясно
            switch hour {
            case 6..<18 :
                return "sun"
            default :
                return "night-4"
            }
            
        case 801 : // частичная облачность
            return "cloudy-3"
            
        case 802 : //облачно
            switch hour {
            case 6..<18 :
                return "cloud"
            default :
                return "cloud-moon"
            }
            
        case 803...804 : //сильная облачность
            return "cloudy"
            
        default:
            return "windy"
        }
    }
}
