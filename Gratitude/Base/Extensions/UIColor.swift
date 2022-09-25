//
//  UIColor.swift
//  Gratitude
//
//  Created by Yuvaraj on 24/09/22.
//

import Foundation
import UIKit

extension UIColor {
    class var gratitudePurple: UIColor {
        return UIColor(named: "gratitudePurple") ?? UIColor.purple
    }
    
    class var gratitudeChipPurple: UIColor {
        return UIColor(named: "gratitudeChipPurple") ?? UIColor.purple
    }
    
    class var black50: UIColor {
        return UIColor(named: "black50") ?? UIColor.black
    }
    
    class var palleteYellow: UIColor {
        return UIColor(named: "paletteYellow") ?? UIColor.yellow
    }
    
    class var palleteBlue: UIColor {
        return UIColor(named: "paletteBlue") ?? UIColor.blue
    }
    
    class var palleteGreen: UIColor {
        return UIColor(named: "paletteGreen") ?? UIColor.green
    }
    
    class var palletePink: UIColor {
        return UIColor(named: "palettePink") ?? UIColor.systemPink
    }
}
