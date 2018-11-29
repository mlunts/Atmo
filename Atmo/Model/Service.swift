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

class Service: NSObject {
    var serviceCity = City()
    var serviceWeather = Weather()
    
    func getCityByName(city : CityModel, tableView : UITableView) {
        var cityTitle = city.cityTitle
        let parameters : [String : String] = ["q" : cityTitle ?? "Odessa", "lang" : "ru", "appid" : APP_ID]
        
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                if let tempResult = weatherJSON["main"]["temp"].double {
                    let w = Weather()
                    w.hour = Calendar.current.component(.hour, from: Date())
                    city.setValue(Int16(Int(tempResult - 273.15)), forKey: "temp")
                    city.setValue(w.updateWeatherIcon(condition: weatherJSON["weather"][0]["id"].intValue)
                        , forKey: "conditionIcon")
                    
                    tableView.reloadData()
                }
            }
            else {
                //                cityLabel.text = "Weather unavailable"
            }
        }
        print(city.temp)
        
    }
    
    func updateWeatherData(json : JSON, city : City, weatherDataModel : Weather, cityLabel : UILabel) {
        if let tempResult = json["main"]["temp"].double {
            city.cityName = json["name"].stringValue
            weatherDataModel.hour = Calendar.current.component(.hour, from: Date())
            weatherDataModel.temperature =  Int(tempResult - 273.15)
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.conditionText = json["weather"][0]["description"].stringValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.backgroundName = weatherDataModel.updateBackground(condition: weatherDataModel.condition)
            weatherDataModel.windSpeed = json["wind"]["speed"].floatValue
            weatherDataModel.windDirection = weatherDataModel.windDirection(degree: (json["wind"]["deg"].floatValue))
            if city.timeZone == nil {
                weatherDataModel.sunriseHour = "7:21"
                weatherDataModel.sunsetHour = "16:58"
            } else {
                weatherDataModel.sunriseHour = weatherDataModel.setHour(timeZone: city.timeZone, interval: (json["sys"]["sunrise"].intValue))
                weatherDataModel.sunsetHour = weatherDataModel.setHour(timeZone: city.timeZone, interval: (json["sys"]["sunset"].intValue))
            }
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.cloudness = json["clouds"]["all"].intValue
            
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    func getForecastDay(weather : Weather, j : Int, i : Int, json : JSON) {
        weather.hour = Calendar.current.component(.hour, from: Date())
        weather.temperatureMax = Int(json["list"][j]["main"]["temp_max"].double! - 273.15)
        weather.temperatureMin = Int(json["list"][2*i]["main"]["temp_min"].double! - 273.15)
        weather.conditionText = json["list"][j]["weather"][0]["description"].stringValue
        weather.condition = json["list"][j]["weather"][0]["id"].intValue
        weather.weatherIconName = weather.updateWeatherIcon(condition: weather.condition)
    }
    
}
