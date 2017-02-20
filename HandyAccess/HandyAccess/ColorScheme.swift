//
//  ColorScheme.swift
//  HandyAccess
//
//  Created by Ana Ma on 2/19/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    var primaryDark = UIColor(red:0.13, green:0.26, blue:0.42, alpha:1.0)
    var primary = UIColor(red:0.29, green:0.60, blue:0.98, alpha:1.0)
    var primaryLight = UIColor(red:0.58, green:0.78, blue:0.99, alpha:1.0)
    
    var colorSchemeArr: [UIColor] {
        get {
            return [primaryLight, primary]
        }
    }
}
