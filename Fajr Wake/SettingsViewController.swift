//
//  SettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/17/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var detail: UILabel!
    var manager: OneShotLocationManager?
    
    var calculationMethod: String {
        let settingsCalcMethod = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.CalculationMethod.rawValue)
        let calcMethodText = CalculationMethods(rawValue: settingsCalcMethod)!.getString()
        return calcMethodText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        detail.text = calculationMethod
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calcMethodPick" {
            if let calcMethodViewController = segue.destinationViewController as? CalculationMethodTableViewController {
                calcMethodViewController.selectedCalcMethodLabel = calculationMethod
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // trigger action for "Get Current Location (GPS)" cell
        if indexPath.section == 1 && indexPath.row == 0 {
            // FIXME: Activity indicator should stop once the location is updated!
            self.startLocationDelegation()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


extension SettingsViewController {
    func startLocationDelegation() {
        self.navigationItem.titleView = ActivityIndicator.showActivityIndicator("Getting location...")
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                let lat = loc.coordinate.latitude
                let lon = loc.coordinate.longitude
                let gmt = LocalGMT.getLocalGMT()
                
                // location settings for prayer times
                FajrWakeViewController().locationSettingsForPrayerTimes(lat: lat, lon: lon, gmt: gmt)
                
                // call function to get city, state, and country of the given coordinates
                FajrWakeViewController().reverseGeocoding(lat, longitude: lon)
                
                FajrWakeViewController().updatePrayerTimes(NSDate())
                
                // stop showing activity indicator in navigation title
                self.navigationItem.titleView = nil
                
            } else if let err = error {
                print(err.localizedDescription)
                // option to transfer to locations settings
                let alertController = UIAlertController(title: "Could not get your location!", message: nil, preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                // stop showing activity indicator in navigation title
                self.navigationItem.titleView = nil
            }
            self.manager = nil
        }
    }
}
