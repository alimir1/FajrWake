//
//  FajrAlarmPickerVCContainer.swift
//  Fajr Wake
//
//  Created by Abidi on 6/26/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class FajrAlarmPickerVCContainer: UIViewController {
    @IBOutlet weak var prayerTimesPicker: UIPickerView!
    
    var AddAlarmMasterVCReference: AddAlarmMasterViewController?
    
    /*
     This value is either passed by `FajrWakeTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var fajrWakeAlarm: FajrWakeAlarm?
    
    var whenToAlarm: WakeOptions {
        let whenToAlarmINT = prayerTimesPicker.selectedRowInComponent(whenToAlarmComponent)
        return WakeOptions(rawValue: whenToAlarmINT)!
    }
    var salatToAlarm: SalatsAndQadhas {
        let salatToAlarmINT = prayerTimesPicker.selectedRowInComponent(whatSalatToAlarmComponent)
        return SalatsAndQadhas(rawValue: salatToAlarmINT)!
    }
    var minsToAdjustAlarm: Int {
        let minsToAdjust = self.pickerView(prayerTimesPicker, titleForRow: prayerTimesPicker.selectedRowInComponent(minsToAdjustComponent), forComponent: minsToAdjustComponent)!
        return Int(minsToAdjust)!
    }
    
    let maxElements = 10000
    var locOfZero = (10000/2) - 20
    var pickerData: [[String]] = [[], ["On time", "Before", "After"], [SalatsAndQadhas.Fajr.getString, SalatsAndQadhas.Sunrise.getString]]
    let minsToAdjustComponent: Int = 0
    let whenToAlarmComponent: Int = 1
    let whatSalatToAlarmComponent: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prayerTimesPicker.delegate = self
        self.prayerTimesPicker.dataSource = self
        
        // Set up alarm
        if let alarm = fajrWakeAlarm {
            setupFajrAlarm(minsToAdjust: alarm.minsToAdjust, whenToAlarm: alarm.whenToWake.rawValue, whatSalatToAlarm: alarm.whatSalatToWake.rawValue)
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

// MARK: - UIPickerView
extension FajrAlarmPickerVCContainer: UIPickerViewDelegate, UIPickerViewDataSource {
    // setup alarm
    func setupFajrAlarm(minsToAdjust minsToAdjust: Int = 10, whenToAlarm: Int = 1, whatSalatToAlarm: Int = 2) {
        
        // populate first components with minutes
        for index in 0...59 {
            pickerData[minsToAdjustComponent].append("\(index)")
        }
        prayerTimesPicker.selectRow(locOfZero+minsToAdjust, inComponent: minsToAdjustComponent, animated: true)
        prayerTimesPicker.selectRow(whenToAlarm, inComponent: whenToAlarmComponent, animated: true)
        prayerTimesPicker.selectRow(whatSalatToAlarm, inComponent: whatSalatToAlarmComponent, animated: true)
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





