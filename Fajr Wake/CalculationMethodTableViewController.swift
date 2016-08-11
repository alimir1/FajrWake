//
//  CalculationMethodTableViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/17/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class CalculationMethodTableViewController: UITableViewController {
    
    // clean this up a little
    var selectedCalcMethodLabel: String? {
        didSet {
            if let calcMethod = selectedCalcMethodLabel {
                selectedCalcMethodIndex = calcMethods.indexOf(calcMethod)!
            }
        }
    }
    
    var selectedCalcMethodIndex: Int?
    
    var calcMethods: [String] = [
        CalculationMethods.Jafari.getString(),
        CalculationMethods.Karachi.getString(),
        CalculationMethods.Isna.getString(),
        CalculationMethods.Mwl.getString(),
        CalculationMethods.Makkah.getString(),
        CalculationMethods.Egypt.getString(),
        CalculationMethods.Tehran.getString()
    ]
    
    var fajrWakeVCReference: FajrWakeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcMethods.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CalcMethodCell", forIndexPath: indexPath)
        cell.textLabel?.text = calcMethods[indexPath.row]
         cell.textLabel?.numberOfLines = 0;
        
        if indexPath.row == selectedCalcMethodIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Please refer to an Islamic scholar if you aren't sure what calculation method to select."
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedCalcMethodIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedCalcMethodLabel = calcMethods[indexPath.row]
        
        if var saveSelectionIndex = selectedCalcMethodIndex {
            if saveSelectionIndex == 6 {
                saveSelectionIndex = 7
            }
            let settings = NSUserDefaults.standardUserDefaults()
            settings.setInteger(saveSelectionIndex, forKey: PrayerTimeSettingsReference.CalculationMethod.rawValue)
            fajrWakeVCReference!.updatePrayerTimes(NSDate())
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
}




































