//
//  ForecastTableViewController.swift
//  Atmo
//
//  Created by Marina Lunts on 11/19/18.
//  Copyright © 2018 earine. All rights reserved.
//

import UIKit

class forecastViewCell: UITableViewCell {

    
    @IBOutlet weak var cellMinTempLabel: UILabel!
    @IBOutlet weak var cellMaxTempLabel: UILabel!
    @IBOutlet weak var cellDateLabel: UILabel!
    @IBOutlet weak var cellCondTempLabel: UILabel!
    @IBOutlet weak var cellCondIconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
