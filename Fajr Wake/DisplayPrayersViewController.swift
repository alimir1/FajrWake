//
//  DisplayPrayersViewController.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class DisplayPrayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var prayertimesTableView: UITableView!
    var prayTimesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prayertimesTableView.delegate = self
        prayertimesTableView.dataSource = self
        prayertimesTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    // helper method
    func loadSampleSchedules() {
        let fajr = "3:53 AM"
        let zohr = "3:45 AM"
        let asr = "5:34 PM"
        
        prayTimesArray += [fajr, zohr, asr]
        print("loadSampleSchedules(): \(prayTimesArray)")
    }

    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayTimesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // your cell coding
        
        print("enter tableView(...cellForRowAtIndexPath)")
        
        let cellIdentifier = "prayerTimesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! displayPrayerTimesTableViewCell
        
        // implementation
        let prayerTime = prayTimesArray[indexPath.row]
        
        cell.prayerTimeLabel.text = prayerTime
        cell.prayerNameLabel.text = SalatsAndQadhas(rawValue: indexPath.row)!.getString

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }

}