//
//  AlarmTypeViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/28/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class AlarmTypeViewController: UITableViewController {
    @IBOutlet weak var fajrWakeCell: UITableViewCell!
    @IBOutlet weak var customCell: UITableViewCell!
    
    var addAlarmChoicesListReference: AddAlarmChoicesContainer?

    var selectedCell: Int? {
        didSet(newlySelectedCell) {
            if let cell = selectedCell {
                if cell == AlarmType.FajrWakeAlarm.rawValue {
                    addAlarmChoicesListReference?.alarmType = AlarmType.FajrWakeAlarm
                } else if cell == AlarmType.CustomAlarm.rawValue {
                    addAlarmChoicesListReference?.alarmType = AlarmType.CustomAlarm
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCell == 0 {
            fajrWakeCell.accessoryType = .Checkmark
            customCell.accessoryType = .None
        } else if selectedCell == 1 {
            fajrWakeCell.accessoryType = .None
            customCell.accessoryType = .Checkmark
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedCell = indexPath.row
        if selectedCell == 0 {
            fajrWakeCell.accessoryType = .Checkmark
            customCell.accessoryType = .None
        } else {
            fajrWakeCell.accessoryType = .None
            customCell.accessoryType = .Checkmark
        }
    }
}
