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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPrayerTimes()
    }
    
    override func viewWillAppear(animated: Bool) {
        updatePrayerTimes()
    }
    
}


// MARK: - Unwind methods for cells
extension FajrWakeViewController {
    @IBAction func cancelToPlayersViewController(segue: UIStoryboardSegue) {
    }

    @IBAction func savePlayerDetail(segue: UIStoryboardSegue) {
    }
}

// MARK: - Table view configuration
extension FajrWakeViewController {
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let fajr = prayerTimes[SalatsAndQadhas.Fajr.getString]
        let sunrise = prayerTimes[SalatsAndQadhas.Sunrise.getString]
        var toDisplay = ""
        if let fajrTime = fajr, let sunriseTime = sunrise {
            toDisplay = "Fajr: \(fajrTime)\tSunrise: \(sunriseTime)"
        }
        return toDisplay
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .Center
        }
    }

    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
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