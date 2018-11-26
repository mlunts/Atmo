//
//  ViewController.swift
//  Atmo
//
//  Created by Marina Lunts on 11/2/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let locationManager = CLLocationManager()
    let service = Service()
    let weatherDataModel = Weather()
    let city = City()
    var forecast = [Weather]()
    var dates = generateDates(startDate: Date(), addbyUnit: .day, value: 5)
    let dateFormatter = DateFormatter()
    
    var selectedCity: String = "London"
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var thisTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedCity)
        
        getDataByCity()
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        thisTableView?.dataSource = self
        thisTableView?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "forecastViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? forecastViewCell  else {
            fatalError("The dequeued cell is not an instance of forecastViewCell.")
        }
        let stringDate = dateFormatter.string(from: dates[indexPath.row])
        let cellForecast = forecast[indexPath.row]
        if(cellForecast.temperatureMax < cellForecast.temperatureMin) {
            cell.cellMaxTempLabel.text = "\(cellForecast.temperatureMin)°"
            cell.cellMinTempLabel.text = "\(cellForecast.temperatureMax)°"
        } else {
            cell.cellMaxTempLabel.text = "\(cellForecast.temperatureMax)°"
            cell.cellMinTempLabel.text = "\(cellForecast.temperatureMin)°"
        }
        cell.cellCondTempLabel.text = (cellForecast.conditionText).firstUppercased
        cell.cellCondIconImage.image = UIImage(named: cellForecast.weatherIconName)
        cell.cellDateLabel.text = stringDate
        return cell
    }
    
    func getDataByCity() {
        city.cityName = selectedCity
        getCoordinateFrom(address: city.cityName) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            // don't forget to update the UI from the main thread
            DispatchQueue.main.async {
                self.city.coordinates = coordinate
                
            }
        }
        city.setCoordinatesByCity(selectedCity: selectedCity)
        let params : [String : String] = ["q" : selectedCity, "lang" : "ru", "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        getForecastData(url: FORECAST_URL, parameters: params)
    }
    
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Локация недоступна"
    }
    
    
    func getForecastData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let forecastJSON : JSON = JSON(response.result.value!)
                self.updateForecastData(json: forecastJSON)
            }
        }
    }
    
    func getWeatherData(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.service.updateWeatherData(json: weatherJSON, city: self.city, weatherDataModel: self.weatherDataModel, cityLabel: self.cityLabel)
                self.updateUI()
            }
            else {
                self.cityLabel.text = "Погода недоступна"
            }
        }
    }

    
    func updateForecastData(json : JSON) {
            for i in 0...4 {
                let weather = Weather()
                let j = 7*(i+1)
                weather.hour = Calendar.current.component(.hour, from: Date())
                weather.temperatureMax = Int(json["list"][j]["main"]["temp_max"].double! - 273.15)
                weather.temperatureMin = Int(json["list"][2*i]["main"]["temp_min"].double! - 273.15)
                weather.conditionText = json["list"][j]["weather"][0]["description"].stringValue
                weather.condition = json["list"][j]["weather"][0]["id"].intValue
                weather.weatherIconName = weather.updateWeatherIcon(condition: weather.condition)
                forecast.append(weather)
                self.thisTableView.reloadData()
            }
    }
    
    func updateUI() {
        cityLabel.text = city.cityName
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        backgroundImage.image = UIImage(named: weatherDataModel.backgroundName)
        conditionLabel.text = (weatherDataModel.conditionText).firstUppercased
        windDirectionLabel.text = weatherDataModel.windDirection
        windSpeedLabel.text = "\(weatherDataModel.windSpeed) км/ч"
        sunriseLabel.text = "\(weatherDataModel.sunriseHour)"
        sunsetLabel.text = "\(weatherDataModel.sunsetHour)"
    }
    
}

