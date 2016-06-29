//
//  AddAlarmChoicesTableViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/25/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class AddAlarmChoicesContainer: UITableViewController {
    @IBOutlet weak var labelDetailLabel: UILabel!
    @IBOutlet weak var repeatDetailLabel: UILabel!
    @IBOutlet weak var soundDetailLabel: UILabel!
    @IBOutlet weak var alarmTypeDetailLabel: UILabel!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var deleteAlarmButton: UILabel!
    
    var AddAlarmMasterVCReference: AddAlarmMasterViewController?
    
    var alarmType: AlarmType? {
        didSet {
            if let alarmtype = alarmType {
                if alarmtype == .FajrWakeAlarm {
                    AddAlarmMasterVCReference?.alarmType = .FajrWakeAlarm
                    alarmTypeDetailLabel.text = "Fajr Wake Alarm"
                } else if alarmtype == .CustomAlarm {
                    AddAlarmMasterVCReference?.alarmType = .CustomAlarm
                    alarmTypeDetailLabel.text = "Custom Alarm"
                }
            }
        }
    }
    
    var repeatDays: [Days]? {
        didSet {
            if let days = repeatDays {
                repeatDetailLabel.text = DaysToRepeatLabel.getTextToRepeatDaysLabel(days)
                AddAlarmMasterVCReference?.daysToRepeat = days
            } else {
                repeatDetailLabel.text = "Never"
            }
        }
    }
    
    var alarmLabelText: String? {
        didSet {
            labelDetailLabel.text = alarmLabelText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // these needs to change... depending on if user wants to "adds new alarm" or if they edit it
        alarmType = .FajrWakeAlarm
        repeatDays = nil
        alarmLabelText = "Alarm"
        
    }
    
    @IBAction func unwindAlarmLabel(sender: UIStoryboardSegue) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "alarmTypeSegue":
                if let alarmTypeVC = segue.destinationViewController as? AlarmTypeViewController {
                    alarmTypeVC.addAlarmChoicesListReference = self
                    alarmTypeVC.selectedCell = alarmType?.rawValue
                }
            case "repeatDaysSegue":
                if let repeatDaysVC = segue.destinationViewController as? RepeatSettingsViewController {
                    repeatDaysVC.addAlarmChoicesListReference = self
                    if let days = repeatDays {
                        for day in days {
                            repeatDaysVC.selectedIndexPath = NSIndexPath(forRow: day.rawValue, inSection: 0)
                        }
                    }
                }
            case "alarmLabelSegue":
                if let alarmLabelVC = segue.destinationViewController as? LabelSettingsViewController {
                    alarmLabelVC.addAlarmChoicesListReference = self
                    alarmLabelVC.alarmLabelText = alarmLabelText
                }
            default:
                break
            }
        }
    }
}










