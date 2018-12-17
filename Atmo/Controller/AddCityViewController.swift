//
//  SeachCityViewController.swift
//  Atmo
//
//  Created by Marina Lunts on 11/24/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit

import GooglePlaces

class AddCityViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureSimpleSearchTextField()
        // Set the array of strings you want to suggest
       
    }
    
    
    @IBAction func textfieldTapped(_ sender: Any) {
       
        taskTextField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
       
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
      
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let city = CityModel(context: context)
        city.cityTitle = taskTextField.text!
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
 
    

    // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension AddCityViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let locale = Locale(identifier: "ru")
        
        
//        taskTextField.text = 
        
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
