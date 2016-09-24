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
    
    @IBAction func switchSnooze(_ sender: UISwitch) {
        snooze = sender.isOn
    }
    
    var alarmType: AlarmType? {
        didSet {
            if let alarmtype = alarmType {
                if alarmtype == .fajrWakeAlarm {
                    AddAlarmMasterVCReference?.alarmType = .fajrWakeAlarm
                    alarmTypeDetailLabel.text = AlarmType.fajrWakeAlarm.getString
                } else if alarmtype == .customAlarm {
                    AddAlarmMasterVCReference?.alarmType = .customAlarm
                    alarmTypeDetailLabel.text = AlarmType.customAlarm.getString
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
        
        snoozeSwitch.onTintColor = UIColor(red: 0.9294, green: 0.298, blue: 0.2588, alpha: 1.0) /* #ed4c42 */
        
        // first load defaults (in case of "Add Alarm") OR load saved alarm (in case of "edit alarm")
        // variables declared in "prepareForSegue" in AddAlarmMasterVC
        alarmType = AddAlarmMasterVCReference?.alarmType
        alarmLabelText = AddAlarmMasterVCReference?.alarmLabel
        alarmSound = AddAlarmMasterVCReference?.sound
        snooze = AddAlarmMasterVCReference?.snooze
    }
    
    @IBAction func unwindAlarmLabel(_ sender: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "alarmTypeSegue":
                if let alarmTypeVC = segue.destination as? AlarmTypeViewController {
                    alarmTypeVC.addAlarmChoicesListReference = self
                    alarmTypeVC.selectedCell = alarmType?.rawValue
                }
            case "alarmLabelSegue":
                if let alarmLabelVC = segue.destination as? LabelSettingsViewController {
                    alarmLabelVC.addAlarmChoicesListReference = self
                    alarmLabelVC.alarmLabelText = alarmLabelText
                }
            case "soundSegue":
                if let soundSettingsVC = segue.destination as? SoundSettingsViewController {
                    soundSettingsVC.addAlarmChoicesListReference = self
                    soundSettingsVC.selectedSound = alarmSound
                }
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if (indexPath as NSIndexPath).section == 0 {
            switch (indexPath as NSIndexPath).row {
            case 0: cell.imageView!.image = UIImage(named: "Clock 2.png")!
            case 1: cell.imageView!.image = UIImage(named: "Clipboard.png")!
            case 2: cell.imageView!.image = UIImage(named: "Music Note 1.png")!
            case 3: cell.imageView!.image = UIImage(named: "Bell.png")!
            default: cell.imageView!.image = nil
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            if let footerView = view as? UITableViewHeaderFooterView {
                footerView.textLabel?.textAlignment = .center
            }
        }
    }
    
}










