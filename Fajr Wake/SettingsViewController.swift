//
//  SettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/17/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var detail: UILabel!
    
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
