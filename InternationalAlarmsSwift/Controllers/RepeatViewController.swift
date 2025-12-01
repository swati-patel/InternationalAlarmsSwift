//
//  RepeatViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  RepeatViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit

typealias RepeatSelectionCompletionBlock = (String) -> Void

class RepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var repeatsTable: UITableView!
    
    var selectedDate: Date?
    var selectedAlarmRepeatValue: String?
    
    var completionBlock: RepeatSelectionCompletionBlock?
    
    private var displayNameToValueMap: [String: String] = [:]
    private static var valueToDisplayNameMap: [String: String] = [:]
    private static var valueToShortDisplayNameMap: [String: String] = [:]
    private var displayNames: [String] = []
    
    func initOnce() {
        repeatsTable.delegate = self
        repeatsTable.dataSource = self
        
        repeatsTable.backgroundColor = AppColors.darkGrayBackgroundColor()
        view.backgroundColor = AppColors.mainBackgroundColor()
        
        repeatsTable.layer.cornerRadius = 12
        repeatsTable.clipsToBounds = true
        
        title = "Select Alarm Sound"
        
        let backButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(backPushed)
        )
        navigationItem.leftBarButtonItem = backButtonItem
        
        repeatsTable.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repeatsTable.reloadData()
    }
    
    func initDisplayNames(_ date: Date) {
        let calendar = Calendar.current
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dayOfWeek = dayFormatter.string(from: date)
        
        let components = calendar.dateComponents([.day], from: date)
        let dayOfMonth = components.day ?? 1
        
        let weeklyString = "Weekly (Every \(dayOfWeek))"
        
        let ordinalSuffix = ordinalSuffix(forDay: dayOfMonth)
        let monthlyString: String
        
        if dayOfMonth >= 29 {
            monthlyString = "Monthly (Every \(dayOfMonth)\(ordinalSuffix), or last day if unavailable)"
        } else {
            monthlyString = "Monthly (Every \(dayOfMonth)\(ordinalSuffix))"
        }
        
        RepeatViewController.valueToDisplayNameMap = [
            "none": "None",
            "daily": "Daily",
            "yearly": "Yearly"
        ]
        
        RepeatViewController.valueToDisplayNameMap["weekly"] = weeklyString
        RepeatViewController.valueToDisplayNameMap["monthly"] = monthlyString
        
        displayNames = []
        
        let orderedKeys = ["none", "daily", "weekly", "monthly", "yearly"]
        
        for key in orderedKeys {
            if let displayValue = RepeatViewController.valueToDisplayNameMap[key] {
                displayNames.append(displayValue)
            }
        }
        
        displayNameToValueMap = [:]
        for (value, displayName) in RepeatViewController.valueToDisplayNameMap {
            displayNameToValueMap[displayName] = value
        }
        
        print("displayNameToValueMAP: \(displayNameToValueMap)")
        print("valueToDisplayNameMAP: \(RepeatViewController.valueToDisplayNameMap)")
    }
    
    static func initShortDisplayNames() {
        valueToShortDisplayNameMap = [
            "none": "None",
            "daily": "Daily",
            "weekly": "Weekly",
            "monthly": "Monthly",
            "yearly": "Yearly"
        ]
    }
    
    static func displayNameToValue(_ displayName: String) -> String? {
        return valueToDisplayNameMap[displayName]
    }
    
    static func valueToDisplayName(_ value: String) -> String {
        if valueToShortDisplayNameMap.isEmpty {
            initShortDisplayNames()
        }
        print("valueToDisplayName: \(value)")
        print("valueToShortDisplayNameMap here: \(valueToShortDisplayNameMap)")
        return valueToShortDisplayNameMap[value] ?? ""
    }
    
    static func defaultValue() -> String {
        return "none"
    }
    
    static func isDefaultValue(_ value: String?) -> Bool {
        return value == "none"
    }
    
    func ordinalSuffix(forDay day: Int) -> String {
        if day >= 11 && day <= 13 {
            return "th"
        }
        
        switch day % 10 {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        default:
            return "th"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initOnce()
        
        if let date = selectedDate {
            initDisplayNames(date)
        }
        
        title = "Repeat Alarm"
        
        let backButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(backPushed)
        )
        navigationItem.leftBarButtonItem = backButtonItem
        
        CommonUIItems.styleHelpButton(button: helpButton, target: self, action: #selector(showInfoModal(_:)))
    }
    
    @objc func showInfoModal(_ sender: Any) {
        let infoVC = UIViewController()
        infoVC.view.backgroundColor = AppColors.mainBackgroundColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        infoVC.view.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "CAN'T FIND YOUR LOCATION?"
        titleLabel.font = AppFonts.headerTitleFont()
        titleLabel.textColor = AppColors.accentBlueColor()
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let contentText = UITextView()
        contentText.backgroundColor = .clear
        contentText.textColor = AppColors.primaryTextColor()
        contentText.font = AppFonts.smallRegularFont()
        contentText.isEditable = false
        contentText.isScrollEnabled = true
        contentText.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString()
        
        CommonUIItems.appendInfoBullet("Results appear as you type", toString: attributedText)
        CommonUIItems.appendInfoBullet("Start typing your city name: e.g. london", toString: attributedText)
        CommonUIItems.appendInfoBullet("If you don't see your location, start typing the country: e.g. london united kingdom", toString: attributedText)
        CommonUIItems.appendInfoBullet("Make sure to check your spelling", toString: attributedText)
        
        CommonUIItems.appendInfoSection("FEEDBACK", toString: attributedText)
        CommonUIItems.appendInfoBullet("Send feedback or questions to: swati_patel@icloud.com", toString: attributedText)
        
        contentText.attributedText = attributedText
        containerView.addSubview(contentText)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = AppColors.accentBlueColor()
        closeButton.layer.cornerRadius = 8.0
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissInfoVC(_:)), for: .touchUpInside)
        containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: infoVC.view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: infoVC.view.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: infoVC.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            contentText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentText.heightAnchor.constraint(equalToConstant: 240),
            
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            closeButton.topAnchor.constraint(equalTo: contentText.bottomAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            containerView.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20)
        ])
        
        infoVC.modalPresentationStyle = .pageSheet
        present(infoVC, animated: true, completion: nil)
    }
    
    @objc func backPushed() {
        print("repeatController: \(selectedAlarmRepeatValue ?? "")")
        if let repeatValue = selectedAlarmRepeatValue {
            didSelectRepeatValue(repeatValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissInfoVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectRepeatValue(_ repeatValue: String) {
        completionBlock?(repeatValue)
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        guard let cell = cell else { return UITableViewCell() }
        
        cell.textLabel?.text = displayNames[indexPath.row]
        cell.textLabel?.textColor = AppColors.primaryTextColor()
        cell.backgroundColor = repeatsTable.backgroundColor
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = AppColors.slightlyLighterNavySlateColor()
        cell.selectedBackgroundView = selectionColor
        cell.textLabel?.highlightedTextColor = AppColors.brightBlueColor()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.textLabel?.font = AppFonts.mediumFont()
        }
        
        if let selectedValue = selectedAlarmRepeatValue,
           let selectedDisplayName = RepeatViewController.valueToDisplayNameMap[selectedValue],
           let selectedIndex = displayNames.firstIndex(of: selectedDisplayName) {
            cell.accessoryType = (selectedIndex == indexPath.row) ? .checkmark : .none
        } else {
            cell.accessoryType = .none
        }
        
        UITableViewCell.appearance().tintColor = AppColors.brightBlueColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayNameToValueMap.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected: \(displayNames[indexPath.row])")
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        for i in 0..<displayNames.count {
            if i != indexPath.row {
                let otherIndexPath = IndexPath(row: i, section: 0)
                tableView.cellForRow(at: otherIndexPath)?.accessoryType = .none
            }
        }
        
        guard let selectedRepeat = cell?.textLabel?.text else { return }
        
        print("selectedRepeat: \(selectedRepeat)")
        
        selectedAlarmRepeatValue = displayNameToValueMap[selectedRepeat]
        print("selectedRepeatValue: \(selectedAlarmRepeatValue ?? "")")
    }
}