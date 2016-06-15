//
//  DisplayPrayersViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class DisplayPrayersViewController: UITableViewController, UIApplicationDelegate {
    
    var prayTimesArray: [String: String] = [:]
    
    // Outlets
    @IBOutlet weak var fajrTimeLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var dhuhrTimeLabel: UILabel!
    @IBOutlet weak var asrTimeLabel: UILabel!
    @IBOutlet weak var maghribTimeLabel: UILabel!
    @IBOutlet weak var ishaTimeLabel: UILabel!
    var calculationMethodLabel: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        fajrTimeLabel.text = prayTimesArray[SalatsAndQadhas.Fajr.getString]
        sunriseTimeLabel.text = prayTimesArray[SalatsAndQadhas.Sunrise.getString]
        dhuhrTimeLabel.text = prayTimesArray[SalatsAndQadhas.Dhuhr.getString]
        asrTimeLabel.text = prayTimesArray[SalatsAndQadhas.Asr.getString]
        maghribTimeLabel.text = prayTimesArray[SalatsAndQadhas.Maghrib.getString]
        ishaTimeLabel.text = prayTimesArray[SalatsAndQadhas.Isha.getString]
    }

    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Qom, Research Center"
    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.blackColor()
//        
//        return vw
//    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }

}