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
    var alarm: AlarmClockType?
    var alarmLabel: String?
    var daysToRepeat: [Days]?
    var sound: String?
    var snooze: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        alphaSettingsForAlarmContainers(fajrAlpha: 1.0, customAlpha: 0.0)
    }
    
    func alphaSettingsForAlarmContainers(fajrAlpha fajrAlpha: CGFloat, customAlpha: CGFloat) {
        fajrAlarmContainer.alpha = fajrAlpha
        customAlarmContainer.alpha = customAlpha
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
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
            default:
                break
            }
        }
    }
}
