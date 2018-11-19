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
