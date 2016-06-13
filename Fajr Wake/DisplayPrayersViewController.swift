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
    var prayTimesArray: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prayertimesTableView.delegate = self
        prayertimesTableView.dataSource = self
        prayertimesTableView.tableFooterView = UIView()
    }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayTimesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // your cell coding
        
        let cellIdentifier = "prayerTimesCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! displayPrayerTimesTableViewCell
        
        // implementation
        
        let prayerName = Array(prayTimesArray.keys)[indexPath.row]
        let prayerTime = Array(prayTimesArray.values)[indexPath.row]
        
        cell.prayerTimeLabel.text = prayerTime
        cell.prayerNameLabel.text = prayerName

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }

}