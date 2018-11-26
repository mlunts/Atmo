//
//  CitiesListTableViewController.swift
//  Atmo
//
//  Created by Marina Lunts on 11/24/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class CitiesListTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cityToBeSent: String = ""
    
    let service = Service()
    
    var cities: [CityModel] = []
    var weatherCities = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            as! CitiesListTableCell
        
        let city = cities[indexPath.row]
       
        cell.cityTitleLabel.text = city.cityTitle
        cell.tempLabel.text = "\(city.temp)°"
        cell.conditionIcon.image = UIImage(named: city.conditionIcon ?? "fog")
        return cell
    }
    
    func getData() {
        do {
            cities = try context.fetch(CityModel.fetchRequest())
            for city in cities {
                service.getCityByName(city: city, tableView: tableView)
                
            }
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityToBeSent = cities[indexPath.row].cityTitle ?? "Odessa"
        
        performSegue(withIdentifier: "selectedCityWeather", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = cities[indexPath.row]
            context.delete(city)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                cities = try context.fetch(CityModel.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let CWeather = segue.destination as! ViewController
        CWeather.selectedCity = cityToBeSent
    }
    
}



