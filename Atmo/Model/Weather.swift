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
    var conditionText : String = ""
    var weatherIconName : String = ""
    var backgroundName : String = ""
    var windSpeed : Float = 0
    var windDirection : String = ""
    var sunriseHour : String = ""
    var sunsetHour : String = ""
    var hour : Int = 12

    
    //Методы для преобразования условий
    
    func updateBackground(condition: Int) -> String {
        switch (condition) {
        case 200...232 : // шторм
                return "thunderstorm-night-image"
            
            
        case 500...531 : // дождь
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
                return "night-snoq"
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
    
    func setHour(timeZone: TimeZone, interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func windDirection(degree : Float) -> String {
        let directions = ["Северный", "Северо-восточный", "Восточный", "Юго-восточный", "Южный", "Юго-западный", "Западный", "Северо-западный"]
        let i: Int = Int((degree + 33.75)/45)
        return directions[i % 8]
    }
}
