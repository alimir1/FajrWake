//
//  FajrWakeViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 6/14/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//


import UIKit
import CoreLocation
import AddressBookUI
import AVFoundation
import AudioToolbox
import MediaPlayer
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class FajrWakeViewController: UITableViewController, CLLocationManagerDelegate {
    var manager: OneShotLocationManager?
    var prayerTimes: [String: String] = [:]
    var locationNameDisplay: String?
    var alarms = [AlarmClockType]()
    var noAlarmsLabel = UILabel()
    var alarmSoundPlayer: AVAudioPlayer!
    var alarmAlertController: UIAlertController?
    var timerToStall = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure local notifications
        let settings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.cancelAllLocalNotifications()
        
        configureNotificationObservers()
        noAlarmsLabelConfig()
        setupPrayerTimes()
        loadAlarms()
        
        // hide "edit" button when no alarm
        if alarms.count > 0 {
            navigationItem.leftBarButtonItem = editButtonItem
        } else {
            self.setEditing(false, animated: false)
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setEditing(false, animated: false)
    }
    
    func configureNotificationObservers() {
        // will terminate
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkApplicationState), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        // will resign active
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkApplicationState), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        // did become active
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupNotificationsReference), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    func loadAlarms() {
        // load saved alarms
        if let savedAlarms = getSavedAlarms() {
            alarms += savedAlarms
        }
    }
    
    // Dirty solution: When phone is locked, local notification should not play sound...
    func checkApplicationState() {
        if UIApplication.shared.applicationState == .active {
            if timerToStall.isValid {
                timerToStall.invalidate()
            }
            timerToStall = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.setupNotificationsWithoutSound), userInfo: nil, repeats: false)
        }
    }
    
    func setupNotificationsWithoutSound() {
        UIApplication.shared.cancelAllLocalNotifications()
        setupLocalNotifications(true)
    }
    
    func setupNotificationsReference() {
        if timerToStall.isValid {
            timerToStall.invalidate()
        }
        setupLocalNotifications()
    }
    
    func setupLocalNotifications(_ noSound: Bool? = false) {
        UIApplication.shared.cancelAllLocalNotifications()
        if self.alarms.count > 0 {
            for (index, _) in self.alarms.enumerated() {
                if self.alarms[index].alarmOn {
                    let alarmDate = self.alarms[index].savedAlarmDate!
                    if alarmDate.timeIntervalSinceNow >= 0  {
                        if noSound == true {
                            self.alarms[index].scheduleLocalNotification(noSound: true)
                        } else {
                            self.alarms[index].scheduleLocalNotification()
                        }
                    }
                }
            }
        }
    }
    
    func noAlarmsLabelConfig() {
        noAlarmsLabel = UILabel(frame: CGRect.zero)
        noAlarmsLabel.text = "No Alarms"
        noAlarmsLabel.baselineAdjustment = .alignBaselines
        noAlarmsLabel.backgroundColor = UIColor.clear
        noAlarmsLabel.textColor = UIColor.lightGray
        noAlarmsLabel.textAlignment = .center
        noAlarmsLabel.font = UIFont(name: "Helvetica", size: 25.0)
        noAlarmsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view!.addSubview(noAlarmsLabel)
        let xConstraint = NSLayoutConstraint(item: noAlarmsLabel, attribute: .centerX, relatedBy: .equal, toItem: self.tableView, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: noAlarmsLabel, attribute: .centerY, relatedBy: .equal, toItem: self.tableView, attribute: .centerY, multiplier: 1, constant: -30.0)
        NSLayoutConstraint.activate([xConstraint, yConstraint])
    }
    
    func displaySettingsTableView() {
        if alarms.count == 0 {
            self.tableView.isScrollEnabled = false
            self.noAlarmsLabel.isHidden = false
        } else {
            self.tableView.isScrollEnabled = true
            self.noAlarmsLabel.isHidden = true
        }
    }
}

// MARK: - TableView
extension FajrWakeViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hide "edit" button when no alarm
        if alarms.count > 0 {
            navigationItem.leftBarButtonItem = editButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
        return alarms.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.displaySettingsTableView()
        
        let settings = UserDefaults.standard
        let calcMethodRawValue = settings.integer(forKey: PrayerTimeSettingsReference.CalculationMethod.rawValue)
        let calculationMethod = CalculationMethods(rawValue: calcMethodRawValue)!.getString()
        
        var toDisplay = ""
        if let locName = locationNameDisplay {
            toDisplay = "\(locName)\n\(calculationMethod)"
        }
        
        return toDisplay
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let fajr = prayerTimes[SalatsAndQadhas.fajr.getString]
        let sunrise = prayerTimes[SalatsAndQadhas.sunrise.getString]
        let tomorrowPrayerTimes = getPrayerTimes(Date().addingTimeInterval(60*60*24))
        let fajrTomorrow = tomorrowPrayerTimes[SalatsAndQadhas.fajr.getString]!
        let sunriseTomorrow = tomorrowPrayerTimes[SalatsAndQadhas.sunrise.getString]!
        var toDisplay = ""
        
        if let fajrTime = fajr, let sunriseTime = sunrise {
            toDisplay = "Today: Fajr: \(fajrTime), Sunrise: \(sunriseTime)\nTomorrow: Fajr: \(fajrTomorrow), Sunrise: \(sunriseTomorrow)"
        }
        
        return toDisplay
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footerView = view as? UITableViewHeaderFooterView {
            footerView.textLabel?.textAlignment = .center
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.text = headerView.textLabel?.text!.capitalized
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FajrWakeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FajrWakeCell
        var alarm = alarms[(indexPath as NSIndexPath).row]
        
        cell.alarmLabel.attributedText = alarm.attributedTitle
        cell.alarmLabel.textColor = UIColor.black
        cell.editingAccessoryType = .disclosureIndicator
        
        if alarm.alarmOn == true {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackground
            cell.alarmLabel.textColor = UIColor.gray
        }
        
        let alarmSwitch = UISwitch(frame: CGRect.zero)
        alarmSwitch.onTintColor = UIColor(red: 0.9294, green: 0.298, blue: 0.2588, alpha: 1.0) /* #ed4c42 */
        alarmSwitch.isOn = alarm.alarmOn
        cell.accessoryView = alarmSwitch
        alarmSwitch.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)
        
        return cell
    }
    
    func setupAlarmsAndUpdate(_ indexPath: IndexPath) {
        var alarm = alarms[(indexPath as NSIndexPath).row]
        if alarm.alarmOn == true {
            if let url = alarm.sound.alarmSound.URL {
                alarm.startAlarm(self, selector: #selector(self.alarmAction), date: alarm.timeToAlarm(nil), userInfo: [indexPath : url])
            } else {
                alarm.startAlarm(self, selector: #selector(self.alarmAction), date: alarm.timeToAlarm(nil), userInfo: indexPath)
            }
            // schedule local notifications
            setupLocalNotifications()
        } else {
            alarm.stopAlarm()
            alarm.deleteLocalNotifications()
        }
        saveAlarms()
    }
    
    // Target-Action for AlarmClock switch (on/off)
    func switchChanged(_ switchControl: UISwitch) {
        let switchOriginInTableView = switchControl.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: switchOriginInTableView) {
            alarms[(indexPath as NSIndexPath).row].alarmOn = switchControl.isOn
            setupAlarmsAndUpdate(indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            print("ERROR: Cell doesn't exist!")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove NSTimer and delete the row from the data source
            alarms[(indexPath as NSIndexPath).row].stopAlarm()
            alarms[(indexPath as NSIndexPath).row].deleteLocalNotifications()
            alarms.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            saveAlarms()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing == true {
            tableView.allowsSelectionDuringEditing = true
        } else {
            self.tableView.allowsSelection = false
        }
        return true
    }
}

// MARK: - Navigation
extension FajrWakeViewController {
    @IBAction func unwindToAlarms(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddAlarmMasterViewController, let alarm = sourceViewController.alarmClock {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // edit alarm
                // turn off the previous alarm and replace alarm clock with edited alarm
                alarms[(selectedIndexPath as NSIndexPath).row].stopAlarm()
                alarms[(selectedIndexPath as NSIndexPath).row].deleteLocalNotifications()
                alarms[(selectedIndexPath as NSIndexPath).row] = alarm
                setupAlarmsAndUpdate(selectedIndexPath)
            } else {
                // add new alarm
                let newIndexPath = IndexPath(row: alarms.count, section: 0)
                alarms.append(alarm)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                setupAlarmsAndUpdate(newIndexPath)
            }
        }
        self.tableView.reloadData()
    }
    
    ///////////////////////////////Firing Alarm////////////////////////////////////////////////////
    func alarmAction(_ timer: Timer) {
        var url: URL?
        var indexPath: IndexPath?
        var vibrationTimer = Timer()
        
        if let userInfo = timer.userInfo as? [IndexPath : URL] {
            indexPath = userInfo.first!.0
            url = userInfo.first!.1
        } else if let userInfo = timer.userInfo as? IndexPath {
            indexPath = userInfo
        }
        
        if url != nil {
            playSound(url!)
            // vibrate every 2 seconds
            self.vibrate()
            vibrationTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.vibrate), userInfo: nil, repeats: true)
        }
        
        ///// Alarm Alert View
        alarmAlertController = UIAlertController(title: "\(alarms[(indexPath! as NSIndexPath).row].alarmLabel)", message: nil, preferredStyle: .alert)
        if alarms[(indexPath! as NSIndexPath).row].snooze == true {
            // Snooze Button
            alarmAlertController!.addAction(UIAlertAction(title: "Snooze", style: UIAlertActionStyle.default) {
                action -> Void in
                
                // stop alarm sound
                if self.alarmSoundPlayer != nil {
                    self.alarmSoundPlayer.stop()
                    self.alarmSoundPlayer = nil
                }
                
                // stop vibration
                if vibrationTimer.isValid {
                    vibrationTimer.invalidate()
                }
                // snooze for 8 mins
                let snoozeTime = Date().addingTimeInterval(60 * 8)
                if url != nil {
                    self.alarms[(indexPath! as NSIndexPath).row].startAlarm(self, selector: #selector(self.alarmAction), date: snoozeTime, userInfo: [indexPath! : url!])
                } else {
                    self.alarms[(indexPath! as NSIndexPath).row].startAlarm(self, selector: #selector(self.alarmAction), date: snoozeTime, userInfo: indexPath!)
                }
                self.alarms[(indexPath! as NSIndexPath).row].savedAlarmDate = snoozeTime
                self.setupAlarmsAndUpdate(indexPath!)
            })
        }
        // Stop Button
        alarmAlertController!.addAction(UIAlertAction(title: "Stop", style: .default) {
            action -> Void in
            // stop alarm sound
            if self.alarmSoundPlayer != nil {
                self.alarmSoundPlayer.stop()
                self.alarmSoundPlayer = nil
            }
            
            // stop vibration
            if vibrationTimer.isValid {
                vibrationTimer.invalidate()
            }
            
            self.setupAlarmsAndUpdate(indexPath!)
        })
        
        alarmAlertController!.show()
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func playSound(_ url: URL) {
        do {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) // play audio even in silent mode
            } catch {
                print("could not play in silent mode")
            }
            alarmSoundPlayer = try AVAudioPlayer(contentsOf: url)
            alarmSoundPlayer.play()
            alarmSoundPlayer.numberOfLoops = -1 // "infinite" loop
            // adjust volume to highest
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1.0, animated: false)
        } catch {
            print("could not play sound")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    @IBAction func unwindToAlarmsDelete(_ sender: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // remove alarms and delete cell
            alarms[(selectedIndexPath as NSIndexPath).row].stopAlarm()
            alarms[(selectedIndexPath as NSIndexPath).row].deleteLocalNotifications()
            alarms.remove(at: (selectedIndexPath as NSIndexPath).row)
            tableView.deleteRows(at: [selectedIndexPath], with: .fade)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            saveAlarms()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let addAlarmMasterVC = (segue.destination as! UINavigationController).topViewController as! AddAlarmMasterViewController
            if let selectedAlarmCell = sender as? FajrWakeCell {
                let indexPath = tableView.indexPath(for: selectedAlarmCell)!
                let selectedAlarm = alarms[(indexPath as NSIndexPath).row]
                
                addAlarmMasterVC.navigationItem.title = "Edit Alarm"
                addAlarmMasterVC.alarmClock = selectedAlarm
            }
        } else if segue.identifier == "addItem" {
            // new alarm
        } else if segue.identifier == "settingsSegue" {
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.fajrWakeVCReference = self
        }
    }
}

// MARK: - Setups and Settings
extension FajrWakeViewController {
    // calls appropriate methods to perform specific tasks in order to populate prayertime dictionary
    func setupPrayerTimes() {
        if UserDefaults.standard.bool(forKey: "launchedBefore") == true {
            if let displayAddress = UserDefaults.standard.object(forKey: "userAddressForDisplay") as? String {
                self.locationNameDisplay = displayAddress
            } else {
                self.locationNameDisplay = "Could not get your city name"
            }
            updatePrayerTimes(Date())
        } else {
            startLocationDelegation()
            // once the app launched for first time, set "launchedBefore" to true
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    // location settings for prayer time
    func locationSettingsForPrayerTimes (lat: Double, lon: Double, gmt: Double) {
        let settings = UserDefaults.standard
        settings.set(lat, forKey: "latitude")
        settings.set(lon, forKey: "longitude")
        settings.set(gmt, forKey: "gmt")
    }
    
    // update prayer time dictionary
    func updatePrayerTimes(_ date: Date) {
        DispatchQueue.main.async {
            self.prayerTimes = self.getPrayerTimes(date)
            for i in 0 ..< self.alarms.count {
                let indexPath = IndexPath(row: i, section: 0)
                self.alarms[(indexPath as NSIndexPath).row].stopAlarm()
                self.alarms[(indexPath as NSIndexPath).row].deleteLocalNotifications()
                self.setupAlarmsAndUpdate(indexPath)
            }
            self.tableView.reloadData()
        }
    }
    
    // Helper method to get prayer times
    func getPrayerTimes(_ date: Date) -> [String: String] {
        let settings = UserDefaults.standard
        let lon = settings.double(forKey: "longitude")
        let lat = settings.double(forKey: "latitude")
        let gmt = settings.double(forKey: "gmt")
        let userPrayerTime = UserSettingsPrayertimes()
        
        return userPrayerTime.getUserSettings().getPrayerTimes(Calendar.current, date: date, latitude: lat, longitude: lon, tZone: gmt)
    }
}

// Testing Update?
// MARK: - Get location
// Get coordinates and call functinos to get prayer times
extension FajrWakeViewController {
    func startLocationDelegation() {
        // Activity Indicator
        SwiftSpinner.show("Please Wait...", animated: true)
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                let lat = loc.coordinate.latitude
                let lon = loc.coordinate.longitude
                let gmt = LocalGMT.getLocalGMT()
                self.setupLocationForPrayerTimes(lat, lon: lon, gmt: gmt)
                // stop showing activity indicator (success)
                // EZLoadingActivity.hide(success: true, animated: true)
                
            } else if let err = error {
                // setting defaults to San Jose, CA, USA's time if error in getting user location
                let lat = 37.279518
                let lon = -121.867905
                let gmt = -7.0
                
                print(err.localizedDescription)
                self.setupLocationForPrayerTimes(lat, lon: lon, gmt: gmt)
                
                if err.code == 0 {
                    let alertController = UIAlertController(
                        title: "Location Access Disabled",
                        message: "In order to setup your alarm, the app needs access to your location so that your local prayer times are determined. The app will use San Jose, CA, USA's prayer timing if you disable location access.",
                        preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                        if let url = URL(string:UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    alertController.addAction(openAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Could not get your location!", message: "Prayer times are now based on San Jose, CA, USA.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                // stop showing activity indicator (not successful)
                SwiftSpinner.hide()
            }
            self.manager = nil
        }
    }
    
    func setupLocationForPrayerTimes(_ lat: Double, lon: Double, gmt: Double) {
        // location settings for prayer times
        self.locationSettingsForPrayerTimes(lat: lat, lon: lon, gmt: gmt)
        // call "reverseGeocoding" to get city, state, and country of the given coordinates
        //   then update prayer times
        self.reverseGeocoding(lat, longitude: lon)
        self.updatePrayerTimes(Date())
    }
}

// MARK: - Geocoding
// to get coordinates and names of cities, states, and countries
extension FajrWakeViewController {
    // reverse geocoding to get address of user location for display
    func reverseGeocoding(_ latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                UserDefaults.standard.set("Network Error", forKey: "userAddressForDisplay")
                self.locationNameDisplay = UserDefaults.standard.object(forKey: "userAddressForDisplay") as? String
                self.tableView.reloadData()
                SwiftSpinner.hide()
                return
            }
            else if placemarks?.count > 0 {
                self.setLocationAddress(placemarks!)
            }
        })
    }
    
    // sets locationNameDisplay variable appropriately
    func setLocationAddress(_ placemarks: [CLPlacemark]) {
        let pm = placemarks[0]
        var saveAddress = ""
        if let address = pm.addressDictionary as? [String: AnyObject] {
            if let city = address["City"], let state = address["State"], let country = address["Country"] {
                saveAddress = "\(String(describing: city)), \(String(describing: state)), \(String(describing: country))"
            } else if let state = address["State"], let country = address["Country"] {
                saveAddress = "\(String(describing: state)), \(String(describing: country))"
            } else {
                if let country = address["Country"] {
                    saveAddress = "\(String(describing: country))"
                }
            }
            // Hide activity indicator
            SwiftSpinner.hide()
        } else {
            saveAddress = "Can't Find Your City Name"
        }
        UserDefaults.standard.set(saveAddress, forKey: "userAddressForDisplay")
        self.locationNameDisplay = UserDefaults.standard.object(forKey: "userAddressForDisplay") as? String
        self.tableView.reloadData()
    }
}


// MARK: - Persisting Data (NSCoding and loading alarms)
extension FajrWakeViewController {
    func saveAlarms() {
        var fajrAlarmIsSuccessfulSave = false
        var customAlarmIsSuccessfulSave = false
        
        var fajrAlarms: [FajrWakeAlarm] = []
        var customAlarms: [CustomAlarm] = []
        
        for alarm in self.alarms {
            if alarm.alarmType == AlarmType.fajrWakeAlarm {
                fajrAlarms.append(alarm as! FajrWakeAlarm)
            } else if alarm.alarmType == AlarmType.customAlarm {
                customAlarms.append(alarm as! CustomAlarm)
            }
        }
        
        // Save FajrWakeAlarm's
        fajrAlarmIsSuccessfulSave = NSKeyedArchiver.archiveRootObject(fajrAlarms, toFile: FajrWakeAlarm.ArchiveURL.path)
        if !fajrAlarmIsSuccessfulSave {
            print("unable to save FajrWake alarms")
        }
        
        // Save CustomAlarm's
        customAlarmIsSuccessfulSave = NSKeyedArchiver.archiveRootObject(customAlarms, toFile: CustomAlarm.ArchiveURL.path)
        if !customAlarmIsSuccessfulSave {
            print("unable to save CustomAlarms alarms")
        }
    }
    
    func getSavedAlarms() -> [AlarmClockType]? {
        let savedFajrAlarms = NSKeyedUnarchiver.unarchiveObject(withFile: FajrWakeAlarm.ArchiveURL.path) as? [FajrWakeAlarm]
        let savedCustomAlarms = NSKeyedUnarchiver.unarchiveObject(withFile: CustomAlarm.ArchiveURL.path) as? [CustomAlarm]
        var savedAlarms: [AlarmClockType] = []
        
        if let customAlarms = savedCustomAlarms {
            for alarm in customAlarms {
                savedAlarms.append(alarm)
            }
        }
        
        if let fajrAlarms = savedFajrAlarms {
            for alarm in fajrAlarms {
                savedAlarms.append(alarm)
            }
        }
        
        if savedAlarms.count > 0 {
            return savedAlarms
        } else {
            return nil
        }
    }
}

extension UIAlertController {
    func show() {
        present(true, completion: nil)
    }
    
    func present(_ animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(rootVC, animated: animated, completion: completion)
        }
    }
    
    fileprivate func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(visibleVC, animated: animated, completion: completion)
        } else {
            if  let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion)
            }
        }
    }
}
