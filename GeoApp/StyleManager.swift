//
//  StyleManager.swift
//  GeoApp
//
//  Created by Alessandro Manni - on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class StyleManager: NSObject {

    static let shared = StyleManager()
    
    let stringMissing = "N/A"
    
    struct Fonts {
        let small = UIFont(name: "Verdana", size: 10)!
        let regular = UIFont(name: "Verdana", size: 14)!
        let title = UIFont(name: "Verdana-Bold", size: 16)!
        let titleLarge = UIFont(name: "Verdana-Bold", size: 18)!
    }

    func formatLabels(_ labels: [UILabel], color: UIColor = Colors.standardBlue) {
        labels.forEach {
            $0.font = StyleManager.Fonts().regular
            $0.textColor = color
        }
    }

    func formatTitleLabels(_ labels: [UILabel], color: UIColor = Colors.standardBlue) {
        labels.forEach {
            $0.font = StyleManager.Fonts().small
            $0.textColor = color
        }
    }

}

// Style utils

struct Colors {
    static let standardBlue = UIColor(red: 34, green: 92, blue: 198)
    static let darkBlue = UIColor(red: 42, green: 122, blue: 188)
}
