//
//  Service.swift
//  Atmo
//
//  Created by Marina Lunts on 11/25/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class Service: NSObject {
    var serviceCity = City()
    var serviceWeather = Weather()
    
    func getCityByCoordinate(city : CityModel, tableView : UITableView) {
        print("///")
        print(city.lng)
        print("///")
        let parameters : [String : String] = ["lat" : String(city.lat), "lon" : String(city.lng), "lang" : "ru", "appid" : APP_ID]
        
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let json : JSON = JSON(response.result.value!)
                
                if let tempResult = json["main"]["temp"].double {
                    city.setValue(Calendar.current.component(.hour, from: Date()), forKey: "localHour")
                    city.setValue(json["weather"][0]["id"].intValue, forKey: "condition")
                    city.setValue(Int16(Int(tempResult - 273.15)), forKey: "temp")
                    city.setValue(updateWeatherIcon(condition: Int(city.condition), hour: Int(city.localHour)), forKey: "conditionIcon")
                    self.updateCityModel(city : city, json : json)
                    tableView.reloadData()
                }
            }
            else {
                //                cityLabel.text = "Weather unavailable"
            }
        }
    }
    
    func updateCityModel(city : CityModel, json : JSON)  {
        let timezone = setTimeZone(coord: CLLocationCoordinate2D.init(latitude: city.lat, longitude: city.lng))
        
        city.setValue(setHour(timeZone: (timezone)!, interval: (json["sys"]["sunrise"].intValue)), forKey: "sunriseHour")
        city.setValue(setHour(timeZone: (timezone)!, interval: (json["sys"]["sunset"].intValue)), forKey: "sunsetHour")
        city.setValue(json["weather"][0]["description"].stringValue, forKey: "conditionText")
        city.setValue(updateBackground(condition: Int(city.condition), hour: Int(city.localHour)), forKey: "conditionBackground")
        city.setValue(windDirection(degree: (json["wind"]["deg"].floatValue)), forKey: "windDirection")
        city.setValue(json["wind"]["speed"].doubleValue, forKey: "windSpeed")
        city.setValue(json["main"]["humidity"].intValue, forKey: "humidity")
        city.setValue(json["clouds"]["all"].intValue, forKey: "cloudness")
    }
    
    
    func getForecastDay(weather : Weather, j : Int, i : Int, json : JSON) {
        weather.hour = Calendar.current.component(.hour, from: Date())
        weather.temperatureMax = Int(json["list"][j]["main"]["temp_max"].double! - 273.15)
        weather.temperatureMin = Int(json["list"][2*i]["main"]["temp_min"].double! - 273.15)
        weather.conditionText = json["list"][j]["weather"][0]["description"].stringValue
        weather.condition = json["list"][j]["weather"][0]["id"].intValue
        weather.weatherIconName = updateWeatherIcon(condition: weather.condition, hour: weather.hour)
    }
    
}
