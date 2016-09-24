//
//  SettingsViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 6/17/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var detail: UILabel!
    var manager: OneShotLocationManager?
    var fajrWakeVCReference: FajrWakeViewController?
    
    var calculationMethod: String {
        let settingsCalcMethod = UserDefaults.standard.integer(forKey: PrayerTimeSettingsReference.CalculationMethod.rawValue)
        let calcMethodText = CalculationMethods(rawValue: settingsCalcMethod)!.getString()
        return calcMethodText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detail.text = calculationMethod
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calcMethodPick" {
            if let calcMethodViewController = segue.destination as? CalculationMethodTableViewController {
                calcMethodViewController.selectedCalcMethodLabel = calculationMethod
                calcMethodViewController.fajrWakeVCReference = self.fajrWakeVCReference
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // trigger action for "Get Current Location (GPS)" cell
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0 {
            fajrWakeVCReference!.startLocationDelegation()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "__________ IMPORTANT __________\nFor best results, keep this app running until alarm times. You may lock the device. If you choose not to keep this app running (not recommended) then make sure to switch your ringer ON and adjust your ringer volume."
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section == 1 {
            if let footerView = view as? UITableViewHeaderFooterView {
                footerView.textLabel?.textAlignment = .center
            }
        }
    }
}








