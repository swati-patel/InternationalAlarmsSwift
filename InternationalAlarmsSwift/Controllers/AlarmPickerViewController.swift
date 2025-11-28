//
//  AlarmPickerViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  AlarmPickerViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit
import UserNotifications

class AlarmPickerViewController: UIViewController, UITextFieldDelegate {
    
    var utcMode = false
    var city: City?
    var cityId = 0
    var country: Country?
    var countryId = 0
    var editMode = false
    var date: Date?
    var alarmDesc: String?
    var alarmSound: String?
    var alarmRepeatValue: String?
    var deleteAlarmID = 0
    var cancelAlarmUUid = ""
    
    @IBOutlet weak var descText: UITextField!
    @IBOutlet weak var soundSelected: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatValue: UILabel!
    @IBOutlet weak var bottomDividerLine: UIView!
    @IBOutlet weak var localTimeLabel: UILabel!
    @IBOutlet weak var localTimeIcon: UIImageView!
    @IBOutlet weak var localTimeValue: UILabel!
    
    var soundPickerViewController: SoundPickerViewController?
    var repeatViewController: RepeatViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = "Select Alarm"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTapGesture(selector: Selector, toLabel label: UILabel) {
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descText.delegate = self
        navigationItem.hidesBackButton = true
        
        createBarButtonItems()
        
        addTapGesture(selector: #selector(launchSoundPicker), toLabel: soundSelected)
        addTapGesture(selector: #selector(launchRepeatView), toLabel: repeatValue)
        
        view.backgroundColor = AppColors.mainBackgroundColor()
        
        styleDatePicker(datePicker, withMode: .date)
        styleDatePicker(timePicker, withMode: .time)
        
        styleLabel(dateLabel, withText: "Date", font: AppFonts.largeMediumFont())
        styleLabel(timeLabel, withText: "Time", font: AppFonts.largeMediumFont())
        styleLabel(repeatLabel, withText: "Repeat", font: AppFonts.largeMediumFont())
        
        repeatValue.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        divider.backgroundColor = AppColors.darkGrayBackgroundColor()
        bottomDividerLine.backgroundColor = AppColors.darkGrayBackgroundColor()
        countryLabel.textColor = AppColors.accentBlueColor()
        
        var location: String?
        
        if let city = city {
            var cityName = city.name
            
            if cityName.contains(",") {
                cityName = cityName.components(separatedBy: ",")[0]
            }
            
            countryLabel.numberOfLines = 1
            countryLabel.text = "\(cityName), \(country?.name ?? "")"
            location = cityName
        }
        
        if utcMode {
            location = "UTC"
            countryLabel.text = "UTC"
        }
        
        styleLabel(descLabel, withText: "Event", font: AppFonts.mediumFont())
        styleLabel(soundLabel, withText: "Sound", font: AppFonts.mediumFont())
        styleLabel(localTimeLabel, withText: "Local Time Will Be", font: AppFonts.mediumFont())
        localTimeValue.font = AppFonts.mediumFont()
        
        applyBaseStyling(to: repeatValue)
        repeatValue.font = AppFonts.mediumFontLarger()
        repeatValue.textColor = AppColors.primaryTextColor()
        
        styleTextField(descText, withTextColor: AppColors.primaryTextColor(), font: AppFonts.mediumFont())
        styleLabel(soundSelected, font: AppFonts.mediumFont())
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: descText.frame.height))
        descText.leftView = paddingView
        descText.leftViewMode = .always
        
        if alarmSound == nil {
            alarmSound = SoundPickerViewController.defaultValue()
        }
        if alarmRepeatValue == nil {
            print("HELLO WE ARE HERE")
            alarmRepeatValue = RepeatViewController.defaultValue()
        }
        
        print("IN ALARMPICKER VIEWDIDLOAD: alarmRepeatValue: \(alarmRepeatValue ?? "")")
        
        repeatValue.text = "  \(RepeatViewController.valueToDisplayName(alarmRepeatValue ?? "")) >"
        
        print("IN ALARMPICKER VIEWDIDLOAD: alarmSound: \(alarmSound ?? "")")
        
        descText.attributedPlaceholder = NSAttributedString(
            string: "Event Name/Description",
            attributes: [.foregroundColor: AppColors.fadedVeryLightGrey()]
        )
        
        if editMode, let date = date {
            datePicker.date = date
            timePicker.date = date
            descText.text = alarmDesc
            soundSelected.text = "  \(SoundPickerViewController.fileNameToSoundName(alarmSound ?? "")) >"
        }
        
        setupConstraints()
        
        datePicker.addTarget(self, action: #selector(dateTimeValueChanged(_:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(dateTimeValueChanged(_:)), for: .valueChanged)
        
        updateLocalTimeDisplay()
    }
    
    func styleDatePicker(_ picker: UIDatePicker, withMode mode: UIDatePicker.Mode) {
        picker.datePickerMode = mode
        picker.preferredDatePickerStyle = .compact
        picker.backgroundColor = AppColors.mainBackgroundColor()
        picker.tintColor = AppColors.accentBlueColor()
        picker.overrideUserInterfaceStyle = .dark
    }
    
    func styleLabel(_ label: UILabel, withText text: String, font: UIFont) {
        label.text = text
        label.backgroundColor = AppColors.mainBackgroundColor()
        label.font = font
        label.textColor = AppColors.accentBlueColor()
    }
    
    func applyBaseStyling(to view: UIView) {
        view.backgroundColor = AppColors.darkGrayBackgroundColor()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
    }
    
    func styleTextField(_ textField: UITextField, withTextColor textColor: UIColor, font: UIFont) {
        textField.textColor = textColor
        textField.font = font
        applyBaseStyling(to: textField)
    }
    
    func styleLabel(_ label: UILabel, font: UIFont) {
        label.font = font
        applyBaseStyling(to: label)
    }
    
    func setupConstraints() {
        let views = [
            countryLabel, dateLabel, datePicker, timePicker, repeatLabel, repeatValue,
            timeLabel, divider, descLabel, descText, soundLabel, soundSelected,
            bottomDividerLine, localTimeLabel, localTimeIcon, localTimeValue
        ]
        
        for view in views {
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let leadingMargin: CGFloat = 20.0
        let trailingMargin: CGFloat = 20.0
        let standardSpacing: CGFloat = 15.0
        let dividerHeight: CGFloat = 1.0
        let labelWidth: CGFloat = 80.0
        
        NSLayoutConstraint.activate([
            countryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            countryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingMargin),
            countryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            dateLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: standardSpacing * 3.5),
            dateLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            
            datePicker.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10.0),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingMargin),
            datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: standardSpacing * 2),
            timeLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            
            timePicker.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10.0),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingMargin),
            timePicker.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            
            repeatLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            repeatLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: standardSpacing * 2),
            repeatLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            
            repeatValue.leadingAnchor.constraint(equalTo: repeatLabel.trailingAnchor, constant: 10.0),
            repeatValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingMargin),
            repeatValue.centerYAnchor.constraint(equalTo: repeatLabel.centerYAnchor),
            repeatValue.heightAnchor.constraint(equalToConstant: 40.0),
            
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: standardSpacing * 3),
            divider.heightAnchor.constraint(equalToConstant: dividerHeight),
            
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            descLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: standardSpacing * 3),
            descLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            
            descText.leadingAnchor.constraint(equalTo: descLabel.trailingAnchor, constant: 10.0),
            descText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingMargin),
            descText.centerYAnchor.constraint(equalTo: descLabel.centerYAnchor),
            descText.heightAnchor.constraint(equalToConstant: 40.0),
            
            soundLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor),
            soundLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: standardSpacing * 2.5),
            soundLabel.widthAnchor.constraint(equalTo: descLabel.widthAnchor),
            
            soundSelected.leadingAnchor.constraint(equalTo: descText.leadingAnchor),
            soundSelected.trailingAnchor.constraint(equalTo: descText.trailingAnchor),
            soundSelected.centerYAnchor.constraint(equalTo: soundLabel.centerYAnchor),
            soundSelected.heightAnchor.constraint(equalToConstant: 40.0),
            
            bottomDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomDividerLine.topAnchor.constraint(equalTo: soundLabel.bottomAnchor, constant: standardSpacing * 3),
            bottomDividerLine.heightAnchor.constraint(equalToConstant: dividerHeight),
            
            localTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            localTimeLabel.topAnchor.constraint(equalTo: bottomDividerLine.bottomAnchor, constant: standardSpacing * 2),
            
            localTimeIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin + 180),
            localTimeIcon.centerYAnchor.constraint(equalTo: localTimeLabel.centerYAnchor),
            localTimeIcon.widthAnchor.constraint(equalToConstant: 24.0),
            localTimeIcon.heightAnchor.constraint(equalToConstant: 24.0),
            
            localTimeValue.leadingAnchor.constraint(equalTo: localTimeIcon.trailingAnchor, constant: 5),
            localTimeValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingMargin),
            localTimeValue.centerYAnchor.constraint(equalTo: localTimeIcon.centerYAnchor)
        ])
    }
    
    @objc func dateTimeValueChanged(_ sender: Any) {
        updateLocalTimeDisplay()
    }
    
    func getDateTimeSelectedFromDatePicker() -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timePicker.date)
        
        var combinedComponents = dateComponents
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents) ?? Date()
    }
    
    func updateLocalTimeDisplay() {
        let selectedDate = getDateTimeSelectedFromDatePicker()
        print("updateLocalTimeDisplay: selectedDate: \(selectedDate)")
        
        let timezone: String
        if !utcMode {
            timezone = city?.timezone ?? "GMT"
        } else {
            timezone = "GMT"
        }
        
        let localTimeWillBe = DateUtils.getLocalTimeInOtherZone(timezone: timezone, forDate: selectedDate)
        localTimeValue.text = DateUtils.stringFromDateShortStyle(newDate: localTimeWillBe)
        localTimeValue.textColor = AppColors.primaryTextColor()
        localTimeValue.font = AppFonts.smallRegularFont()
        
        let isDay = DateUtils.isDayForTime(date: localTimeWillBe)
        localTimeIcon.image = ImageUtils.imageForTimeOfDay(isDay)
    }
    
    func createBarButtonItems() {
        let cancelButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(cancelPushed)
        )
        
        let saveButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveButtonPushed)
        )
        
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = editMode ? "Edit Alarm" : "New Alarm"
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        navigationItem.titleView = titleLabel
    }
    
    @objc func launchSoundPicker() {
        print("in launchSoundPicker")
        
        if soundPickerViewController == nil {
            soundPickerViewController = SoundPickerViewController(nibName: "SoundPickerView", bundle: nil)
        }
        
        soundPickerViewController?.selectedFilename = alarmSound
        
        soundPickerViewController?.completionBlock = { [weak self] selectedSoundFilename in
            guard let self = self else { return }
            self.alarmSound = selectedSoundFilename
            let sound = SoundPickerViewController.fileNameToSoundName(selectedSoundFilename)
            self.soundSelected.text = "  \(sound) >"
        }
        
        if let soundPickerVC = soundPickerViewController {
            navigationController?.pushViewController(soundPickerVC, animated: false)
        }
    }
    
    @objc func launchRepeatView() {
        print("in launchRepeatView")
        
        if repeatViewController == nil {
            repeatViewController = RepeatViewController(nibName: "RepeatView", bundle: nil)
        }
        
        repeatViewController?.selectedAlarmRepeatValue = alarmRepeatValue
        repeatViewController?.selectedDate = getDateTimeSelectedFromDatePicker()
        
        repeatViewController?.completionBlock = { [weak self] selectedRepeatVal in
            guard let self = self else { return }
            print("selectedRepeatVal: \(selectedRepeatVal)")
            self.alarmRepeatValue = selectedRepeatVal
            let displayVal = RepeatViewController.valueToDisplayName(selectedRepeatVal)
            print("displayVal: \(displayVal)")
            self.repeatValue.text = "  \(displayVal) >"
        }
        
        if let repeatVC = repeatViewController {
            navigationController?.pushViewController(repeatVC, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("In AlarmPickerController:viewWillDisappear")
        super.viewWillDisappear(animated)
        utcMode = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func cancelPushed() {
        utcMode = false
        datePicker.date = Date()
        timePicker.date = Date()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func saveButtonPushed() {
        Task {
            await saveAlarmAsync()
        }
    }

    private func saveAlarmAsync() async {
        print("saving alarm.......................")
        
        let timezone: String
        if !utcMode {
            timezone = city?.timezone ?? "GMT"
        } else {
            timezone = "GMT"
        }
        
        if timezone.isEmpty {
            let alert = UIAlertController(
                title: "Error",
                message: "Sorry no timezone information found for \(city?.name ?? ""), \(country?.name ?? "").",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            utcMode = false
            return
        }
        
        var selectedDate = getDateTimeSelectedFromDatePicker()
        print("selectedDate: \(selectedDate)")
        
        let dateFormatter = DateUtils.getDateFormatter()
        
        let time = floor(selectedDate.timeIntervalSinceReferenceDate / 60.0) * 60.0
        selectedDate = Date(timeIntervalSinceReferenceDate: time)
        
        let alarmStr = dateFormatter.string(from: selectedDate)
        
        var description = descText.text
        
        let intDf = DateUtils.getDateFormatterForTimezone(timezone: timezone)
        guard let intDate = intDf.date(from: alarmStr) else { return }
        
        let now = Date()
        
        if now.compare(intDate) == .orderedDescending {
            var msg = "Cannot select an alarm in the past.\nCurrent time in timezone selected is: \(dateFormatter.string(from: now))"
            msg += "\nAlarm selected was:\n\(dateFormatter.string(from: intDate))"
            
            let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            datePicker.timeZone = TimeZone.current
            return
        }
        
        print("saving alarm: alarmStr \(alarmStr) countryId: \(countryId) cityId: \(cityId)")
        
        if description != nil {
            description = description?.replacingOccurrences(of: "'", with: "''")
        }
        
       // var alarmId: Int
        
        print("saving REPEAT VAL:::::::::: \(alarmRepeatValue ?? "")")
        
        var uuid = ""
        do {
            uuid = try await AlarmPickerViewController.scheduleAlarm(intDate: intDate, countryId: countryId, cityId: cityId, description: description, sound: alarmSound, repeatVal: alarmRepeatValue)
            print("Alarm scheduled AND saved ")
        }
        catch {
            print("Failed to schedule or save alarm: \(error)")
        }
        
        
        // Save to database with UUID
        let alarmId = AlarmDao.saveAlarm(
            countryId: countryId,
            cityId: cityId,
            alarm: alarmStr,
            desc: description,
            sound: alarmSound,
            repeatVal: alarmRepeatValue,
            uuidVal: uuid
        )

        // delete from DB and cancel alarm
        if (editMode) {
            AlarmDao.deleteAlarm(withId: deleteAlarmID)
            // cancel alarm
            do {
                try await AlarmKitUtils.cancelAlarm(uuid: cancelAlarmUUid)
                print("Alarm successfully deleted and cancelled for edit")
            }
            catch {
                print("UNABLE TO CANCEL ALARM!!!!! " + cancelAlarmUUid)
            }
        }


        navigationController?.popToRootViewController(animated: true)
    }
    
    static func scheduleAlarm (
        intDate: Date,
        countryId: Int,
        cityId: Int,
        description: String?,
        sound: String?,
        repeatVal: String?
    ) async throws -> String {
        // Look up country and city names from IDs
        let country = CountryDao.getCountryById(id: countryId)
        let city = CityDao.getCityById(cityId: cityId)
        
        // Build the content string for AlarmKit display
        var content = "World Alarms\n"
        content += (description ?? "Your Event")
        if let cityName = city?.name, let countryName = country?.name {
            content += "\n\(cityName), \(countryName)"
        }
        
        var uuid = ""
        // Schedule with AlarmKit first

             uuid = try await AlarmKitUtils.scheduleAlarm(
                date: intDate,
                content: content,
                sound: sound
            )
            print("Alarm scheduled with UUID: \(uuid)")
        
        return uuid
            

      //  }
      //  catch {
         //   print("Failed to schedule alarm: \(error)")
        //}

    }
    

    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // print("textFieldShouldReturn: \(textField.text ?? "")")
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("textFieldDidBeginEditing: \(textField.text ?? "")")
        if editMode && textField.text?.isEmpty == true {
            textField.text = alarmDesc
        }
        animateTextField(textField, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("textFieldDidEndEditing: \(textField.text ?? "")")
        animateTextField(textField, up: false)
        view.endEditing(true)
    }
    
    func animateTextField(_ textField: UITextField, up: Bool) {
        //print("animateTextField: \(textField.text ?? "")")
        
        let movementDistance: CGFloat = 180
        let movementDuration: TimeInterval = 0.3
        
        let movement: CGFloat = up ? -movementDistance : movementDistance
        
        UIView.animate(withDuration: movementDuration) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }
    }
}
