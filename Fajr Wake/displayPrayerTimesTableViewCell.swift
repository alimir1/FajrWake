//
//  displayPrayerTimesTableViewCell.swift
//  Fajr Wake
//
//  Created by Abidi on 6/13/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class displayPrayerTimesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prayerTimeLabel: UILabel!
    @IBOutlet weak var prayerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}