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
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false
        isAppAlreadyLaunchedOnce()
        

    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            
            let lon = defaults.doubleForKey("longitude")
            let lat = defaults.doubleForKey("latitude")
            let gmt = defaults.doubleForKey("gmt")
            updatePrayerTimes(lat, lon: lon, gmt: gmt)
            return true
        } else {
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            getLocationCoordinatesAndSetup()
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayPrayerTimesSegue"
        {
            if  let navController = segue.destinationViewController as? UINavigationController,
                let displayPrayerVC = navController.topViewController as? DisplayPrayersViewController {
                displayPrayerVC.prayTimesArray = prayerTimes
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
                self.defaults.setDouble(lat, forKey: "latitude")
                self.defaults.setDouble(lon, forKey: "longitude")
                self.defaults.setDouble(LocalGMT.getLocalGMT(), forKey: "gmt")
                self.updatePrayerTimes(lat, lon: lon, gmt: LocalGMT.getLocalGMT())
                
            } else if let err = error {
                
                // setting defaults to Qom's time if error in getting user location
//                self.defaults.setDouble(34.61, forKey: "latitude")
//                self.defaults.setDouble(50.84, forKey: "longitude")
//                self.defaults.setDouble(+4.5, forKey: "gmt")
//                self.updatePrayerTimes(34.61, lon: 50.84, gmt: +4.5)
                
                print(err.localizedDescription)
            }
            self.manager = nil
        }
    }
    
    func updatePrayerTimes(lat: Double, lon: Double, gmt: Double) {
        
        // default settings
        let myPrayTimes = PrayerTimes(caculationmethod: .Tehran, asrJuristic: .Shafii, adjustHighLats: .None, timeFormat: .Time12)
        self.prayerTimes = myPrayTimes.getPrayerTimes(NSCalendar.currentCalendar(), latitude: lat, longitude: lon, tZone: gmt)
        let something = myPrayTimes.julianDate(2016, month: 6, day: 14)
        print("(FajrWakeViewController)ISHRAQ: Julian or Islamic? I'm confused.. \(something)")
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
