//
//  Extensions.swift
//  Atmo
//
//  Created by Marina Lunts on 11/19/18.
//  Copyright © 2018 earine. All rights reserved.
//

import Foundation


extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}

func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> [Date] {
    
    var dates = [Date]()
    var date = startDate!
    let endDate = Calendar.current.date(byAdding: addbyUnit, value: value, to: date)!
    while date < endDate {
        date = Calendar.current.date(byAdding: addbyUnit, value: 1, to: date)!
        dates.append(date)
    }
    return dates
}

