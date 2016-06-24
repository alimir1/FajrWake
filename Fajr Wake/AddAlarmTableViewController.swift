//
//  AddAlarmTableViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import MediaPlayer

class AddAlarmTableViewController: UITableViewController {
    
    @IBOutlet weak var prayerTimesPicker: UIPickerView!
    @IBOutlet weak var repeatDetailLabel: UILabel!
    @IBOutlet weak var labelDetailLabel: UILabel!
    @IBOutlet weak var soundDetailLabel: UILabel!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    var labelObserver: String? {
        didSet {
            if let label = labelObserver {
                labelDetailLabel.text = label
                fajrWakeAlarm.alarmLabel = label
            }
        }
    }
    
    var repeatDaysObserver: [Days]? {
        didSet {
            if let daysToRepeat = repeatDaysObserver {
                repeatDetailLabel.text = DaysToRepeatLabel.getTextToRepeatDaysLabel(daysToRepeat)
                fajrWakeAlarm.daysToRepeat = daysToRepeat
            } else {
                repeatDetailLabel.text = "Never"
            }
        }
    }
    
    var soundObserver: String? {
        didSet {
            if let sound = soundObserver {
                soundDetailLabel.text = sound
                fajrWakeAlarm.sound = sound
            }
        }
    }
    
    let maxElements = 10000
    var locOfZero = (10000/2) - 20
    var fajrWakeAlarm = FajrWakeAlarm(whenToAlarm: .Before, whatSalatToAlarm: .Sunrise, minsToAdjust: 10, daysToRepeat: nil, snooze: true, alarmOn: true, alarmLabel: "Alarm", sound: "Munajat Imam Ali")

    
    // MARK: - Variables related to pickerview
    var pickerData: [[String]] = [[], ["On time", "Before", "After"], [SalatsAndQadhas.Fajr.getString, SalatsAndQadhas.Sunrise.getString]]
    var pickerChoices: (minsToAdjust: Int, whenToAlarm: Int, whatSalatToAlarm: Int)? {
        didSet {
            if let choices = pickerChoices {
                fajrWakeAlarm.minsToAdjust = choices.minsToAdjust
                fajrWakeAlarm.whenToAlarm = WakeOptions(rawValue: choices.whenToAlarm)!
                fajrWakeAlarm.whatSalatToAlarm = SalatsAndQadhas(rawValue: choices.whatSalatToAlarm)!
                
                // testing...
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
    
    @IBAction func cancel (sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Initial cycle of view controller
extension AddAlarmTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prayerTimesPicker.delegate = self
        self.prayerTimesPicker.dataSource = self
        
        setupPicker()
        
        labelObserver = "Alarm"
        repeatDaysObserver = nil
        soundObserver = "Munajat Imam Ali"
        
    }
}

// MARK: Navigation
extension AddAlarmTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
        }
    }
}

// MARK: - UIPickerView
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
        let hourLabel = UILabel(frame: CGRectMake(85, prayerTimesPicker.frame.size.height / 2 - 12, 75, 30))
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


// MARK: - UITableView
extension AddAlarmTableViewController {
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

