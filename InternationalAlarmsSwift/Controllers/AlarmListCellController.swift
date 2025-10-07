//
//  AlarmListCellController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  AlarmListCellController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit

class AlarmListCellController: UITableViewCell {
    
    @IBOutlet weak var locationValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    @IBOutlet weak var descriptionValue: UILabel!
    @IBOutlet weak var currentTimeIcon: UIImageView!
    @IBOutlet weak var localTimeIcon: UIImageView!
    @IBOutlet weak var timeRemainingValue: UILabel!
    @IBOutlet weak var currentTimeValue: UILabel!
    @IBOutlet weak var localTimeValue: UILabel!
    @IBOutlet weak var topDividerLine: UIView!
    @IBOutlet weak var infoDividerLine: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var localTimeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var descriptionIcon: UIImageView!
    @IBOutlet weak var timeRemainingIcon: UIImageView!
    
    func setupConstraints() {
        let views = [
            locationValue, dateValue, timeValue, descriptionValue,
            topDividerLine, infoDividerLine,
            currentTimeLabel, localTimeLabel, timeRemainingLabel,
            currentTimeValue, localTimeValue, timeRemainingValue,
            currentTimeIcon, localTimeIcon
        ]
        
        for view in views {
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let leadingMargin: CGFloat = 10.0
        let trailingMargin: CGFloat = 10.0
        let topMargin: CGFloat = 8.0
        let standardSpacing: CGFloat = 8.0
        let dividerHeight: CGFloat = 1.0
        let iconSize: CGFloat = 20.0
        
        currentTimeValue.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        localTimeValue.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        timeRemainingValue.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
        NSLayoutConstraint.activate([
            // TOP DIVIDER LINE
            topDividerLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topDividerLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topDividerLine.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            topDividerLine.heightAnchor.constraint(equalToConstant: dividerHeight),
            
            // Location Value
            locationValue.leadingAnchor.constraint(equalTo: topDividerLine.leadingAnchor, constant: leadingMargin),
            locationValue.topAnchor.constraint(equalTo: topDividerLine.topAnchor, constant: topMargin),
            locationValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            
            // Date Value
            dateValue.leadingAnchor.constraint(equalTo: locationValue.leadingAnchor),
            dateValue.topAnchor.constraint(equalTo: locationValue.bottomAnchor, constant: standardSpacing),
            dateValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            
            // Time Value
            timeValue.leadingAnchor.constraint(equalTo: locationValue.leadingAnchor),
            timeValue.topAnchor.constraint(equalTo: dateValue.bottomAnchor, constant: standardSpacing),
            timeValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            
            // Description Icon
            descriptionIcon.leadingAnchor.constraint(equalTo: locationValue.leadingAnchor),
            descriptionIcon.topAnchor.constraint(equalTo: timeValue.bottomAnchor, constant: standardSpacing),
            descriptionIcon.widthAnchor.constraint(equalToConstant: iconSize),
            descriptionIcon.heightAnchor.constraint(equalToConstant: iconSize),
            
            // Description Value
            descriptionValue.leadingAnchor.constraint(equalTo: descriptionIcon.trailingAnchor, constant: 5),
            descriptionValue.centerYAnchor.constraint(equalTo: descriptionIcon.centerYAnchor),
            descriptionValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            
            // INFO DIVIDER LINE
            infoDividerLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoDividerLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoDividerLine.topAnchor.constraint(equalTo: descriptionValue.bottomAnchor, constant: standardSpacing),
            infoDividerLine.heightAnchor.constraint(equalToConstant: dividerHeight),
            
            // Current Time Label
            currentTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingMargin),
            currentTimeLabel.topAnchor.constraint(equalTo: infoDividerLine.bottomAnchor, constant: standardSpacing),
            
            // Local Time Label
            localTimeLabel.leadingAnchor.constraint(equalTo: currentTimeLabel.leadingAnchor),
            localTimeLabel.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: standardSpacing),
            
            // Time Remaining Label
            timeRemainingLabel.leadingAnchor.constraint(equalTo: currentTimeLabel.leadingAnchor),
            timeRemainingLabel.topAnchor.constraint(equalTo: localTimeLabel.bottomAnchor, constant: standardSpacing),
            timeRemainingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardSpacing),
            
            // Current Time Icon
            currentTimeIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -160),
            currentTimeIcon.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor),
            currentTimeIcon.widthAnchor.constraint(equalToConstant: iconSize),
            currentTimeIcon.heightAnchor.constraint(equalToConstant: iconSize),
            
            // Current Time Value
            currentTimeValue.leadingAnchor.constraint(equalTo: currentTimeIcon.trailingAnchor, constant: 4.0),
            currentTimeValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            currentTimeValue.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor),
            
            // Local Time Icon
            localTimeIcon.trailingAnchor.constraint(equalTo: currentTimeIcon.trailingAnchor),
            localTimeIcon.centerYAnchor.constraint(equalTo: localTimeLabel.centerYAnchor),
            localTimeIcon.widthAnchor.constraint(equalToConstant: iconSize),
            localTimeIcon.heightAnchor.constraint(equalToConstant: iconSize),
            
            // Local Time Value
            localTimeValue.leadingAnchor.constraint(equalTo: localTimeIcon.trailingAnchor, constant: 4.0),
            localTimeValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            localTimeValue.centerYAnchor.constraint(equalTo: localTimeLabel.centerYAnchor),
            
            // Time Remaining Icon
            timeRemainingIcon.trailingAnchor.constraint(equalTo: currentTimeIcon.trailingAnchor),
            timeRemainingIcon.centerYAnchor.constraint(equalTo: timeRemainingLabel.centerYAnchor),
            timeRemainingIcon.widthAnchor.constraint(equalToConstant: iconSize),
            timeRemainingIcon.heightAnchor.constraint(equalToConstant: iconSize),
            
            // Time Remaining Value
            timeRemainingValue.leadingAnchor.constraint(equalTo: timeRemainingIcon.trailingAnchor, constant: 4.0),
            timeRemainingValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin),
            timeRemainingValue.centerYAnchor.constraint(equalTo: timeRemainingLabel.centerYAnchor)
        ])
        
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: timeRemainingLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let views = [
            locationValue, dateValue, timeValue, descriptionValue,
            topDividerLine, infoDividerLine,
            currentTimeLabel, localTimeLabel, timeRemainingLabel,
            currentTimeValue, localTimeValue, timeRemainingValue,
            currentTimeIcon, localTimeIcon, descriptionIcon, timeRemainingIcon
        ]
        
        for view in views {
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
}