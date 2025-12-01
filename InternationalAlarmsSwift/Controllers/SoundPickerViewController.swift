//
//  SoundPickerViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  SoundPickerViewController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import UIKit
import AVFoundation
import AudioToolbox

typealias SoundSelectionCompletionBlock = (String) -> Void

class SoundPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var selectedFilename: String?
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var soundsTable: UITableView!
    @IBOutlet weak var infoIcon: UIImageView!
    
    var completionBlock: SoundSelectionCompletionBlock?
    
    private static var fileToDisplayMap: [String: String]?
    private static var displayToFileMap: [String: String]?
    private static var soundDisplayNames: [String]?
    
    private var audioPlayer: AVAudioPlayer?
    private var selectedDisplayName: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        soundsTable.reloadData()
    }
    
    static func initSounds() {
        fileToDisplayMap = [
            "apple_default": "Apple Default (no preview)",
            "bell_long.mp3": "Bell",
            "bird2_long.mp3": "Morning Birds",
            "bird_long.mp3": "Forest Birds",
            "cat_long.mp3": "Cat",
            "piano_long.mp3": "Musical Piano",
            "piano_riff_long.mp3": "Piano Riff",
            "retro.mp3": "Digital",
            "silent.mp3": "No Sound"
        ]
        
        var tempMap: [String: String] = [:]
        if let fileMap = fileToDisplayMap {
            for (fileName, displayName) in fileMap {
                tempMap[displayName] = fileName
            }
        }
        displayToFileMap = tempMap
        
        soundDisplayNames = fileToDisplayMap?.values.sorted()
    }
    
    func initOnce() {
        soundsTable.delegate = self
        soundsTable.dataSource = self
        soundsTable.backgroundColor = AppColors.darkGrayBackgroundColor()
        view.backgroundColor = AppColors.mainBackgroundColor()
        
        soundsTable.layer.cornerRadius = 12
        soundsTable.clipsToBounds = true
        
        if SoundPickerViewController.fileToDisplayMap == nil {
            SoundPickerViewController.initSounds()
        }
        
        title = "Select Alarm Sound"
        
        let backButtonItem = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(backPushed)
        )
        navigationItem.leftBarButtonItem = backButtonItem
        
        soundsTable.separatorStyle = .singleLine
        soundsTable.separatorColor = AppColors.fadedVeryLightGrey()
        soundsTable.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        soundsTable.tableFooterView = UIView(frame: .zero)
        
        warningLabel.text = "TO HEAR SOUND PREVIEWS, ENSURE YOUR DEVICE IS NOT IN SILENT MODE"
        warningLabel.textColor = AppColors.defaultIOSBlueColor()
        warningLabel.font = AppFonts.mediumFont()
        
        setupConstraints()
    }
    
    func initEachTime() {
        selectedDisplayName = SoundPickerViewController.fileNameToSoundName(selectedFilename ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initOnce()
    }
    
    func setupConstraints() {
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        soundsTable.translatesAutoresizingMaskIntoConstraints = false
        infoIcon.translatesAutoresizingMaskIntoConstraints = false
        
        warningLabel.numberOfLines = 0
        
        infoIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        warningLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            infoIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            infoIcon.heightAnchor.constraint(equalToConstant: 22),
            infoIcon.widthAnchor.constraint(equalToConstant: 22),
            
            warningLabel.leadingAnchor.constraint(equalTo: infoIcon.trailingAnchor, constant: 8),
            warningLabel.topAnchor.constraint(equalTo: infoIcon.topAnchor),
            warningLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            soundsTable.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 20),
            soundsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            soundsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            soundsTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 480)
        ])
    }
    
    @objc func backPushed() {
        audioPlayer?.stop()
        if let filename = selectedFilename {
            didSelectSound(withName: filename)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectSound(withName filename: String) {
        selectedFilename = filename
        selectedDisplayName = SoundPickerViewController.fileNameToSoundName(filename)
        
        completionBlock?(filename)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEachTime()
        soundsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SoundPickerViewController.fileToDisplayMap?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        guard let cell = cell, let soundNames = SoundPickerViewController.soundDisplayNames else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = soundNames[indexPath.row]
        cell.textLabel?.textColor = AppColors.primaryTextColor()
        cell.backgroundColor = soundsTable.backgroundColor
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = AppColors.slightlyLighterNavySlateColor()
        cell.selectedBackgroundView = selectionColor
        cell.textLabel?.highlightedTextColor = AppColors.brightBlueColor()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.textLabel?.font = AppFonts.mediumFont()
        }
        
        if let selectedName = selectedDisplayName,
           let selectedIndex = soundNames.firstIndex(of: selectedName) {
            cell.accessoryType = (selectedIndex == indexPath.row) ? .checkmark : .none
        } else {
            cell.accessoryType = .none
        }
        
        UITableViewCell.appearance().tintColor = AppColors.brightBlueColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let soundNames = SoundPickerViewController.soundDisplayNames else { return }
        
        print("row selected: \(soundNames[indexPath.row])")
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        for i in 0..<soundNames.count {
            if i != indexPath.row {
                let otherIndexPath = IndexPath(row: i, section: 0)
                tableView.cellForRow(at: otherIndexPath)?.accessoryType = .none
            }
        }
        
        guard let selectedItem = cell?.textLabel?.text else { return }
        
        selectedFilename = SoundPickerViewController.displayToFileMap?[selectedItem]
        
        if let filename = selectedFilename {
            playSound(filename)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func playSound(_ soundFile: String) {
        print("IN PLAYSOUND: \(soundFile)")
        
        let fileWithoutExtension = (soundFile as NSString).deletingPathExtension
        let fileExtension = (soundFile as NSString).pathExtension
        
        guard let path = Bundle.main.path(forResource: fileWithoutExtension, ofType: fileExtension) else {
            print("Sound file not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            sleep(2)
            audioPlayer?.stop()
        } catch {
            print("Error in audioPlayer: \(error.localizedDescription)")
        }
    }
    
    static func fileNameToSoundName(_ fileName: String) -> String {
        if fileToDisplayMap == nil {
            initSounds()
        }
        return fileToDisplayMap?[fileName] ?? ""
    }
    
//    static func defaultValue() -> String {
//        return "piano_long.mp3"
//    }
    
    static func defaultValue() -> String {
        return "apple_default"
    }
}
