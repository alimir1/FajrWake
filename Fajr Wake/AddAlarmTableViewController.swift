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
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var alarmLabel: String? {
        didSet {
            if let label = alarmLabel {
                labelDetailLabel.text = label
            }
        }
    }
    
    var daysToRepeat: [Days]? {
        didSet {
            if let daysToRepeat = daysToRepeat {
                repeatDetailLabel.text = DaysToRepeatLabel.getTextToRepeatDaysLabel(daysToRepeat)
            } else {
                repeatDetailLabel.text = "Never"
            }
        }
    }
    
    var selectedSound: String? {
        didSet {
            if let sound = selectedSound {
                soundDetailLabel.text = sound
            }
        }
    }
    
    var whenToAlarm: WakeOptions {
        let whenToAlarmINT = prayerTimesPicker.selectedRowInComponent(whenToAlarmComponent)
        return WakeOptions(rawValue: whenToAlarmINT)!
    }
    var salatToAlarm: SalatsAndQadhas {
        let salatToAlarmINT = prayerTimesPicker.selectedRowInComponent(whatSalatToAlarmComponent)
        return SalatsAndQadhas(rawValue: salatToAlarmINT)!
    }
    var minsToAdjustAlarm: Int {
        return Int(self.pickerView(prayerTimesPicker, titleForRow: prayerTimesPicker.selectedRowInComponent(minsToAdjustComponent), forComponent: minsToAdjustComponent)!)!
    }
    var snooze: Bool?
    
    
    
    let maxElements = 10000
    var locOfZero = (10000/2) - 20
    
    /*
     This value is either passed by `FajrWakeTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var fajrWakeAlarm: FajrWakeAlarm?

    
    // MARK: - Variables related to pickerview
    var pickerData: [[String]] = [[], ["On time", "Before", "After"], [SalatsAndQadhas.Fajr.getString, SalatsAndQadhas.Sunrise.getString]]
    
    let minsToAdjustComponent: Int = 0
    let whenToAlarmComponent: Int = 1
    let whatSalatToAlarmComponent: Int = 2
    
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
        
        // Set up alarm
        if let alarm = fajrWakeAlarm {
            setupFajrAlarm(minsToAdjust: alarm.minsToAdjust, whenToAlarm: alarm.whenToAlarm.rawValue, whatSalatToAlarm: alarm.whatSalatToAlarm.rawValue, daysToRepeat: alarm.daysToRepeat, snooze: alarm.snooze, alarmLabel: alarm.alarmLabel, selectedSound: alarm.sound)
        }else {
            setupFajrAlarm()
        }
        
        // "min" label
        let hourLabel = UILabel(frame: CGRectMake(85, prayerTimesPicker.frame.size.height / 2 - 12, 75, 30))
        hourLabel.text = "min"
        hourLabel.font = UIFont.boldSystemFontOfSize(14)
        prayerTimesPicker.addSubview(hourLabel)
    }
}

// MARK: Navigation
extension AddAlarmTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            fajrWakeAlarm = FajrWakeAlarm(whenToAlarm: whenToAlarm, whatSalatToAlarm: salatToAlarm, minsToAdjust: minsToAdjustAlarm, daysToRepeat: daysToRepeat, snooze: snooze!, alarmLabel: alarmLabel!, sound: selectedSound!)
        }
    }
}

// MARK: - UIPickerView
extension AddAlarmTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // setup alarm
    func setupFajrAlarm(minsToAdjust minsToAdjust: Int = 10, whenToAlarm: Int = 1, whatSalatToAlarm: Int = 2, daysToRepeat: [Days]? = nil, snooze: Bool = true, alarmLabel: String = "Alarm", selectedSound: String = "Munajat Imam Ali") {
        
        // populate first components with minutes
        for index in 0...59 {
            pickerData[minsToAdjustComponent].append("\(index)")
        }
        
        prayerTimesPicker.selectRow(locOfZero+minsToAdjust, inComponent: minsToAdjustComponent, animated: true)
        prayerTimesPicker.selectRow(whenToAlarm, inComponent: whenToAlarmComponent, animated: true)
        prayerTimesPicker.selectRow(whatSalatToAlarm, inComponent: whatSalatToAlarmComponent, animated: true)
        self.daysToRepeat = daysToRepeat
        self.snooze = snooze
        self.alarmLabel = alarmLabel
        self.selectedSound = selectedSound
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
        if whenToAlarm.rawValue == 1 || whenToAlarm.rawValue == 2 {
            if minsToAdjustAlarm == 0 {
                prayerTimesPicker.selectRow(locOfZero+1, inComponent: minsToAdjustComponent, animated: true)
            }
        } else if whenToAlarm.rawValue == 0 && minsToAdjustAlarm != 0 {
            prayerTimesPicker.selectRow(locOfZero, inComponent: minsToAdjustComponent, animated: true)
        }
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

