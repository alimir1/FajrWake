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
    @IBOutlet weak var soundDetailLabel: UILabel!
    @IBOutlet weak var alarmTypeDetailLabel: UILabel!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var deleteAlarmCell: UITableViewCell!
    
    var AddAlarmMasterVCReference: AddAlarmMasterViewController?

    @IBAction func switchSnooze(sender: UISwitch) {
        snooze = sender.on
    }
    
    var alarmType: AlarmType? {
        didSet {
            if let alarmtype = alarmType {
                if alarmtype == .FajrWakeAlarm {
                    AddAlarmMasterVCReference?.alarmType = .FajrWakeAlarm
                    alarmTypeDetailLabel.text = AlarmType.FajrWakeAlarm.getString
                } else if alarmtype == .CustomAlarm {
                    AddAlarmMasterVCReference?.alarmType = .CustomAlarm
                    alarmTypeDetailLabel.text = AlarmType.CustomAlarm.getString
                }
            }
        }
    }
    
    var alarmLabelText: String? {
        didSet {
            labelDetailLabel.text = alarmLabelText
            AddAlarmMasterVCReference?.alarmLabel = alarmLabelText
        }
    }
    
    var alarmSound: AlarmSound? {
        didSet {
            soundDetailLabel.text = alarmSound?.alarmSound.rawValue
            AddAlarmMasterVCReference?.sound = alarmSound
        }
    }
    
    var snooze: Bool? {
        didSet {
            if snooze != nil {
                snoozeSwitch.setOn(snooze!, animated: true)
                AddAlarmMasterVCReference?.snooze = snooze
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // first load defaults (in case of "Add Alarm") OR load saved alarm (in case of "edit alarm")
        //   variables declared in "prepareForSegue" in AddAlarmMasterVC
        alarmType = AddAlarmMasterVCReference?.alarmType
        alarmLabelText = AddAlarmMasterVCReference?.alarmLabel
        alarmSound = AddAlarmMasterVCReference?.sound
        snooze = AddAlarmMasterVCReference?.snooze
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
            case "alarmLabelSegue":
                if let alarmLabelVC = segue.destinationViewController as? LabelSettingsViewController {
                    alarmLabelVC.addAlarmChoicesListReference = self
                    alarmLabelVC.alarmLabelText = alarmLabelText
                }
            case "soundSegue":
                if let soundSettingsVC = segue.destinationViewController as? SoundSettingsViewController {
                    soundSettingsVC.addAlarmChoicesListReference = self
                    soundSettingsVC.selectedSound = alarmSound
                }
            default:
                break
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let settings = NSUserDefaults.standardUserDefaults()
        let lon = settings.doubleForKey("longitude")
        let lat = settings.doubleForKey("latitude")
        let gmt = settings.doubleForKey("gmt")
        let userPrayerTime = UserSettingsPrayertimes()
        
        let prayerTimes = userPrayerTime.getUserSettings().getPrayerTimes(NSCalendar.currentCalendar(), date: NSDate(), latitude: lat, longitude: lon, tZone: gmt)
        
        let fajr = prayerTimes["Fajr"]
        let sunrise = prayerTimes["Sunrise"]
        
        if section == 0 {
            return "Fajr: \(fajr!) \t\t Sunrise: \(sunrise!)"
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            if let footerView = view as? UITableViewHeaderFooterView {
                footerView.textLabel?.textAlignment = .Center
            }
        }
    }

}










