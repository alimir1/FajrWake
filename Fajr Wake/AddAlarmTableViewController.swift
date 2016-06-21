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
        
        pickerData = [[], ["Before", "At", "After"], ["Fajr", "Sunrise"]]
        
    }
    

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        for index in 0...59 {
            pickerData[0].append("\(index) m")
        }
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight

    }
}