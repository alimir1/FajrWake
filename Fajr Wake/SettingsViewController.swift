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
    }
    
    
    @IBAction func unwindWithSelectedCalcMethod (segue:UIStoryboardSegue) {
        if let calcMethodPickerViewController = segue.sourceViewController as? CalculationMethodTableViewController,
            selectedCalcMethod = calcMethodPickerViewController.selectedCalcMethod {
            calculationMethod = selectedCalcMethod
        }
    }
}
