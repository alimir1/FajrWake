//
//  SoundSettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/24/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class SoundSettingsViewController: UITableViewController {
    let sectionTitles = ["Athan", "Duas/Munajat", "Qu'ran", "System Sounds", ""]
    let items = [["Moazenzadeh", "Mekka", "Halawaji"], ["Munajat Imam Ali", "Dua Faraj", "Dua Sabah"], ["Surah Anbiya", "Surah Ikhlas"], ["Radar", "Apex", "Classic Alarm"], ["None"]]
    var selectedSoundLabel: (title: String, sound: String)? {
        didSet {
            if let sound = selectedSoundLabel {
                print("sound: \(sound)") // testing...
                selectedSoundSectionIndex = sectionTitles.indexOf(sound.title)
                selectedSoundRowIndex = items[selectedSoundSectionIndex!].indexOf(sound.sound)!
            }
        }
    }
    var selectedSoundRowIndex: Int?
    var selectedSoundSectionIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("soundID", forIndexPath: indexPath)
        // Configure the cell...
        cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        
        if indexPath.section == selectedSoundSectionIndex && indexPath.row == selectedSoundRowIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let selectionIndex = selectedSoundSectionIndex, let rowIndex = selectedSoundRowIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: selectionIndex))
            cell?.accessoryType = .None
        }
        
        let sound = self.items[indexPath.section][indexPath.row]
        let title = self.sectionTitles[indexPath.section]
        selectedSoundLabel = (title: title, sound: sound)
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
