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
    @IBOutlet weak var normalAlarmContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var choicesTableViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.fajrAlarmContainer.alpha = 1
            self.normalAlarmContainer.alpha = 0
        } else {
            self.fajrAlarmContainer.alpha = 0
            self.normalAlarmContainer.alpha = 1
        }
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
