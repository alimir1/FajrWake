//
//  LabelSettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/24/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class LabelSettingsViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    var addAlarmChoicesListReference: AddAlarmChoicesContainer?
    var alarmLabelText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.clearButtonMode = .whileEditing
        self.textField.delegate = self
        textField.text = alarmLabelText
        
        self.navigationItem.title = "Alarm Name"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "unwindAlarmLabelSegue", sender: self)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = newText
        if textField.text == "" {
            addAlarmChoicesListReference?.alarmLabelText = "Alarm"
        } else {
            addAlarmChoicesListReference?.alarmLabelText = newText
        }
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        addAlarmChoicesListReference?.alarmLabelText = "Alarm"
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.width/2
    }
    
}
