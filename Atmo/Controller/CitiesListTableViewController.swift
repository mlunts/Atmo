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
import GooglePlaces

class CitiesListTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cityToBeSentCoord : CLLocationCoordinate2D?
    var cityToBeSent : CityModel!
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
                service.getCityByCoordinate(city: city, tableView: tableView)
            }
        }
        catch {
            print("Fetching Failed")
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityToBeSent = cities[indexPath.row]
//        cityToBeSentCoord = CLLocationCoordinate2D.init(latitude: cities[indexPath.row].lat, longitude: cities[indexPath.row].lng)
        performSegue(withIdentifier: "selectedCityWeather", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedCityWeather") {
            let CWeather = segue.destination as! ViewController
            CWeather.selectedCity = cityToBeSent
        }
    }
    
    @IBAction func addButtonTapped(_ sender : Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
}




extension CitiesListTableViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let city = CityModel(context: context)
        
        city.cityTitle = place.name
        city.lat = place.coordinate.latitude
        city.lng = place.coordinate.longitude
        print("///////////////")
        print(city.lng)
        print("///////////////")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
