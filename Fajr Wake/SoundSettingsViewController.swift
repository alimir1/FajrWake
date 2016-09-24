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
                selectedSoundSectionIndex = alarmSoundsSectionTitles.index(of: sound.alarmSectionTitle)!
                selectedSoundRowIndex = alarmSounds[selectedSoundSectionIndex!].index(of: sound.alarmSound)!
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
    
    func playSound(_ url: URL) {
        do {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) // play audio even in silent mode
            } catch {
                print("could not play in silent mode")
            }
            alarmSoundPlayer = try AVAudioPlayer(contentsOf: url)
            alarmSoundPlayer.volume = 1.0
            alarmSoundPlayer.play()
            //someSound.numberOfLoops = -1 // "infinite" loop
        } catch {
            print("could not play sound")
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return alarmSoundsSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarmSounds[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alarmSoundsSectionTitles[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundID", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = self.alarmSounds[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].rawValue
        
        if (indexPath as NSIndexPath).section == selectedSoundSectionIndex && (indexPath as NSIndexPath).row == selectedSoundRowIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let selectionIndex = selectedSoundSectionIndex, let rowIndex = selectedSoundRowIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: rowIndex, section: selectionIndex))
            cell?.accessoryType = .none
        }
        
        let sound = self.alarmSounds[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let title = self.alarmSoundsSectionTitles[(indexPath as NSIndexPath).section]
        selectedSound = AlarmSound(alarmSound: sound, alarmSectionTitle: title)
        let settings = UserDefaults.standard
        settings.set(sound.rawValue, forKey: "DefaultSound")
        settings.set(title.rawValue, forKey: "DefaultSoundTitle")
        
        
        // Play Sound
        if sound.URL != nil {
            playSound(sound.URL! as URL)
        } else {
            if alarmSoundPlayer != nil {
                alarmSoundPlayer.stop()
                alarmSoundPlayer = nil
            }
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
}





