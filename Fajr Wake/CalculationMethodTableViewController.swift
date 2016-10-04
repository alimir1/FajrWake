//
//  CalculationMethodTableViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 6/17/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class CalculationMethodTableViewController: UITableViewController {
    
    // clean this up a little
    var selectedCalcMethodLabel: String? {
        didSet {
            if let calcMethod = selectedCalcMethodLabel {
                selectedCalcMethodIndex = calcMethods.index(of: calcMethod)!
            }
        }
    }
    
    var selectedCalcMethodIndex: Int?
    
    var calcMethods: [String] = [
        CalculationMethods.jafari.getString(),
        CalculationMethods.karachi.getString(),
        CalculationMethods.isna.getString(),
        CalculationMethods.mwl.getString(),
        CalculationMethods.makkah.getString(),
        CalculationMethods.egypt.getString(),
        CalculationMethods.tehran.getString()
    ]
    
    var fajrWakeVCReference: FajrWakeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcMethods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalcMethodCell", for: indexPath)
        cell.textLabel?.text = calcMethods[(indexPath as NSIndexPath).row]
        cell.textLabel?.numberOfLines = 0;
        
        if (indexPath as NSIndexPath).row == selectedCalcMethodIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Please refer to an Islamic scholar if you aren't sure what calculation method to select."
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedCalcMethodIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedCalcMethodLabel = calcMethods[(indexPath as NSIndexPath).row]
        
        if var saveSelectionIndex = selectedCalcMethodIndex {
            if saveSelectionIndex == 6 {
                saveSelectionIndex = 7
            }
            let settings = UserDefaults.standard
            settings.set(saveSelectionIndex, forKey: PrayerTimeSettingsReference.CalculationMethod.rawValue)
        }
        
//        alarms[selectedIndexPath.row].stopAlarm()
//        alarms[selectedIndexPath.row].deleteLocalNotifications()
//        alarms[selectedIndexPath.row] = alarm
//        setupAlarmsAndUpdate(selectedIndexPath)
        
        for (index, _) in fajrWakeVCReference!.alarms.enumerated() {
            fajrWakeVCReference!.alarms[index].stopAlarm()
            fajrWakeVCReference!.alarms[index].deleteLocalNotifications()
            fajrWakeVCReference!.setupAlarmsAndUpdate(IndexPath(row: index, section: 0))
        }
        
        fajrWakeVCReference!.tableView.reloadData()
        
        let settings = UserDefaults.standard
        let lon = settings.double(forKey: "longitude")
        let lat = settings.double(forKey: "latitude")
        let gmt = settings.double(forKey: "gmt")
        let userPrayerTime = UserSettingsPrayertimes()
        
        let testTimes = userPrayerTime.getUserSettings().getPrayerTimes(Calendar.current, date: Date(), latitude: lat, longitude: lon, tZone: gmt)
        
        fajrWakeVCReference!.updatePrayerTimes(Date())
        
        print("Fajr: \(testTimes["Fajr"])")
        
        // update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
}




































