//
//  AppColors.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  AppColors.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit

class AppColors {
    
    // Background Colors
    static func mainBackgroundColor() -> UIColor {
        return UIColor(red: 17/255.0, green: 24/255.0, blue: 39/255.0, alpha: 1) // gray-900 (#111827)
    }
    
    static func buttonBackgroundColor() -> UIColor {
        return UIColor(red: 31/255.0, green: 41/255.0, blue: 55/255.0, alpha: 1) // gray-800 (#1F2937)
    }
    
    static func mediumGrey() -> UIColor {
        return UIColor(red: 31/255.0, green: 41/255.0, blue: 55/255.0, alpha: 1) // gray-800 (#1F2937)
    }
    
    // Text Colors
    static func primaryTextColor() -> UIColor {
        return UIColor.white // (#FFFFFF)
    }
    
    static func secondaryTextColor() -> UIColor {
        return UIColor(red: 156/255.0, green: 163/255.0, blue: 175/255.0, alpha: 1) // gray-400 (#9CA3AF)
    }
    
    static func labelTextColor() -> UIColor {
        return UIColor(red: 107/255.0, green: 114/255.0, blue: 128/255.0, alpha: 1) // gray-500 (#6B7280)
    }
    
    // Accent Colors
    static func accentBlueColor() -> UIColor {
        return UIColor(red: 96/255.0, green: 165/255.0, blue: 250/255.0, alpha: 1) // blue-400 (#60A5FA)
    }
    
    static func lightBlueColor() -> UIColor {
        return UIColor(red: 191/255.0, green: 219/255.0, blue: 254/255.0, alpha: 1) // blue-200 (#BFDBFE)
    }
    
    // Status Colors
    static func dayIconColor() -> UIColor {
        return lightBlueColor()
    }
    
    static func nightIconColor() -> UIColor {
        return lightBlueColor()
    }
    
    static func darkGrayBackgroundColor() -> UIColor {
        return UIColor(red: 45/255.0, green: 51/255.0, blue: 68/255.0, alpha: 1) // #2D3344
    }
    
    static func veryLightGrayColor() -> UIColor {
        return UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1.0) // #CDCDCD
    }
    
    static func fadedVersionOfColor(color: UIColor, withAlpha alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(alpha)
    }
    
    static func fadedVeryLightGrey() -> UIColor {
        return fadedVersionOfColor(color: veryLightGrayColor(), withAlpha: 0.2)
    }
    
    static func brightBlueColor() -> UIColor {
        return UIColor(red: 1/255.0, green: 101/255.0, blue: 252/255.0, alpha: 1) // #0165FC
    }
    
    static func darkSlateBlueGrayColor() -> UIColor {
        return UIColor(red: 38/255.0, green: 41/255.0, blue: 51/255.0, alpha: 1) // #262933
    }
    
    static func deepNavyBlackColor() -> UIColor {
        return UIColor(red: 31/255.0, green: 36/255.0, blue: 46/255.0, alpha: 1) // #1F242E
    }
    
    static func darkCharcoalPurpleColor() -> UIColor {
        return UIColor(red: 46/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1) // #2E2E38
    }
    
    static func slightlyLighterNavySlateColor() -> UIColor {
        return UIColor(red: 51/255.0, green: 56/255.0, blue: 71/255.0, alpha: 1) // #333847
    }
    
    static func mediumDarkSlateBlueColor() -> UIColor {
        return UIColor(red: 59/255.0, green: 64/255.0, blue: 82/255.0, alpha: 1) // #3B4052
    }
    
    static func darkSlateWithBlueUndertonesColor() -> UIColor {
        return UIColor(red: 66/255.0, green: 71/255.0, blue: 89/255.0, alpha: 1) // #424759
    }
    
    static func slightlyLighterOriginalColor() -> UIColor {
        return UIColor(red: 46/255.0, green: 51/255.0, blue: 66/255.0, alpha: 1) // #2E3342
    }
    
    static func defaultIOSBlueColor() -> UIColor {
        return UIColor.systemBlue
    }
}