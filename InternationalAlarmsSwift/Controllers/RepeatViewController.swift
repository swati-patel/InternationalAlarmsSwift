//
//  RepeatViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//

import UIKit

typealias RepeatSelectionCompletionBlock = (String) -> Void

class RepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var repeatsTable: UITableView!
    
    var selectedDate: Date?
    var selectedAlarmRepeatValue: String? // Receives comma-separated weekdays or "none"
    
    var completionBlock: RepeatSelectionCompletionBlock?
    
    // Changed from String to Set<String>
    private var selectedWeekdays: Set<String> = []
    
    // Ordered weekday list for display
    private let weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    private let weekdayDisplayNames = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday"]
    
    func initOnce() {
        repeatsTable.delegate = self
        repeatsTable.dataSource = self
        
        repeatsTable.backgroundColor = AppColors.darkGrayBackgroundColor()
        view.backgroundColor = AppColors.mainBackgroundColor()
        
        repeatsTable.layer.cornerRadius = 12
        repeatsTable.clipsToBounds = true
        
        repeatsTable.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repeatsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initOnce()
        
        // Parse incoming selectedAlarmRepeatValue into Set
        if let repeatValue = selectedAlarmRepeatValue, repeatValue != "none" {
            selectedWeekdays = Set(repeatValue.split(separator: ",").map { String($0).lowercased() })
        }
        
        title = "Repeat"
        
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
        titleLabel.text = "REPEAT ALARM"
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
        
        CommonUIItems.appendInfoBullet("Select one or more days for your alarm to repeat", toString: attributedText)
        CommonUIItems.appendInfoBullet("Tap a day to toggle it on/off", toString: attributedText)
        CommonUIItems.appendInfoBullet("If no days are selected, alarm will fire once", toString: attributedText)
        
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
        // Convert Set back to comma-separated string
        let repeatValue = selectedWeekdays.isEmpty ? "none" : selectedWeekdays.sorted().joined(separator: ",")
        print("Returning repeat value: \(repeatValue)")
        completionBlock?(repeatValue)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissInfoVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        guard let cell = cell else { return UITableViewCell() }
        
        cell.textLabel?.text = weekdayDisplayNames[indexPath.row]
        cell.textLabel?.textColor = AppColors.primaryTextColor()
        cell.backgroundColor = repeatsTable.backgroundColor
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = AppColors.slightlyLighterNavySlateColor()
        cell.selectedBackgroundView = selectionColor
        cell.textLabel?.highlightedTextColor = AppColors.brightBlueColor()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.textLabel?.font = AppFonts.mediumFont()
        }
        
        // Show checkmark if this weekday is selected
        let weekday = weekdays[indexPath.row]
        cell.accessoryType = selectedWeekdays.contains(weekday) ? .checkmark : .none
        
        UITableViewCell.appearance().tintColor = AppColors.brightBlueColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weekday = weekdays[indexPath.row]
        
        // Toggle selection
        if selectedWeekdays.contains(weekday) {
            selectedWeekdays.remove(weekday)
        } else {
            selectedWeekdays.insert(weekday)
        }
        
        // Deselect row immediately (so it doesn't stay highlighted)
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Reload just this cell to update checkmark
        tableView.reloadRows(at: [indexPath], with: .none)
        //tableView.reloadRows(at: [indexPath], animated: false)
        
        print("Selected weekdays: \(selectedWeekdays)")
    }
    
    // MARK: - Static helpers for backward compatibility
    
    static func valueToDisplayName(_ value: String) -> String {
        if value == "none" || value.isEmpty {
            return "Never"
        }
        
        // For comma-separated weekdays, show short summary
        let weekdays = value.split(separator: ",").map { String($0).lowercased() }
        
        if weekdays.count == 7 {
            return "Every Day"
        } else if weekdays.count == 1 {
            return "Every \(weekdays[0].capitalized)"
        } else {
            // Show abbreviated: "Mon, Wed, Fri"
            let abbreviated = weekdays.map { String($0.prefix(3)).capitalized }
            return abbreviated.joined(separator: ", ")
        }
    }
    
    static func defaultValue() -> String {
        return "none"
    }
    
    static func isDefaultValue(_ value: String?) -> Bool {
        return value == "none" || value == nil || value?.isEmpty == true
    }
}
