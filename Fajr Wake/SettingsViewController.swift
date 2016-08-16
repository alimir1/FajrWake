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
    var fajrWakeVCReference: FajrWakeViewController?
    
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
                calcMethodViewController.fajrWakeVCReference = self.fajrWakeVCReference
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // trigger action for "Get Current Location (GPS)" cell
        if indexPath.section == 1 && indexPath.row == 0 {
            fajrWakeVCReference!.startLocationDelegation()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "__________ IMPORTANT __________\nTo ensure that all features work properly, please keep this app running until alarm times. You may lock the device."
        } else {
            return nil
        }
    }

    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section == 1 {
            if let footerView = view as? UITableViewHeaderFooterView {
                footerView.textLabel?.textAlignment = .Center
            }
        }
    }
}








