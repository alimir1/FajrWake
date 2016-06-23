//
//  AddAlarmTableViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class AddAlarmTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
        
    @IBOutlet weak var alarmLabelDetail: UILabel!
    @IBOutlet weak var prayerTimesPicker: UIPickerView!
    var pickerData: [[String]] = [[String]]()
    var alarms: FajrWakeAlarm?
    var pickerArrayChoices: [Int] = []
    var maxElements = 10000
    var defaultFirstRow = (10000/2) - 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.prayerTimesPicker.delegate = self
        self.prayerTimesPicker.dataSource = self
        
        pickerData = [[], [WakeOptions.OnTime.rawValue, WakeOptions.Before.rawValue, WakeOptions.After.rawValue], [SalatsAndQadhas.Fajr.getString, "Qadha"]]
        
        for index in 0...59 {
            pickerData[0].append("\(index)")
        }
        
        // Default values of picker
        prayerTimesPicker.selectRow(defaultFirstRow, inComponent: 0, animated: true)
        prayerTimesPicker.selectRow(0, inComponent: 1, animated: true)
        prayerTimesPicker.selectRow(0, inComponent: 2, animated: true)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return maxElements
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
        let selectedRow = prayerTimesPicker.selectedRowInComponent(0)
        let titleForRow = self.pickerView(prayerTimesPicker, titleForRow: selectedRow, forComponent: 0)!
        
        if prayerTimesPicker.selectedRowInComponent(1) == 1 || prayerTimesPicker.selectedRowInComponent(1) == 2 {
            if titleForRow == "0" {
                prayerTimesPicker.selectRow(defaultFirstRow+1, inComponent: 0, animated: true)
            }
        }
        
        if prayerTimesPicker.selectedRowInComponent(1) == 0 && titleForRow != "0" {
            prayerTimesPicker.selectRow(defaultFirstRow, inComponent: 0, animated: true)
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight

    }
}