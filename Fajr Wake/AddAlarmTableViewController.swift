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
    var pickerChoices: [Int]? {
        didSet {
            if let choices = pickerChoices {
                fajrWakeAlarm.minsToAdjust = choices[0]
                fajrWakeAlarm.whenToAlarm = WakeOptions(rawValue: choices[1])!
                fajrWakeAlarm.whatSalatToAlarm = SalatsAndQadhas(rawValue: choices[2])!
            }
        }
    }
    var minsToAdjust: Int{
        return Int(self.pickerView(prayerTimesPicker, titleForRow: prayerTimesPicker.selectedRowInComponent(0), forComponent: 0)!)!
    }
    var whenToAlarm: Int {
        return prayerTimesPicker.selectedRowInComponent(1)
    }
    var whatSalatToAlarm: Int {
        return prayerTimesPicker.selectedRowInComponent(2)
    }
    let minsToAdjustComponent: Int = 0
    let whenToAlarmComponent: Int = 1
    let whatSalatToAlarmComponent: Int = 2
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
            pickerData[0].append("\(index)")
        }
        
        // Default values of picker
        prayerTimesPicker.selectRow(locOfZero+10, inComponent: 0, animated: true)
        prayerTimesPicker.selectRow(fajrWakeAlarm.whenToAlarm.rawValue, inComponent: 1, animated: true)
        prayerTimesPicker.selectRow(fajrWakeAlarm.whatSalatToAlarm.rawValue, inComponent: 2, animated: true)
        pickerChoices = [minsToAdjust, whenToAlarm, whatSalatToAlarm]
        
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
        if component == 0 {
            return maxElements // to create illusion of infinite scrolling for minutes
        } else {
            return pickerData[component].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let myRow = row % pickerData[0].count
            let numbers = pickerData[0][myRow]
            return numbers
        } else {
            return pickerData[component][row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if whenToAlarm == 1 || whenToAlarm == 2 {
            if minsToAdjust == 0 {
                prayerTimesPicker.selectRow(locOfZero+1, inComponent: 0, animated: true)
            }
        } else if whenToAlarm == 0 && minsToAdjust != 0 {
            prayerTimesPicker.selectRow(locOfZero, inComponent: 0, animated: true)
        }
        
        pickerChoices = [minsToAdjust, whenToAlarm, whatSalatToAlarm]
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

