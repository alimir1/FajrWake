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
}


// MARK: - Unwind methods for cells
extension FajrWakeViewController {
    @IBAction func cancelToPlayersViewController(segue: UIStoryboardSegue) {
    }

    @IBAction func savePlayerDetail(segue: UIStoryboardSegue) {
    }
    
    @IBAction func saveCalcMethodOption(segue: UIStoryboardSegue) {
        
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
            toDisplay = "Fajr: \(fajrTime)\t\tSunrise: \(sunriseTime)"
        }
        return toDisplay
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
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
//extension FajrWakeViewController {
//    // prepare segue for displaying prayer tme controller
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "displayPrayerTimesSegue"
//        {
//            if  let navController = segue.destinationViewController as? UINavigationController,
//                let displayPrayerVC = navController.topViewController as? DisplayPrayersViewController {
//                displayPrayerVC.prayTimesArray = self.prayerTimes // prayertimesDict
//            }
//        }
//    }
//}

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
    }
}

// MARK: - Helper Methods
// for prayer times
extension FajrWakeViewController {
    func showActivityIndicator(title: String) {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicatorView.frame = CGRectMake(0, 0, 14, 14)
        activityIndicatorView.color = UIColor.blackColor()
        activityIndicatorView.startAnimating()

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.italicSystemFontOfSize(14)

        let fittingSize = titleLabel.sizeThatFits(CGSizeMake(200.0, activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRectMake(activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8, activityIndicatorView.frame.origin.y, fittingSize.width, fittingSize.height)

        let titleView = UIView(frame: CGRectMake(((activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2), ((activityIndicatorView.frame.size.height) / 2), (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width), (activityIndicatorView.frame.size.height)))
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)

        self.navigationItem.titleView = titleView
    }

    func hideActivityIndicator() {
        self.navigationItem.titleView = nil
    }
}

// MARK: - Get location
// Get coordinates and call functinos to get prayer times
extension FajrWakeViewController {

    func startLocationDelegation() {
        self.showActivityIndicator("Getting your address...")
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in

            // fetch location or an error
            if let loc = location {
                let lat = loc.coordinate.latitude
                let lon = loc.coordinate.longitude
                let gmt = LocalGMT.getLocalGMT()

                // location settings for prayer times
                self.locationSettingsForPrayerTimes(lat: lat, lon: lon, gmt: gmt)
                self.updatePrayerTimes()

                // call function to get city, state, and country of the given coordinates
                self.reverseGeocoding(lat, longitude: lon)
                
                self.tableView.reloadData()

            } else if let err = error {
                // setting defaults to Qom's time if error in getting user location
                let lat = 34.6476568
                let lon = 50.8789548
                let gmt = +4.5

                // location settings for prayer times
                self.locationSettingsForPrayerTimes(lat: lat, lon: lon, gmt: gmt)
                self.updatePrayerTimes()

                // call function to get city, state, and country of the given coordinates
                self.reverseGeocoding(lat, longitude: lon)
                print(err.localizedDescription)
                
                self.tableView.reloadData()
            }
            self.manager = nil
        }
    }
}

// MARK: - Geocoding
// to get coordinates and names of cities, states, and countries
extension FajrWakeViewController {
    // reverse geocoding to get address of user location for display
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // FIXME: Indicates user if network fail
        // FIXME: Put activity indicator in the navigatino bar with text like "Updating..."
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                self.hideActivityIndicator()
                return
            }
            else if placemarks?.count > 0 {
                self.setLocationAddress(placemarks!)
                self.hideActivityIndicator()
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