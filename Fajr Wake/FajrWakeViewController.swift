//
//  FajrWakeViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/14/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

class FajrWakeViewController: UITableViewController, CLLocationManagerDelegate {
    var manager: OneShotLocationManager?
    var prayerTimes: [String: String] = [:]
    var locationNameDisplay: String = ""
    var fajrAlarms = [FajrWakeAlarm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPrayerTimes()
    }
    
    override func viewWillAppear(animated: Bool) {
        updatePrayerTimes()
//        displaySettingsTableView()
    }
    
    func displaySettingsTableView() {
        
        let NoAlarmsLabel: UILabel = UILabel(frame: CGRectZero)
        NoAlarmsLabel.text = "No Alarms"
        NoAlarmsLabel.baselineAdjustment = .AlignBaselines
        NoAlarmsLabel.backgroundColor = UIColor.clearColor()
        NoAlarmsLabel.textColor = UIColor.lightGrayColor()
        NoAlarmsLabel.textAlignment = .Center
        NoAlarmsLabel.font = UIFont(name: "Helvetica", size: 25.0)
        NoAlarmsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view!.addSubview(NoAlarmsLabel)
        let xConstraint = NSLayoutConstraint(item: NoAlarmsLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: NoAlarmsLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterY, multiplier: 1, constant: -30.0)
        NSLayoutConstraint.activateConstraints([xConstraint, yConstraint])
        
        if fajrAlarms.count == 0 {
            self.tableView.scrollEnabled = false
            NoAlarmsLabel.hidden = false

        } else {
            self.tableView.scrollEnabled = true
            NoAlarmsLabel.hidden = true
        }
    }
}


// MARK: - Unwind methods for cells
extension FajrWakeViewController {
    @IBAction func unwindToAlarms(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddAlarmTableViewController {
            let alarm = sourceViewController.fajrWakeAlarm
            let newIndexPath = NSIndexPath(forRow: fajrAlarms.count, inSection: 0)
            fajrAlarms.append(alarm)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
}

// MARK: - Table view configuration
extension FajrWakeViewController {
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fajrAlarms.count
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.0
//    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let fajr = prayerTimes[SalatsAndQadhas.Fajr.getString]
        let sunrise = prayerTimes[SalatsAndQadhas.Sunrise.getString]
        var toDisplay = ""
        if let fajrTime = fajr, let sunriseTime = sunrise {
            toDisplay = "Fajr: \(fajrTime)\t\tSunrise: \(sunriseTime)"
        }
        return toDisplay
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .Center
        }
    }

    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FajrWakeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FajrWakeCell
        
        let alarm = fajrAlarms[indexPath.row]
        let alarmLabel = "\(String(alarm.minsToAdjust)) mins \(alarm.whenToAlarm) \(alarm.whatSalatToAlarm)"
        let alarmDetailLabel = "\(alarm.alarmLabel), Tue Wed"
        cell.alarmLabel.text = alarmLabel
        cell.alarmDetailLabel.text = alarmDetailLabel
        
        return cell
     }
 
}

// MARK: - Segue preperations
extension FajrWakeViewController {

}

// MARK: - Setups and Settings
extension FajrWakeViewController {
    // calls appropriate methods to perform specific tasks in order to populate prayertime dictionary
    func setupPrayerTimes() {
        if NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore") == true {
            self.locationNameDisplay = NSUserDefaults.standardUserDefaults().objectForKey("userAddressForDisplay") as! String
            updatePrayerTimes()
            
        } else {
            startLocationDelegation()
            // once the app launched for first time, set "launchedBefore" to true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
    }

    // location settings for prayer time
    func locationSettingsForPrayerTimes (lat lat: Double, lon: Double, gmt: Double) {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setDouble(lat, forKey: "latitude")
        settings.setDouble(lon, forKey: "longitude")
        settings.setDouble(gmt, forKey: "gmt")
    }
    
    // update prayer time dictionary
    func updatePrayerTimes() {
        let settings = NSUserDefaults.standardUserDefaults()
        let lon = settings.doubleForKey("longitude")
        let lat = settings.doubleForKey("latitude")
        let gmt = settings.doubleForKey("gmt")
        
        let userPrayerTime = UserSettingsPrayertimes()
        self.prayerTimes = userPrayerTime.getUserSettings().getPrayerTimes(NSCalendar.currentCalendar(), latitude: lat, longitude: lon, tZone: gmt)
        
        self.tableView.reloadData()
    }
}

// MARK: - Get location
// Get coordinates and call functinos to get prayer times
extension FajrWakeViewController {

    func startLocationDelegation() {
        self.navigationItem.titleView = ActivityIndicator.showActivityIndicator("Getting location...")
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in

            // fetch location or an error
            if let loc = location {
                let lat = loc.coordinate.latitude
                let lon = loc.coordinate.longitude
                let gmt = LocalGMT.getLocalGMT()

                self.setupLocationForPrayerTimes(lat, lon: lon, gmt: gmt)
                
            } else if let err = error {
                print(err.localizedDescription)
                
                // setting defaults to Qom's time if error in getting user location
                let lat = 34.6476568
                let lon = 50.8789548
                let gmt = +4.5
                
                self.setupLocationForPrayerTimes(lat, lon: lon, gmt: gmt)
            }
            self.manager = nil
        }
    }
    
    func setupLocationForPrayerTimes(lat: Double, lon: Double, gmt: Double) {
        // location settings for prayer times
        self.locationSettingsForPrayerTimes(lat: lat, lon: lon, gmt: gmt)
        
        // call function to get city, state, and country of the given coordinates
        self.reverseGeocoding(lat, longitude: lon)
        
        self.updatePrayerTimes()
        
        // stop showing activity indicator in navigation title
        self.navigationItem.titleView = nil
    }
}

// MARK: - Geocoding
// to get coordinates and names of cities, states, and countries
extension FajrWakeViewController {
    // reverse geocoding to get address of user location for display
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // FIXME: Indicates user if network fail
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                self.setLocationAddress(placemarks!)
            }
        })
    }

    // sets locationNameDisplay variable appropriately
    func setLocationAddress(placemarks: [CLPlacemark]) {
        let pm = placemarks[0]
        var saveAddress = ""
        if let address = pm.addressDictionary as? [String: AnyObject] {
            if let city = address["City"], let state = address["State"], let country = address["Country"] {
                saveAddress = "\(String(city)), \(String(state)), \(String(country))"
            } else if let state = address["State"], let country = address["Country"] {
                saveAddress = "\(String(state)), \(String(country))"
            } else {
                if let country = address["Country"] {
                    saveAddress = "\(String(country))"
                }
            }
        } else {
            saveAddress = "could not get name of the user's city or country of their location"
        }
        NSUserDefaults.standardUserDefaults().setObject(saveAddress, forKey: "userAddressForDisplay")
        self.locationNameDisplay = NSUserDefaults.standardUserDefaults().objectForKey("userAddressForDisplay") as! String
    }
}