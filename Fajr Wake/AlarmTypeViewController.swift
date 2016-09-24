//
//  AlarmTypeViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 6/28/16.
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
                if cell == AlarmType.fajrWakeAlarm.rawValue {
                    addAlarmChoicesListReference?.alarmType = AlarmType.fajrWakeAlarm
                } else if cell == AlarmType.customAlarm.rawValue {
                    addAlarmChoicesListReference?.alarmType = AlarmType.customAlarm
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCell == 0 {
            fajrWakeCell.accessoryType = .checkmark
            customCell.accessoryType = .none
        } else if selectedCell == 1 {
            fajrWakeCell.accessoryType = .none
            customCell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCell = (indexPath as NSIndexPath).row
        if selectedCell == 0 {
            fajrWakeCell.accessoryType = .checkmark
            customCell.accessoryType = .none
        } else {
            fajrWakeCell.accessoryType = .none
            customCell.accessoryType = .checkmark
        }
    }
}
