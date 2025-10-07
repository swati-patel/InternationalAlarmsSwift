//
//  ImageUtils.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  ImageUtils.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit

class ImageUtils {
    
    static func imageForTimeOfDay(_ isDay: Bool) -> UIImage? {
        if isDay {
            return UIImage(systemName: "sun.max")
        } else {
            return UIImage(systemName: "moon")
        }
    }
}