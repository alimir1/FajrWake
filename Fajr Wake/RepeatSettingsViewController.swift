//
//  RepeatSettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/24/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class RepeatSettingsViewController: UITableViewController {
    
    struct Day {
        var name: String
        var selected: Bool
        
        init(_ name: String, _ selected:Bool) {
            self.name = name
            self.selected = selected
        }
    }
    
    var selectionStateIndicator = false
    var dayItems: [Day] = {
        var _days = [Day]()
        var dayNames = [Days.Sunday.rawValue, Days.Monday.rawValue, Days.Tuesday.rawValue, Days.Wednesday.rawValue, Days.Thursday.rawValue, Days.Friday.rawValue, Days.Saturday.rawValue]
        
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
        dayItems[indexPath.row].selected = !dayItems[indexPath.row].selected
        if !dayItems[indexPath.row].selected {
            cell?.accessoryType = .None
        } else {
            cell?.accessoryType = .Checkmark
        }
    }

}
