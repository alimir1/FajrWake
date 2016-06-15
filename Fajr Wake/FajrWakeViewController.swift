//
//  FajrWakeViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/14/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import CoreLocation

class FajrWakeViewController: UITableViewController, CLLocationManagerDelegate {
    
    var prayerTimes: [String: String] = [:]
    var manager: OneShotLocationManager?
    let defaultSettings = NSUserDefaults.standardUserDefaults()
    var userSettingsPrayTimes: PrayerTimes!
    
    // Initializing userSettingsPrayTimes (need to do other inits to satisfy requirements
    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init(_ coder: NSCoder? = nil) {
        self.userSettingsPrayTimes = UserSettingsPrayerOptions.getUserSettings()
        
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false
        
        setupPrayerTimes()

    }
    
    // calls appropriate methods to perform specific tasks in order to populate prayertime dictionary
    func setupPrayerTimes() {
        if NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore") == true {
            print("launched before")
            let lon = defaultSettings.doubleForKey("longitude")
            let lat = defaultSettings.doubleForKey("latitude")
            let gmt = defaultSettings.doubleForKey("gmt")
            updatePrayerTimes(lat, lon: lon, gmt: gmt)
        } else {
            // this is first launch
            print("App launched first time")
            getLocationCoordinatesAndSetup()
            // once the app launched for first time, set "launchedBefore" to true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayPrayerTimesSegue"
        {
            if  let navController = segue.destinationViewController as? UINavigationController,
                let displayPrayerVC = navController.topViewController as? DisplayPrayersViewController {
                displayPrayerVC.prayTimesArray = prayerTimes
                displayPrayerVC.calculationMethodLabel = "This needs to be upated"
            }
        }
    }
    
    // gets location and calls updatePrayerTimes function
    func getLocationCoordinatesAndSetup() {
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                // got the location!
                let lat = loc.coordinate.latitude
                let lon = loc.coordinate.longitude
                
                // setting defaults
                NSUserDefaults.standardUserDefaults().setDouble(lat, forKey: "latitude")
                NSUserDefaults.standardUserDefaults().setDouble(lon, forKey: "longitude")
                NSUserDefaults.standardUserDefaults().setDouble(LocalGMT.getLocalGMT(), forKey: "gmt")
                self.updatePrayerTimes(lat, lon: lon, gmt: LocalGMT.getLocalGMT())
                
            } else if let err = error {
                
                // setting defaults to Qom's time if error in getting user location
                NSUserDefaults.standardUserDefaults().setDouble(34.61, forKey: "latitude")
                NSUserDefaults.standardUserDefaults().setDouble(50.84, forKey: "longitude")
                NSUserDefaults.standardUserDefaults().setDouble(+4.5, forKey: "gmt")
                self.updatePrayerTimes(34.61, lon: 50.84, gmt: +4.5)
                
                print(err.localizedDescription)
            }
            self.manager = nil
        }
    }
    
    // populates prayertime dictionary
    func updatePrayerTimes(lat: Double, lon: Double, gmt: Double) {
        self.prayerTimes = self.userSettingsPrayTimes.getPrayerTimes(NSCalendar.currentCalendar(), latitude: lat, longitude: lon, tZone: gmt)
    }
    
    // unwind methods for cells
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
