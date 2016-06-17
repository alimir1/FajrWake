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
    
    var calculationMethod: String = CalculationMethods.Tehran.getString() {
        didSet {
            detail.text? = calculationMethod
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let settingsCalcMethod = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.CalculationMethod.rawValue)
//        let calcMethodText = CalculationMethods(rawValue: settingsCalcMethod)!.getString()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        

        if segue.identifier == "calcMethodPick" {
            if let calcMethodViewController = segue.destinationViewController as? CalculationMethodTableViewController {
                calcMethodViewController.selectedCalcMethodLabel = calculationMethod
            }
        }
    }
    
    @IBAction func unwindWithSelectedCalcMethod(segue:UIStoryboardSegue) {
        if let calcMethodViewController = segue.sourceViewController as? CalculationMethodTableViewController,
            selectedCalcMethod = calcMethodViewController.selectedCalcMethodLabel {
            calculationMethod = selectedCalcMethod
        }
    }
}
