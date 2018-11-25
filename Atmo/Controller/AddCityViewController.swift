//
//  SeachCityViewController.swift
//  Atmo
//
//  Created by Marina Lunts on 11/24/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit



class AddCityViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let city = CityModel(context: context)
        city.cityTitle = taskTextField.text!
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
}
