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
import SwiftMoment

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let weatherDataModel = Weather()
    let city = City()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    
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
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "lang" : "ru", "appid" : APP_ID]
            
            city.coordinates = location.coordinate
            city.setTimeZone()
            
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
            weatherDataModel.conditionText = json["weather"][0]["description"].stringValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.backgroundName = weatherDataModel.updateBackground(condition: weatherDataModel.condition)
            weatherDataModel.wind = json["wind"]["speed"].intValue
          
            weatherDataModel.sunriseHour = weatherDataModel.setHour(timeZone: city.timeZone, interval: (json["sys"]["sunrise"].intValue))
            weatherDataModel.sunsetHour = weatherDataModel.setHour(timeZone: city.timeZone, interval: (json["sys"]["sunset"].intValue))
            
        
            
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
        conditionLabel.text = (weatherDataModel.conditionText).firstUppercased
//        tipLabel.text = weatherDataModel.mood
//        windLabel.text = "Скорость ветра: \(weatherDataModel.wind) км/ч"
        sunriseLabel.text = "\(weatherDataModel.sunriseHour)"
        sunsetLabel.text = "\(weatherDataModel.sunsetHour)"
    }
    
    


}

