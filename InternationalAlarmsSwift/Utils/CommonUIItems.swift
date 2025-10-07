//
//  CommonUIItems.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  CommonUIItems.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit

class CommonUIItems {
    
    static func styleHelpButton(button: UIButton, target: Any, action: Selector) {
        button.setTitle("Help", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.brightBlueColor()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = AppColors.accentBlueColor().cgColor
        button.layer.cornerRadius = 10.0
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    static func appendInfoSection(_ title: String, toString string: NSMutableAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacingBefore = 4
        paragraphStyle.paragraphSpacing = 4
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: AppFonts.sectionTitleFont(),
            .foregroundColor: AppColors.accentBlueColor(),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedTitle = NSAttributedString(string: "\n\(title)\n", attributes: attributes)
        string.append(attributedTitle)
    }
    
    static func appendInfoBullet(_ text: String, toString string: NSMutableAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.headIndent = 15.0
        paragraphStyle.firstLineHeadIndent = 0.0
        paragraphStyle.paragraphSpacingBefore = 2
        paragraphStyle.paragraphSpacing = 6
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: AppFonts.smallRegularFont(),
            .foregroundColor: AppColors.primaryTextColor(),
            .paragraphStyle: paragraphStyle
        ]
        
        let bullet = NSAttributedString(string: "• ", attributes: attributes)
        string.append(bullet)
        
        let attributedText = NSAttributedString(string: "\(text)\n", attributes: attributes)
        string.append(attributedText)
    }
}