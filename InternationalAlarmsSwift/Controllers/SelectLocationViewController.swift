//
//  SelectLocationViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  SelectLocationViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationTable: UITableView!
    @IBOutlet weak var infoButton: UIButton!
    
    let MAX_RESULTS = 10
    
    var countries: [Country] = []
    var locations: [Location] = []
    var alarmPickerViewController: AlarmPickerViewController?
    
    var USACities: [City]?
    var filteredLocationList: [Location] = []
    
    var filtered = false
    var noSearchResults = false
    var utcMode = false
    var savedHeight: CGFloat = 0
    
    var country: Country?
    var city: City?
    
    var countryId = 0
    var cityId = 0
    
    var cityName: String?
    var countryName: String?
    
    var searchBarEmpty = true
    
    @objc func cancelPressed() {
        filtered = false
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let cancelButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(cancelPressed)
        )
        navigationItem.leftBarButtonItem = cancelButtonItem
        
        let utcButtonItem = UIBarButtonItem(
            title: "UTC Time",
            style: .plain,
            target: self,
            action: #selector(utcPressed)
        )
        
        let fontSize: CGFloat = 15
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        utcButtonItem.setTitleTextAttributes(attributes, for: .normal)
        
        navigationItem.rightBarButtonItem = utcButtonItem
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        country = nil
        city = nil
        filteredLocationList = []
        searchBar.text = nil
        noSearchResults = true
        searchBarEmpty = true
        locationTable.reloadData()
        
        registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Enter Location"
        
        view.backgroundColor = AppColors.mainBackgroundColor()
        locationTable.backgroundColor = AppColors.mainBackgroundColor()
        
        locationTable.separatorStyle = .singleLine
        locationTable.separatorColor = AppColors.veryLightGrayColor()
        locationTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        customiseSearchBar()
        registerForKeyboardNotifications()
        
        countries = CountryDao.getCountryList()
        
        print("NUM COUNTRIES FOUND: " + String(countries.count))
        
        locations = []
        
        // for each country, get city list.
        for country in countries {
            print("country: " + country.name + " " + String(country.countryId))
            let cities = CityDao.getCityListByCountry(countryId: country.countryId) ?? []
            
            var seenCities = Set<String>()
            for city in cities {
                let cityName = city.name.lowercased()
                let isDuplicate = seenCities.contains(cityName)
                if !isDuplicate {
                    seenCities.insert(cityName)
                }
                let location = Location(country: country, city: city, timezone: city.timezone ?? "", isDuplicate: isDuplicate)
                locations.append(location)
            }
        }
        
        locationTable.dataSource = self
        locationTable.delegate = self
        
        searchBar.delegate = self
        noSearchResults = true
        
        infoButton.setTitle("Help", for: .normal)
        infoButton.setTitleColor(.white, for: .normal)
        infoButton.backgroundColor = AppColors.brightBlueColor()
        infoButton.layer.borderWidth = 1.0
        infoButton.layer.borderColor = AppColors.accentBlueColor().cgColor
        infoButton.layer.cornerRadius = 10.0
        infoButton.addTarget(self, action: #selector(showInfoModal(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func customiseSearchBar() {
        searchBar.barTintColor = AppColors.darkGrayBackgroundColor()
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = AppColors.darkGrayBackgroundColor()
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "city / state / country",
            attributes: [.foregroundColor: AppColors.fadedVeryLightGrey()]
        )
        
        if let leftImageView = searchBar.searchTextField.leftView as? UIImageView {
            leftImageView.tintColor = .lightGray
        }
        
        searchBar.tintColor = AppColors.accentBlueColor()
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
    
    @objc func dismissInfoVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noSearchResults || searchBarEmpty {
            return 0
        }
        let count = filteredLocationList.count
        
        if count <= MAX_RESULTS {
            return count
        }
        
        return MAX_RESULTS
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier = "SimpleTableItem"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
        }
        
        guard let cell = cell else { return UITableViewCell() }
        
        cell.backgroundColor = AppColors.mainBackgroundColor()
        
        if noSearchResults {
            return cell
        }
        
        let loc = filteredLocationList[indexPath.row]
        
        cell.textLabel?.text = loc.name
        cell.textLabel?.textColor = AppColors.primaryTextColor()
        
        cell.imageView?.contentMode = .scaleAspectFit
        let widthScale: CGFloat = 0.25
        let heightScale: CGFloat = 0.25
        cell.imageView?.transform = CGAffineTransform(scaleX: widthScale, y: heightScale)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.selectionStyle = .default
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = AppColors.slightlyLighterNavySlateColor()
        cell.selectedBackgroundView = selectionColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextButtonPushed()
    }
    
    func nextButtonPushed() {
        guard let selectedIndexPath = locationTable.indexPathForSelectedRow else { return }
        let loc = filteredLocationList[selectedIndexPath.row]
        
        countryId = loc.country.countryId
        countryName = loc.country.name
        
        cityId = loc.city.cityId
        cityName = loc.city.name
        
        country = loc.country
        city = loc.city
        switchToAlarmView()
    }
    
    @objc func utcPressed() {
        utcMode = true
        switchToAlarmView()
    }
    
    func switchToAlarmView() {
        if alarmPickerViewController == nil {
            alarmPickerViewController = AlarmPickerViewController(nibName: "AlarmPickerView", bundle: nil)
        }
        
        guard let alarmPickerVC = alarmPickerViewController else { return }
        
        if !utcMode {
            alarmPickerVC.city = city
            alarmPickerVC.country = country
            
            if city == nil {
                cityId = 0
            }
            alarmPickerVC.cityId = cityId
            alarmPickerVC.countryId = countryId
        } else {
            alarmPickerVC.utcMode = true
        }
        
        navigationController?.pushViewController(alarmPickerVC, animated: true)
        
        alarmPickerViewController = nil
        utcMode = false
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("In textDidChange")
        
        noSearchResults = false
        
        if searchText.isEmpty {
            searchBarEmpty = true
            print("NO SEARCH TEXT, RETURNING")
            
            if filtered {
                locationTable.reloadData()
            }
            filtered = false
            return
        }
        
        print("SEARCH TEXT IS ENTERED: \(searchText)")
        
        filtered = true
        filteredLocationList = []
        
        for loc in locations {
            if filteredLocationList.count == MAX_RESULTS {
                break
            }
            let sanitisedLocName = sanitiseLocationString(loc.name)
            let sanitisedSearchText = sanitiseLocationString(searchText)
            
            if sanitisedLocName.range(of: sanitisedSearchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
                filteredLocationList.append(loc)
            }
        }
        
        print("FILTERED LIST::: \(filteredLocationList.count)")
        searchBarEmpty = false
        
        if filteredLocationList.isEmpty {
            // display no search result
        }
        
        print("RELOADING TABLE")
        locationTable.reloadData()
    }
    
    func sanitiseLocationString(_ inputString: String) -> String {
        return inputString.replacingOccurrences(of: ",", with: "")
    }
    
    func displayNoSearchResults() {
        noSearchResults = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filtered = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo,
              let kbSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        
        var bkgndRect = locationTable.frame
        
        if bkgndRect.size.height > savedHeight {
            savedHeight = bkgndRect.size.height
        }
        bkgndRect.size.height = savedHeight - kbSize.height
        locationTable.frame = bkgndRect
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShown(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        var bkgndRect = locationTable.frame
        bkgndRect.size.height = savedHeight
        locationTable.frame = bkgndRect
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
