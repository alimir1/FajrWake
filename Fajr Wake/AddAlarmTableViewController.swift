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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.prayerTimesPicker.delegate = self
        self.prayerTimesPicker.dataSource = self
        
        pickerData = [["1min", "2min", "3min"],
                      ["Before", "At", "After"],
                      ["Fajr", "Sunrise"]]
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    
    // ===================== TESTING ===================

    // ===================== TESTING ===================
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight

    }
}