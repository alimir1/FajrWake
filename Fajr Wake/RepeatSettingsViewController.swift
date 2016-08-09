//
//  RepeatSettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/24/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//  
//  THIS CONTROLLER IS CURRENTLY NOT BEING USED
//

import UIKit

class RepeatSettingsViewController: UITableViewController {
    
    var addAlarmChoicesListReference: AddAlarmChoicesContainer?
    var repeatDays: [Days] = []
    
    var selectedIndexPath: NSIndexPath? {
        didSet {
            if let row = selectedIndexPath?.row {
                dayItems[row].selected = !dayItems[row].selected
                if dayItems[row].selected == true {
                    repeatDays.append(Days(rawValue: row)!)
                } else {
                    if let testIndex = repeatDays.indexOf(Days(rawValue: row)!) {
                        repeatDays.removeAtIndex(testIndex)
                    }
                }
            }
            ///////////// sorting array //////////////////
            repeatDays.sortInPlace { (first, second) in
                let dayNames = [Days.Monday, Days.Tuesday, Days.Wednesday, Days.Thursday, Days.Friday, Days.Saturday, Days.Sunday]
                guard let index1 = dayNames.indexOf(first), index2 = dayNames.indexOf(second) else {
                    return false
                }
                return index1 < index2
            }
            //////////////////////////////////////////////
            if repeatDays.count != 0 {
                addAlarmChoicesListReference?.repeatDays = repeatDays
            } else {
                addAlarmChoicesListReference?.repeatDays = nil
            }
        }
    }
    
    struct Day {
        var name: String
        var selected: Bool
        
        init(_ name: String, _ selected:Bool) {
            self.name = name
            self.selected = selected
        }
    }
    
    var dayItems: [Day] = {
        var _days = [Day]()
        let dayNames = [Days.Sunday.getString, Days.Monday.getString, Days.Tuesday.getString, Days.Wednesday.getString, Days.Thursday.getString, Days.Friday.getString, Days.Saturday.getString]
        
        for day in dayNames {
            _days.append(Day(day, false))
        }
        
        return _days
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayItems.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("daysID", forIndexPath: indexPath)

        cell.textLabel?.text = "Every \(self.dayItems[indexPath.row].name)"
        cell.accessoryType = self.dayItems[indexPath.row].selected ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        selectedIndexPath = indexPath
        
        if !dayItems[indexPath.row].selected {
            cell?.accessoryType = .None
        } else {
            cell?.accessoryType = .Checkmark
        }
    }

}
