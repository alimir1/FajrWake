//
//  AddAlarmTableViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class AddAlarmTableViewController: UITableViewController {
        
    @IBOutlet weak var alarmLabelDetail: UILabel!
    @IBOutlet weak var prayerTimesPicker: UIPickerView!
    
    let maxElements = 10000
    var locOfZero = (10000/2) - 20
    var fajrWakeAlarm = FajrWakeAlarm(whenToAlarm: .Before, whatSalatToAlarm: .Sunrise, minsToAdjust: 10, daysToRepeat: nil, snooze: true, alarmOn: true, alarmLabel: "Alarm")

    
    // MARK: - Variables related to pickerview
    var pickerData: [[String]] = [[], ["On time", "Before", "After"], [SalatsAndQadhas.Fajr.getString, SalatsAndQadhas.Sunrise.getString]]
    var pickerChoices: (minsToAdjust: Int, whenToAlarm: Int, whatSalatToAlarm: Int)? {
        didSet {
            if let choices = pickerChoices {
                fajrWakeAlarm.minsToAdjust = choices.minsToAdjust
                fajrWakeAlarm.whenToAlarm = WakeOptions(rawValue: choices.whenToAlarm)!
                fajrWakeAlarm.whatSalatToAlarm = SalatsAndQadhas(rawValue: choices.whatSalatToAlarm)!
                print("\(fajrWakeAlarm.minsToAdjust) min \(fajrWakeAlarm.whenToAlarm) \(fajrWakeAlarm.whatSalatToAlarm)\n")
            }
        }
    }
    
    let minsToAdjustComponent: Int = 0
    let whenToAlarmComponent: Int = 1
    let whatSalatToAlarmComponent: Int = 2
    
    var minsToAdjust: Int {
        return Int(self.pickerView(prayerTimesPicker, titleForRow: prayerTimesPicker.selectedRowInComponent(minsToAdjustComponent), forComponent: minsToAdjustComponent)!)!
    }
    var whenToAlarm: Int {
        return prayerTimesPicker.selectedRowInComponent(whenToAlarmComponent)
    }
    var whatSalatToAlarm: Int {
        return prayerTimesPicker.selectedRowInComponent(whatSalatToAlarmComponent)
    }
}

// MARK: - Initial cycle of view controller
extension AddAlarmTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prayerTimesPicker.delegate = self
        self.prayerTimesPicker.dataSource = self
        
        setupPicker()
        
    }
}

// MARK: - UIPickerView Configuration
extension AddAlarmTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // picker setup
    func setupPicker() {
        // filling minutes for first components
        for index in 0...59 {
            pickerData[minsToAdjustComponent].append("\(index)")
        }
        
        // Default values of picker
        prayerTimesPicker.selectRow(locOfZero+10, inComponent: minsToAdjustComponent, animated: true)
        prayerTimesPicker.selectRow(fajrWakeAlarm.whenToAlarm.rawValue, inComponent: whenToAlarmComponent, animated: true)
        prayerTimesPicker.selectRow(fajrWakeAlarm.whatSalatToAlarm.rawValue, inComponent: whatSalatToAlarmComponent, animated: true)
        pickerChoices = (minsToAdjust: minsToAdjust, whenToAlarm: whenToAlarm, whatSalatToAlarm: whatSalatToAlarm)
        
        // "min" label
        let hourLabel = UILabel(frame: CGRectMake(73, prayerTimesPicker.frame.size.height / 2 - 12, 75, 30))
        hourLabel.text = "min"
        hourLabel.font = UIFont.boldSystemFontOfSize(14)
        prayerTimesPicker.addSubview(hourLabel)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == minsToAdjustComponent {
            return maxElements // to create illusion of infinite scrolling for minutes
        } else {
            return pickerData[component].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == minsToAdjustComponent {
            let myRow = row % pickerData[minsToAdjustComponent].count
            let numbers = pickerData[minsToAdjustComponent][myRow]
            return numbers
        } else {
            return pickerData[component][row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if whenToAlarm == 1 || whenToAlarm == 2 {
            if minsToAdjust == 0 {
                prayerTimesPicker.selectRow(locOfZero+1, inComponent: minsToAdjustComponent, animated: true)
            }
        } else if whenToAlarm == 0 && minsToAdjust != 0 {
            prayerTimesPicker.selectRow(locOfZero, inComponent: minsToAdjustComponent, animated: true)
        }
        
        pickerChoices = (minsToAdjust: minsToAdjust, whenToAlarm: whenToAlarm, whatSalatToAlarm: whatSalatToAlarm)
    }
}


// MARK: - UITableView Configuration
extension AddAlarmTableViewController {
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight
    }
}

