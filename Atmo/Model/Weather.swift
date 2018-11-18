//
//  Weather.swift
//  Atmo
//
//  Created by Marina Lunts on 11/18/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit

class Weather {
    
    //Переменные модели
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var backgroundName : String = ""
    var wind : Int = 0
    var sunriseHour : Int = 0
    var sunriseMinute : Int = 0
    var sunsetHour : Int = 0
    var sunsetMinute : Int = 0
    var hour : Int = 12
    
    
    //Методы для преобразования условий
    
    func updateBackground(condition: Int) -> String {
        switch (condition) {
        case 500...531 : // снег
            switch hour {
            case 6..<18 :
                return "rain-day-image2"
            default :
                return "rain-day-image"
            }
        
        case 600...622 : //снег
            switch hour {
            case 6..<18 :
                return "snow-day-image"
            default :
                return "snow-night-image"
            }
        case 701...741 : //туман
            switch hour {
            case 6..<18 :
                return "fog-image"
            default :
                return "fog-night-image"
            }
        case 800 : // ясно
            switch hour {
            case 6..<18 :
                return "sunny-day-image"
            default :
                return "noclouds-night-image"
            }
        case 801 : // частичная облачность
            return "partlycloudy-day-image"
        case 802...804 : //облачно
            switch hour {
            case 6..<18 :
                return "cloudy-day-image"
            default :
                return "cloudy-night-image"
            }
        default:
            return "fog-image"
        }
    }
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 301...500 :
            return "038-rain-1"
            
        case 701...771 :
            switch hour {
            case 6..<20 :  return "030-clouds-1"
            default: return "fog2"
            }
            
        case 800 :
            switch hour {
            case 6..<20 : return "050-sun"
            default: return "028-moon-2"
            }
            
            
            
        case 801...804 :
            switch hour {
            case 6..<20 : return "003-cloudy-4"
            default: return "009-cloud"
            }
            
            
            
        case 903 :
            return "042-snow"
            
            
        default :
            return "003-cloudy-4"
        }
        
    }
}
