//
//  ViewController.swift
//  Atmo
//
//  Created by Marina Lunts on 11/2/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let weatherDataModel = Weather()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params  )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Локация недоступна"
    }
    
    func getWeatherData(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                self.cityLabel.text = "Погода недоступна"
            }
        }
    }
    
    func updateWeatherData(json : JSON) {
        if let tempResult = json["main"]["temp"].double {
            let calendar = Calendar.current
            
            weatherDataModel.temperature =  Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.backgroundName = weatherDataModel.updateBackground(condition: weatherDataModel.condition)
            weatherDataModel.wind = json["wind"]["speed"].intValue
            weatherDataModel.sunriseHour = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(json["sys"]["sunrise"].intValue)) as Date)
            weatherDataModel.sunriseMinute = calendar.component(.minute, from: Date(timeIntervalSince1970: TimeInterval(json["sys"]["sunrise"].intValue)))
            weatherDataModel.sunsetHour = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(json["sys"]["sunset"].intValue)))
            weatherDataModel.sunsetMinute = calendar.component(.minute, from: Date(timeIntervalSince1970: TimeInterval(json["sys"]["sunset"].intValue)))
            weatherDataModel.hour = calendar.component(.hour, from: Date())
            
            updateUI()
            
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    func updateUI() {
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        backgroundImage.image = UIImage(named: weatherDataModel.backgroundName)
//        tipLabel.text = weatherDataModel.mood
//        windLabel.text = "Скорость ветра: \(weatherDataModel.wind) км/ч"
//        sunriseLabel.text = "Рассвет: \(weatherDataModel.sunriseHour):\(weatherDataModel.sunriseMinute)"
//        sunsetLabel.text = "Закат: \(weatherDataModel.sunsetHour):\(weatherDataModel.sunsetMinute)"
    }
    
    


}

