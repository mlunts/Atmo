//
//  Weather.swift
//  Atmo
//
//  Created by Marina Lunts on 11/18/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit

class Weather {
    var city = City()
    
    //Переменные модели
    var temperature : Int = 0
    var temperatureMax : Int = 0
    var temperatureMin : Int = 0
    var condition : Int = 0
    var conditionText : String = ""
    var weatherIconName : String = ""
    var backgroundName : String = ""
    var windSpeed : Float = 0
    var windDirection : String = ""
    var sunriseHour : String = ""
    var sunsetHour : String = ""
    var hour : Int = 0
    var cloudness : Int = 100
    var humidity : Int = 100
    
  
    
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
    
    func setTime(timeZone: TimeZone, interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date)
    }
}
