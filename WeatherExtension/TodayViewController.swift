//
//  TodayViewController.swift
//  WeatherExtension
//
//  Created by Marina Lunts on 12/2/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Alamofire
import SwiftyJSON


class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
        
  
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    var service = WidgetService()
    private var updateResult = NCUpdateResult.noData
    lazy private var locman = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       locman.delegate = self
        getWeather()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locman.startUpdatingLocation()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
 
    func  updateDisplay(temperature : Int) {
        cityLabel.text = "\(temperature)°"
    }
  
    func getWeather() {
        let params = service.getWeatherByCurrentLocation(location: (locman.location?.coordinate)!)
        getWeatherData(parameters: params)
        print("\(service.temperature)")
    }
    
    func getWeatherData(parameters: [String : String]) {
        
        Alamofire.request(service.WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                if let tempResult = weatherJSON["main"]["temp"].double {
                    self.tempLabel.text = "\(Int(tempResult - 273.15))°"
                    self.cityLabel.text = weatherJSON["name"].stringValue
                    self.conditionLabel.text = weatherJSON["weather"][0]["description"].stringValue
                    self.conditionImage.image = UIImage(named: self.service.updateWeatherIcon(condition: weatherJSON["weather"][0]["id"].intValue))
                    
//                    self.updateDisplay(temperature: self.service.temperature)
                }
            }
            else {
                print("error")
            }
        }
    }
    
}
