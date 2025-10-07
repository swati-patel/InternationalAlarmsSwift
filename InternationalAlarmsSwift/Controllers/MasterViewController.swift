//
//  MasterViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  MasterViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit
import QuartzCore

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataController: InternationalAlarmDataController!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var alarmsTable: UITableView!
    
    var selectViewController: SelectLocationViewController?
    var descriptionPresent = false
    var emptyView: UIView?
    var alarmPickerViewController: AlarmPickerViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = NSLocalizedString("Master", comment: "Master")
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func enteringForeground() {
        let passedAlarms = getListOfPassedAlarms()
        checkForPassedAlarms()
        alarmsTable.reloadData()
        showPassedAlarms(passedAlarms: passedAlarms)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation bar
        navigationController?.navigationBar.backgroundColor = AppColors.mainBackgroundColor()
        navigationController?.navigationBar.isTranslucent = true
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = AppColors.mainBackgroundColor()
            appearance.titleTextAttributes = [.foregroundColor: AppColors.primaryTextColor()]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        }
        
        emptyView = createEmptyStateView()
        
        // Register for foreground notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enteringForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        self.title = "World Alarms"
        
        self.dataController = InternationalAlarmDataController()
        
        // Edit button
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Add button
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(insertNewObject(_:))
        )
        
        // Info button styling
        infoButton.setTitle("Help", for: .normal)
        infoButton.setTitleColor(.white, for: .normal)
        infoButton.backgroundColor = AppColors.brightBlueColor()
        infoButton.layer.borderWidth = 1.0
        infoButton.layer.borderColor = AppColors.accentBlueColor().cgColor
        infoButton.layer.cornerRadius = 10.0
        infoButton.addTarget(self, action: #selector(showInfoModal(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [addButton]
        
        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView(_:)), for: .valueChanged)
        alarmsTable.refreshControl = refreshControl
        
        alarmsTable.delegate = self
        alarmsTable.dataSource = self
        
        checkTableEmpty()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnTableView(_:)))
        alarmsTable.addGestureRecognizer(tap)
        alarmsTable.tableFooterView = UIView(frame: .zero)
        
        alarmsTable.estimatedRowHeight = 250
        alarmsTable.rowHeight = UITableView.automaticDimension
        
        view.backgroundColor = AppColors.mainBackgroundColor()
        alarmsTable.backgroundColor = AppColors.mainBackgroundColor()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataController.initialiseDefaultDataList()
        alarmsTable.reloadData()
        checkTableEmpty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let passedAlarms = getListOfPassedAlarms()
        checkForPassedAlarms()
        alarmsTable.reloadData()
        showPassedAlarms(passedAlarms: passedAlarms)
    }
    
    func showPassedAlarms(passedAlarms: [InternationalAlarm]) {
        if passedAlarms.isEmpty {
            return
        }
        
        let alertController = UIAlertController(
            title: "Passed Alarms (Deleted)",
            message: nil,
            preferredStyle: .alert
        )
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        
        var alarmDetails = "\n"
        
        for alarm in passedAlarms {
            var desc = alarm.description
            if desc.isEmpty {
                desc = "My Event"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            alarmDetails += desc + "\n"
            alarmDetails += "\(alarm.city?.name ?? ""), \(alarm.country?.name ?? "")\n"
            alarmDetails += dateFormatter.string(from: alarm.alarm.date) + "\n\n"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2.0
        
        let attributedMessage = NSMutableAttributedString(
            string: alarmDetails,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        present(alertController, animated: true) {
            if let firstSubview = alertController.view.subviews.first,
               let alertContentView = firstSubview.subviews.first {
                for subview in alertContentView.subviews {
                    subview.backgroundColor = AppColors.secondaryTextColor()
                }
            }
        }
    }
    
    @objc func insertNewObject(_ sender: Any) {
        if selectViewController == nil {
            selectViewController = SelectLocationViewController(nibName: "SelectLocationViewController", bundle: nil)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: nil,
            action: nil
        )
        
        if let selectVC = selectViewController {
            navigationController?.pushViewController(selectVC, animated: true)
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        checkTableEmpty()
        return dataController.countOfList()
    }
    
    func checkForPassedAlarms() {
        var passed = false
        let listCount = dataController.countOfList()
        
        for i in stride(from: listCount - 1, through: 0, by: -1) {
            let alarm = dataController.objectInList(at: i)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            let date = alarm.alarm.date
            
            let timezone: String
            if alarm.country != nil {
                timezone = alarm.city?.timezone ?? "GMT"
            } else {
                timezone = "GMT"
            }
            
            formatter.timeZone = TimeZone(identifier: timezone)
            
            let now = Date()
            let calendar = Calendar(identifier: .gregorian)
            
            var components = Calendar.current.dateComponents(
                [.minute, .hour, .day, .month, .year],
                from: date
            )
            
            components.timeZone = TimeZone(identifier: timezone)
            components.calendar = calendar
            
            guard let newDate = components.date else { continue }
            
            passed = (now.compare(newDate) == .orderedDescending)
            
            if passed {
                print("Alarm has passed! Removing from list!!")
                dataController.removeObjectFromMasterInternationalAlarmList(at: i)
            }
        }
    }
    
    func getListOfPassedAlarms() -> [InternationalAlarm] {
        var passedAlarms: [InternationalAlarm] = []
        let listCount = dataController.countOfList()
        
        for i in stride(from: listCount - 1, through: 0, by: -1) {
            let alarm = dataController.objectInList(at: i)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            let date = alarm.alarm.date
            
            let timezone: String
            if alarm.country != nil {
                timezone = alarm.city?.timezone ?? "GMT"
            } else {
                timezone = "GMT"
            }
            
            formatter.timeZone = TimeZone(identifier: timezone)
            
            let now = Date()
            let calendar = Calendar(identifier: .gregorian)
            
            var components = Calendar.current.dateComponents(
                [.minute, .hour, .day, .month, .year],
                from: date
            )
            
            components.timeZone = TimeZone(identifier: timezone)
            components.calendar = calendar
            
            guard let newDate = components.date else { continue }
            
            let passed = (now.compare(newDate) == .orderedDescending)
            
            if passed {
                passedAlarms.append(alarm)
            }
        }
        
        return passedAlarms
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkTableEmpty()
        return 1
    }
    
    func getLocationFromAlarm(alarmAtIndex: InternationalAlarm) -> String {
        let utcMode = (alarmAtIndex.country == nil)
        var location = ""
        
        if !utcMode {
            var cityName = alarmAtIndex.city?.name ?? ""
            let countryName = alarmAtIndex.country?.name ?? ""
            
            if cityName.count > 0 {
                if cityName.contains(",") {
                    cityName = cityName.components(separatedBy: ",")[0]
                }
            } else {
                cityName += " \(countryName)"
            }
            
            location = "\(cityName),\(countryName)"
        } else {
            location = "UTC"
        }
        
        return location
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkTableEmpty()
        
        let cellIdentifier = "alarmCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AlarmListCellController
        
        if cell == nil {
            tableView.register(
                UINib(nibName: "AlarmListCell", bundle: nil),
                forCellReuseIdentifier: cellIdentifier
            )
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AlarmListCellController
        }
        
        guard let cell = cell else { return UITableViewCell() }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        
        let alarmAtIndex = dataController.objectInList(at: indexPath.section)
        let date = alarmAtIndex.alarm.date
        let formatter = DateFormatter()
        
        let timezone: String
        if alarmAtIndex.country != nil {
            timezone = alarmAtIndex.city?.timezone ?? "GMT"
        } else {
            timezone = "GMT"
        }
        
        formatter.timeZone = TimeZone(identifier: timezone)
        
        let calendar = Calendar(identifier: .gregorian)
        var components = Calendar.current.dateComponents(
            [.minute, .hour, .day, .month, .year],
            from: date
        )
        
        components.timeZone = TimeZone(identifier: timezone)
        components.calendar = calendar
        
        guard let newDate = components.date else { return cell }
        
        let locationTime = DateUtils.getFormattedTime(formatter: formatter, date: newDate)
        let locationDay = DateUtils.getFormattedDate(formatter: formatter, style: .full, date: newDate)
        
        descriptionPresent = !alarmAtIndex.description.isEmpty
        
        // Elements & styling
        cell.topDividerLine.backgroundColor = AppColors.accentBlueColor()
        cell.infoDividerLine.backgroundColor = AppColors.secondaryTextColor().withAlphaComponent(0.2)
        
        let locationLabel = cell.locationValue
        locationLabel?.text = getLocationFromAlarm(alarmAtIndex: alarmAtIndex)
        locationLabel?.textColor = AppColors.accentBlueColor()
        locationLabel?.font = AppFonts.largeMediumFont()
        
        let dateLabel = cell.dateValue
        dateLabel?.text = locationDay
        dateLabel?.textColor = AppColors.secondaryTextColor()
        dateLabel?.font = AppFonts.mediumFont()
        
        let timeLabel = cell.timeValue
        timeLabel?.text = locationTime
        timeLabel?.textColor = AppColors.primaryTextColor()
        timeLabel?.font = AppFonts.extraLargeFont()
        
        if !RepeatViewController.isDefaultValue(alarmAtIndex.alarm.repeatValue) {
            timeLabel?.text = "\(timeLabel?.text ?? "") (\(alarmAtIndex.alarm.repeatValue ?? ""))"
        }
        
        let descriptionLabel = cell.descriptionValue
        descriptionLabel?.textColor = AppColors.lightBlueColor()
        descriptionLabel?.font = AppFonts.smallRegularFont()
        
        if descriptionPresent {
            descriptionLabel?.text = alarmAtIndex.description
        } else {
            descriptionLabel?.text = "My event"
        }
        
        let currentTimeValueLabel = cell.currentTimeValue
        currentTimeValueLabel?.text = DateUtils.getCurrentTimeInOtherZone(timezone: timezone)
        currentTimeValueLabel?.textColor = AppColors.primaryTextColor()
        currentTimeValueLabel?.font = AppFonts.smallRegularFont()
        
        let currentTimeLabel = cell.currentTimeLabel
        currentTimeLabel?.textColor = AppColors.secondaryTextColor()
        currentTimeLabel?.font = AppFonts.smallRegularFont()
        
        var isDay = DateUtils.isDayInTimeZone(timeZone: timezone)
        cell.currentTimeIcon.image = ImageUtils.imageForTimeOfDay(isDay)
        
        let localTimeValueLabel = cell.localTimeValue
        let localTimeWillBe = DateUtils.getLocalTimeInOtherZone(timezone: timezone, forDate: alarmAtIndex.alarm.date)
        localTimeValueLabel?.text = DateUtils.stringFromDateShortStyle(newDate: localTimeWillBe)
        localTimeValueLabel?.textColor = AppColors.primaryTextColor()
        localTimeValueLabel?.font = AppFonts.smallRegularFont()
        
        let localTimeLabel = cell.localTimeLabel
        localTimeLabel?.textColor = AppColors.secondaryTextColor()
        localTimeLabel?.font = AppFonts.smallRegularFont()
        
        isDay = DateUtils.isDayForTime(date: localTimeWillBe)
        cell.localTimeIcon.image = ImageUtils.imageForTimeOfDay(isDay)
        
        let currentTime = Date()
        let daysRemainingText = DateUtils.daysBetweenDate2(fromDateTime: currentTime, andDate: localTimeWillBe)
        let timeRemainingValueLabel = cell.timeRemainingValue
        timeRemainingValueLabel?.text = daysRemainingText
        timeRemainingValueLabel?.textColor = AppColors.primaryTextColor()
        timeRemainingValueLabel?.font = AppFonts.smallRegularFont()
        
        let timeRemainingLabel = cell.timeRemainingLabel
        timeRemainingLabel?.textColor = AppColors.secondaryTextColor()
        timeRemainingLabel?.font = AppFonts.smallRegularFont()
        
        cell.backgroundColor = AppColors.mainBackgroundColor()
        let selectionColor = UIView()
        selectionColor.backgroundColor = AppColors.slightlyLighterNavySlateColor()
        cell.selectedBackgroundView = selectionColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataController.removeObjectFromMasterInternationalAlarmList(at: indexPath.section)
            alarmsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func refreshView(_ refresh: UIRefreshControl) {
        checkTableEmpty()
        
        let passedAlarms = getListOfPassedAlarms()
        if !passedAlarms.isEmpty {
            checkForPassedAlarms()
        }
        showPassedAlarms(passedAlarms: passedAlarms)
        alarmsTable.reloadData()
        
        refresh.endRefreshing()
    }
    
    func emptyTable() -> Bool {
        return dataController.countOfList() == 0
    }
    
    func checkTableEmpty() {
        if emptyTable() {
            alarmsTable.backgroundView = emptyView
            alarmsTable.separatorStyle = .none
        } else {
            alarmsTable.backgroundView = nil
            alarmsTable.separatorStyle = .singleLine
        }
    }
    
    @objc func didTapOnTableView(_ recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: alarmsTable)
        let indexPath = alarmsTable.indexPathForRow(at: tapLocation)
        
        if indexPath != nil {
            recognizer.cancelsTouchesInView = false
        }
        if emptyTable() {
            insertNewObject(self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alarmAtIndex = dataController.objectInList(at: indexPath.section)
        switchToAlarmView(alarm: alarmAtIndex)
    }
    
    func switchToAlarmView(alarm: InternationalAlarm) {
        if alarmPickerViewController == nil {
            alarmPickerViewController = AlarmPickerViewController(nibName: "AlarmPickerView", bundle: nil)
        }
        
        guard let alarmPickerVC = alarmPickerViewController else { return }
        
        let utcMode = (alarm.country == nil)
        
        let city = alarm.city
        let country = alarm.country
        
        var cityId = city?.cityId ?? 0
        let countryId = country?.countryId ?? 0
        
        if !utcMode {
            alarmPickerVC.city = alarm.city
            alarmPickerVC.country = alarm.country
            
            if city == nil {
                cityId = 0
            }
            alarmPickerVC.cityId = cityId
            alarmPickerVC.countryId = countryId
        } else {
            alarmPickerVC.utcMode = true
        }
        
        alarmPickerVC.editMode = true
        alarmPickerVC.deleteAlarmID = alarm.alarm.alarmId
        alarmPickerVC.date = alarm.alarm.date
        alarmPickerVC.alarmDesc = alarm.alarm.description
        alarmPickerVC.alarmSound = alarm.alarm.sound
        print("In MasterViewController:switchToAlarmView alarm.alarm.repeatValue: \(alarm.alarm.repeatValue ?? "")")
        alarmPickerVC.alarmRepeatValue = alarm.alarm.repeatValue
        
        navigationController?.pushViewController(alarmPickerVC, animated: true)
        
        alarmPickerViewController = nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func createEmptyStateView() -> UIView {
        let emptyView = UIView(frame: alarmsTable.bounds)
        
        // Clock icon
        let clockIcon = UIImageView()
        clockIcon.image = UIImage(systemName: "clock")
        clockIcon.tintColor = AppColors.accentBlueColor()
        clockIcon.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(clockIcon)
        
        // Message label
        let messageLabel = UILabel()
        messageLabel.text = "No active alarms"
        messageLabel.textColor = AppColors.primaryTextColor()
        messageLabel.font = AppFonts.extraLargeFont()
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(messageLabel)
        
        // Instruction label
        let instructionLabel = UILabel()
        instructionLabel.text = "Tap the + button to add a new location and schedule your next international call"
        instructionLabel.textColor = AppColors.secondaryTextColor()
        instructionLabel.font = AppFonts.smallRegularFont()
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(instructionLabel)
        
        NSLayoutConstraint.activate([
            clockIcon.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            clockIcon.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 100),
            clockIcon.widthAnchor.constraint(equalToConstant: 64),
            clockIcon.heightAnchor.constraint(equalToConstant: 64),
            
            messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: clockIcon.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            
            instructionLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 40),
            instructionLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -40)
        ])
        
        return emptyView
    }
    
    @objc func showInfoModal(_ sender: Any) {
        let infoVC = UIViewController()
        infoVC.view.backgroundColor = AppColors.mainBackgroundColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        infoVC.view.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "World Alarms"
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
        
        CommonUIItems.appendInfoSection("ABOUT", toString: attributedText)
        CommonUIItems.appendInfoBullet("Set an alarm in almost any timezone in the world", toString: attributedText)
        CommonUIItems.appendInfoBullet("No internet connection required (works in airplane mode)", toString: attributedText)
        
        CommonUIItems.appendInfoSection("USAGE", toString: attributedText)
        CommonUIItems.appendInfoBullet("Tap + to add a new alarm and select a location and time", toString: attributedText)
        CommonUIItems.appendInfoBullet("Ensure your device is not in silent mode to hear alarms", toString: attributedText)
        CommonUIItems.appendInfoBullet("Allow notifications in Settings for alarms to function properly", toString: attributedText)
        
        CommonUIItems.appendInfoSection("APPLE WATCH USERS", toString: attributedText)
        CommonUIItems.appendInfoBullet("If you want to hear alarms when your device is locked, disable notification mirroring for this app in the Watch app", toString: attributedText)
        
        CommonUIItems.appendInfoSection("DISPLAY SETTINGS", toString: attributedText)
        CommonUIItems.appendInfoBullet("For the best experience, use Standard display mode instead of Zoomed display mode in your iPhone settings.", toString: attributedText)
        
        CommonUIItems.appendInfoSection("UPCOMING FEATURES", toString: attributedText)
        CommonUIItems.appendInfoBullet("Repeating alarms will be added in a future update", toString: attributedText)
        CommonUIItems.appendInfoBullet("Full support for all display modes", toString: attributedText)
        
        CommonUIItems.appendInfoSection("FEEDBACK", toString: attributedText)
        CommonUIItems.appendInfoBullet("Please review in the app store", toString: attributedText)
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
            containerView.bottomAnchor.constraint(equalTo: infoVC.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            contentText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentText.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20),
            
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        infoVC.modalPresentationStyle = .pageSheet
        present(infoVC, animated: true, completion: nil)
    }
    
    @objc func dismissInfoVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}