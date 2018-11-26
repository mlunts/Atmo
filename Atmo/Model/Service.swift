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
                
                if let tempResult = weatherJSON["main"]["temp"].double {
                    let w = Weather()
                    w.hour = Calendar.current.component(.hour, from: Date())
                    city.setValue(Int16(Int(tempResult - 273.15)), forKey: "temp")
                    city.setValue(w.updateWeatherIcon(condition: weatherJSON["weather"][0]["id"].intValue)
                        , forKey: "conditionIcon")
                    
                    //  self.weatherCities.append(weatherDataModel)
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
            weatherDataModel.sunriseHour = weatherDataModel.setHour(timeZone: city.timeZone, interval: (json["sys"]["sunrise"].intValue))
            weatherDataModel.sunsetHour = weatherDataModel.setHour(timeZone: city.timeZone, interval: (json["sys"]["sunset"].intValue))
           
            
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    
}