//
//  AddAlarmViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/25/16.
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
                if alarmtype == .FajrWakeAlarm {
                    alphaSettingsForAlarmContainers(fajrAlpha: 1.0, customAlpha: 0.0)
                } else if alarmtype == .CustomAlarm {
                    alphaSettingsForAlarmContainers(fajrAlpha: 0.0, customAlpha: 1.0)
                }
            }
        }
    }
    var alarmLabel: String?
//    var daysToRepeat: [Days]?
    var sound: AlarmSound?
    var snooze: Bool?
    var pickerTime: NSDate?
    var minsToAdjust: Int?
    var whenToWake: WakeOptions?
    var whatSalatToWake: SalatsAndQadhas?

    override func viewDidLoad() {
        super.viewDidLoad()
        if alarmClock == nil {
            alphaSettingsForAlarmContainers(fajrAlpha: 1.0, customAlpha: 0.0)
        }
    }
    
    @IBAction func cancel (sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alphaSettingsForAlarmContainers(fajrAlpha fajrAlpha: CGFloat, customAlpha: CGFloat) {
        fajrAlarmContainer.alpha = fajrAlpha
        customAlarmContainer.alpha = customAlpha
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if alarmType != nil {
                if alarmType! == .FajrWakeAlarm {
                    alarmClock = FajrWakeAlarm(alarmLabel: self.alarmLabel!, sound: self.sound!, snooze: snooze!, minsToAdjust: minsToAdjust!, whenToWake: whenToWake!, whatSalatToWake: whatSalatToWake!, alarmType: .FajrWakeAlarm, alarmOn: true)
                } else if alarmType! == .CustomAlarm {
                    alarmClock = CustomAlarm(alarmLabel: self.alarmLabel!, sound: self.sound!, snooze: self.snooze!, time: pickerTime!, alarmType: .CustomAlarm, alarmOn: true)
                }
            }
        }
        
        if let segueIdentifier = segue.identifier {
            if let alarm = alarmClock {
                // Edit Alarm
                alarmType = alarm.alarmType
                if alarm.alarmType == .FajrWakeAlarm {
                    // Reset (default) for CustomAlarm
                    pickerTime = NSDate()
                    
                    // Load values for FajrWakeAlarm
                    let fajrWakeAlarm: FajrWakeAlarm = alarm as! FajrWakeAlarm
                    minsToAdjust = fajrWakeAlarm.minsToAdjust
                    whenToWake = fajrWakeAlarm.whenToWake
                    whatSalatToWake = fajrWakeAlarm.whatSalatToWake
                } else if alarm.alarmType == .CustomAlarm {
                    // Reset (default) for FajrWakeAlarm
                    minsToAdjust = 10
                    whenToWake = .Before
                    whatSalatToWake = .Sunrise
                    
                    // Load values for CustomAlarm
                    let customAlarm: CustomAlarm = alarm as! CustomAlarm
                    pickerTime = customAlarm.time
                }
            } else {
                // Add Alarm
                pickerTime = NSDate()
                minsToAdjust = 10
                whenToWake = .Before
                whatSalatToWake = .Sunrise
            }

            switch segueIdentifier {
            case "fajrWakePickerContainer":
                let fajrAlarmPickerVCContainer = segue.destinationViewController as! FajrAlarmPickerVCContainer
                fajrAlarmPickerVCContainer.AddAlarmMasterVCReference = self
                
            case "customAlarmPickerContainer":
                let customAlarmPickerVCContainer = segue.destinationViewController as! CustomAlarmPickerVCContainer
                customAlarmPickerVCContainer.AddAlarmMasterVCReference = self

            case "addAlarmChoicesContainer":
                let addAlarmChoicesContainer = segue.destinationViewController as! AddAlarmChoicesContainer
                addAlarmChoicesContainer.AddAlarmMasterVCReference = self
                
                if let alarm = alarmClock {
                    // Edit Alarm
                    if alarm.alarmType == .CustomAlarm {
                        if let customAlarm = alarm as? CustomAlarm {
                            alarmType = customAlarm.alarmType
//                            daysToRepeat = customAlarm.daysToRepeat
                            alarmLabel = customAlarm.alarmLabel
                            sound = customAlarm.sound
                            snooze = customAlarm.snooze
                        }
                    } else if alarm.alarmType == .FajrWakeAlarm {
                        if let fajrWakeAlarm = alarm as? FajrWakeAlarm {
                            alarmType = fajrWakeAlarm.alarmType
//                            daysToRepeat = fajrWakeAlarm.daysToRepeat
                            alarmLabel = fajrWakeAlarm.alarmLabel
                            sound = fajrWakeAlarm.sound
                            snooze = fajrWakeAlarm.snooze
                        }
                    }
                } else {
                    // Add Alarm
                    alarmType = .FajrWakeAlarm
//                    daysToRepeat = nil
                    alarmLabel = "Alarm"
                    let defaultSound = NSUserDefaults.standardUserDefaults().objectForKey("DefaultSound") as? String
                    let defaultSoundTitle = NSUserDefaults.standardUserDefaults().objectForKey("DefaultSoundTitle") as? String
                    sound = AlarmSound(alarmSound: AlarmSounds(rawValue: defaultSound!)!, alarmSectionTitle: AlarmSoundsSectionTitles(rawValue: defaultSoundTitle!)!)
                    snooze = true
                    addAlarmChoicesContainer.tableView.scrollEnabled = false
                    addAlarmChoicesContainer.deleteAlarmCell.hidden = true
                }
            default:
                break
            }
        }
    }
}
