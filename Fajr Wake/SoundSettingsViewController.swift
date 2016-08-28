//
//  SoundSettingsViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/24/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit
import AVFoundation

class SoundSettingsViewController: UITableViewController {
    
    var addAlarmChoicesListReference: AddAlarmChoicesContainer?
    var alarmSoundPlayer: AVAudioPlayer!
    
    let alarmSoundsSectionTitles: [AlarmSoundsSectionTitles] = [.Adhan, .DuasMunajat, .Quran, .Nature, .None]
    
    let alarmSounds: [[AlarmSounds]] =
        [[.MozenZadeh, .AbatharAlHalawaji, .AbdulBasit, .KazemZadeh, .Rozayghi, .TasviehChi],
         [.DuaKumayl, .DuaJaushanKabeer, .DuaMujeer, .MunajatImamAli, .MunajatMuhibeen],
         [.Anbia, .AleImran, .Hamd, .Fajr, .Isra, .Qaf],
         [.BirdsChirping, .BirdsChirping2, .Crickets, .Ocean],
         [.None]]
    
    var selectedSound: AlarmSound? {
        didSet {
            if let sound = selectedSound {
                selectedSoundSectionIndex = alarmSoundsSectionTitles.indexOf(sound.alarmSectionTitle)!
                selectedSoundRowIndex = alarmSounds[selectedSoundSectionIndex!].indexOf(sound.alarmSound)!
                addAlarmChoicesListReference?.alarmSound = sound
            }
        }
    }
    
    var selectedSoundRowIndex: Int?
    var selectedSoundSectionIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Alarm Sounds"
    }
    
    func playSound(url: NSURL) {
        do {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) // play audio even in silent mode
            } catch {
                print("could not play in silent mode")
            }
            alarmSoundPlayer = try AVAudioPlayer(contentsOfURL: url)
            alarmSoundPlayer.volume = 1.0
            alarmSoundPlayer.play()
            //someSound.numberOfLoops = -1 // "infinite" loop
        } catch {
            print("could not play sound")
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return alarmSoundsSectionTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarmSounds[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alarmSoundsSectionTitles[section].rawValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("soundID", forIndexPath: indexPath)
        // Configure the cell...
        cell.textLabel?.text = self.alarmSounds[indexPath.section][indexPath.row].rawValue
        
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
        
        let sound = self.alarmSounds[indexPath.section][indexPath.row]
        let title = self.alarmSoundsSectionTitles[indexPath.section]
        selectedSound = AlarmSound(alarmSound: sound, alarmSectionTitle: title)
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setObject(sound.rawValue, forKey: "DefaultSound")
        settings.setObject(title.rawValue, forKey: "DefaultSoundTitle")
        
        
        // Play Sound
        if sound.URL != nil {
            playSound(sound.URL!)
        } else {
            if alarmSoundPlayer != nil {
                alarmSoundPlayer.stop()
                alarmSoundPlayer = nil
            }
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
}





