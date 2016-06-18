//
//  testDelegate.swift
//  Fajr Wake
//
//  Created by Abidi on 6/18/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    class func showActivityIndicator (title: String) -> UIView {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicatorView.frame = CGRectMake(0, 0, 14, 14)
        activityIndicatorView.color = UIColor.blackColor()
        activityIndicatorView.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.italicSystemFontOfSize(14)
        
        let fittingSize = titleLabel.sizeThatFits(CGSizeMake(200.0, activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRectMake(activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8, activityIndicatorView.frame.origin.y, fittingSize.width, fittingSize.height)
        
        let titleView = UIView(frame: CGRectMake(((activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2), ((activityIndicatorView.frame.size.height) / 2), (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width), (activityIndicatorView.frame.size.height)))
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)
        
        return titleView
    }
}
