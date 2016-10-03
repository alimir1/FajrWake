//
//  AddAlarmViewController.swift
//  Fajr Wake
//
//  Created by Ali Mir on 6/25/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class AddAlarmMasterViewController: UIViewController {
    @IBOutlet weak var fajrAlarmContainer: UIView!
    @IBOutlet weak var customAlarmContainer: UIView!
    @IBOutlet weak var choicesTableViewContainer: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var alarmClock: AlarmClockType?
    
    var alarmType: AlarmType? {
        didSet {
            if let alarmtype = alarmType {
                if alarmtype == .fajrWakeAlarm {
                    alphaSettingsForAlarmContainers(fajrAlpha: 1.0, customAlpha: 0.0)
                } else if alarmtype == .customAlarm {
                    alphaSettingsForAlarmContainers(fajrAlpha: 0.0, customAlpha: 1.0)
                }
            }
        }
    }
    var alarmLabel: String?
    var sound: AlarmSound?
    var snooze: Bool?
    var pickerTime: Date?
    var minsToAdjust: Int?
    var whenToWake: WakeOptions?
    var whatSalatToWake: SalatsAndQadhas?

    override func viewDidLoad() {
        super.viewDidLoad()
        if alarmClock == nil {
            alphaSettingsForAlarmContainers(fajrAlpha: 1.0, customAlpha: 0.0)
        }
    }
    
    @IBAction func cancel (_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func alphaSettingsForAlarmContainers(fajrAlpha: CGFloat, customAlpha: CGFloat) {
        fajrAlarmContainer.alpha = fajrAlpha
        customAlarmContainer.alpha = customAlpha
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as AnyObject? {
            if alarmType != nil {
                if alarmType! == .fajrWakeAlarm {
                    alarmClock = FajrWakeAlarm(alarmLabel: self.alarmLabel!, sound: self.sound!, snooze: snooze!, minsToAdjust: minsToAdjust!, whenToWake: whenToWake!, whatSalatToWake: whatSalatToWake!, alarmType: .fajrWakeAlarm, alarmOn: true)
                } else if alarmType! == .customAlarm {
                    alarmClock = CustomAlarm(alarmLabel: self.alarmLabel!, sound: self.sound!, snooze: self.snooze!, time: pickerTime!, alarmType: .customAlarm, alarmOn: true)
                }
            }
        }
        
        if let segueIdentifier = segue.identifier {
            if let alarm = alarmClock {
                // Edit Alarm
                alarmType = alarm.alarmType
                if alarm.alarmType == .fajrWakeAlarm {
                    // Reset (default) for CustomAlarm
                    pickerTime = Date()
                    
                    // Load values for FajrWakeAlarm
                    let fajrWakeAlarm: FajrWakeAlarm = alarm as! FajrWakeAlarm
                    minsToAdjust = fajrWakeAlarm.minsToAdjust
                    whenToWake = fajrWakeAlarm.whenToWake
                    whatSalatToWake = fajrWakeAlarm.whatSalatToWake
                } else if alarm.alarmType == .customAlarm {
                    // Reset (default) for FajrWakeAlarm
                    minsToAdjust = 0
                    whenToWake = .onTime
                    whatSalatToWake = .fajr
                    
                    // Load values for CustomAlarm
                    let customAlarm: CustomAlarm = alarm as! CustomAlarm
                    pickerTime = customAlarm.time as Date
                }
            } else {
                // Add Alarm
                pickerTime = Date()
                minsToAdjust = 0
                whenToWake = .onTime
                whatSalatToWake = .fajr
            }

            switch segueIdentifier {
            case "fajrWakePickerContainer":
                let fajrAlarmPickerVCContainer = segue.destination as! FajrAlarmPickerVCContainer
                fajrAlarmPickerVCContainer.AddAlarmMasterVCReference = self
                
            case "customAlarmPickerContainer":
                let customAlarmPickerVCContainer = segue.destination as! CustomAlarmPickerVCContainer
                customAlarmPickerVCContainer.AddAlarmMasterVCReference = self

            case "addAlarmChoicesContainer":
                let addAlarmChoicesContainer = segue.destination as! AddAlarmChoicesContainer
                addAlarmChoicesContainer.AddAlarmMasterVCReference = self
                
                if let alarm = alarmClock {
                    // Edit Alarm
                    if alarm.alarmType == .customAlarm {
                        if let customAlarm = alarm as? CustomAlarm {
                            alarmType = customAlarm.alarmType
                            alarmLabel = customAlarm.alarmLabel
                            sound = customAlarm.sound
                            snooze = customAlarm.snooze
                        }
                    } else if alarm.alarmType == .fajrWakeAlarm {
                        if let fajrWakeAlarm = alarm as? FajrWakeAlarm {
                            alarmType = fajrWakeAlarm.alarmType
                            alarmLabel = fajrWakeAlarm.alarmLabel
                            sound = fajrWakeAlarm.sound
                            snooze = fajrWakeAlarm.snooze
                        }
                    }
                } else {
                    // Add Alarm
                    alarmType = .fajrWakeAlarm
                    alarmLabel = "Alarm"
                    let defaultSound = UserDefaults.standard.object(forKey: "DefaultSound") as? String
                    let defaultSoundTitle = UserDefaults.standard.object(forKey: "DefaultSoundTitle") as? String
                    sound = AlarmSound(alarmSound: AlarmSounds(rawValue: defaultSound!)!, alarmSectionTitle: AlarmSoundsSectionTitles(rawValue: defaultSoundTitle!)!)
                    snooze = true
                    addAlarmChoicesContainer.tableView.isScrollEnabled = false
                    addAlarmChoicesContainer.deleteAlarmCell.isHidden = true
                }
            default:
                break
            }
        }
    }
}
