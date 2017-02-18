//
//  Utilities.swift
//  Graffy
//
//  Created by Cris on 2/6/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Foundation

struct Colors {
    // dark blue
    static let darkPrimaryColor =  UIColor(red: 69/255, green: 90/255, blue: 100/255, alpha: 1.0)
    // medium blue
    static let primaryColor = UIColor(red: 96/255, green: 125/255, blue: 139/255, alpha: 1.0)
    // light blue
    static let lightPrimaryColor = UIColor(displayP3Red: 207/255, green: 216/255, blue: 220/255, alpha: 1.0)
    // white
    static let text_iconsColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    // yellow
    static let accentColor = UIColor(red: 255/255, green: 215/255, blue: 64/255, alpha: 1.0)
    // very dark gray -- looks black
    static let primaryText = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    // medium gray
    static let secondaryText = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
    // light gray
    static let dividerColor = UIColor(displayP3Red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0)
}

class Style {
    static let textFont = UIFont(name: "SanFranciscoText-RegularG3" , size: 16.0 )
    static let titleFont = UIFont(name: "SanFranciscoDisplay-Ultralight" , size: 32.0 )
    static let normalButtonFont = UIFont(name: "SanFranciscoDisplay-Ultralight" , size: 14.0 )
    static let boldButtonFont = UIFont(name: "SanFranciscoDisplay-Black" , size: 14.0 )
    static let bigCollectionViewCellFont = UIFont(name: "SanFranciscoDisplay-Heavy", size: 20.0)
    static let littleCollectionViewCellFont = UIFont(name: "SanFranciscoText-RegularG3", size: 16.0)
    static let bigTableViewCellFont = UIFont(name: "SanFranciscoDisplay-Heavy", size: 20.0)
    static let littleTableViewCellFont = UIFont(name: "SanFranciscoText-RegularG3", size: 16.0)
    
    static let normalTextColor = Colors.primaryText
    static let selectedTextColor = Colors.accentColor
    static let iconColor = Colors.text_iconsColor
    static let selectedIconColor = Colors.accentColor
    static let normalButtonBackgroundColor = UIColor.clear
    static let selectedButtonBackGroundColor = Colors.darkPrimaryColor
    static let buttonTextColor = Colors.text_iconsColor
    static let selectedButtonTextColor = Colors.primaryText
}

struct Categories {
    static let array = ["Animals", "Outdoors", "Flowers & Plants"]
}
