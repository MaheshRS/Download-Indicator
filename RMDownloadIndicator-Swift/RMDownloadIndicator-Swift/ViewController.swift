//
//  ViewController.swift
//  RMDownloadIndicator-Swift
//
//  Created by Mahesh Shanbhag on 10/08/15.
//  Copyright (c) 2015 Mahesh Shanbhag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animationSwitch: UISwitch!
    var closedIndicator: RMDownloadIndicator!
    var filledIndicator: RMDownloadIndicator!
    var mixedIndicator: RMDownloadIndicator!

    var downloadedBytes: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingChanged(self.animationSwitch)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addDownloadIndicators() {
        
        if self.closedIndicator != nil {
            self.closedIndicator.removeFromSuperview()
            self.closedIndicator = nil
        }
        
        if self.filledIndicator != nil {
            self.filledIndicator.removeFromSuperview()
            self.filledIndicator = nil
        }
        
        if self.mixedIndicator != nil {
            self.mixedIndicator.removeFromSuperview()
            self.mixedIndicator = nil
        }
        
        let closedIndicator: RMDownloadIndicator = RMDownloadIndicator(rectframe: CGRectMake((CGRectGetWidth(self.view.bounds) - 80) / 2, CGRectGetMaxY(self.animationSwitch.frame) + 60.0, 80, 80), type: RMIndicatorType.kRMClosedIndicator)
        closedIndicator.backgroundColor = UIColor.whiteColor()
        closedIndicator.fillColor = UIColor(red: 16/255, green: 119/255, blue: 234/255, alpha: 1.0)
        closedIndicator.strokeColor = UIColor(red:16/255, green: 119/255, blue: 234/255, alpha: 1.0)
        closedIndicator.radiusPercent = 0.45
        self.view.addSubview(closedIndicator)
        closedIndicator.loadIndicator()
        self.closedIndicator = closedIndicator
        
        let filledIndicator: RMDownloadIndicator = RMDownloadIndicator(rectframe: CGRectMake((CGRectGetWidth(self.view.bounds) - 80) / 2, CGRectGetMaxY(self.closedIndicator.frame) + 40.0, 80, 80), type: RMIndicatorType.kRMFilledIndicator)
        filledIndicator.backgroundColor = UIColor.whiteColor()
        filledIndicator.fillColor = UIColor(red: 16.0/255, green: 119.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        filledIndicator.strokeColor = UIColor(red: 16.0/255.0, green: 119.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        filledIndicator.radiusPercent = 0.45
        self.view.addSubview(filledIndicator)
        filledIndicator.loadIndicator()
        self.filledIndicator = filledIndicator
        
        let mixedIndicator: RMDownloadIndicator = RMDownloadIndicator(rectframe: CGRectMake((CGRectGetWidth(self.view.bounds) - 80) / 2, CGRectGetMaxY(self.filledIndicator.frame) + 40.0, 80, 80), type: RMIndicatorType.kRMMixedIndictor)
        mixedIndicator.backgroundColor = UIColor.whiteColor()
        mixedIndicator.fillColor = UIColor(red: 16.0/255.0, green: 119.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        mixedIndicator.strokeColor = UIColor(red: 16.0/255.0, green: 119.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        mixedIndicator.closedIndicatorBackgroundStrokeColor = UIColor(red:16.0/255.0, green: 119.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        mixedIndicator.radiusPercent = 0.45
        self.view.addSubview(mixedIndicator)
        mixedIndicator.loadIndicator()
        self.mixedIndicator = mixedIndicator
    }
    
    func startAnimation() {
        self.addDownloadIndicators()
        if !animationSwitch.on {
            self.updateViewOneTime()
            return
        }
        
        self.downloadedBytes = 0
        self.animationSwitch.userInteractionEnabled = false
        
        let delayInSeconds: Int64 = 1
        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Int64(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {() in        self.updateView(10.0)
            
        })
        let delayInSeconds1: Int64 = delayInSeconds + 1
        let popTime1: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds1 * Int64(NSEC_PER_SEC)))
        dispatch_after(popTime1, dispatch_get_main_queue(), {() in        self.updateView(30.0)
            
        })
        let delayInSeconds2: Int64 = delayInSeconds1 + 1
        let popTime2: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds2 * Int64(NSEC_PER_SEC)))
        dispatch_after(popTime2, dispatch_get_main_queue(), {() in        self.updateView(10.0)
            
        })
        let delayInSeconds3: Int64 = delayInSeconds2 + 1
        let popTime3: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds3 * Int64(NSEC_PER_SEC)))
        dispatch_after(popTime3, dispatch_get_main_queue(), {() in        self.updateView(50.0)
            self.animationSwitch.userInteractionEnabled = true
            
        })
    }
    
    func updateView(val: CGFloat) {
        self.downloadedBytes += val
        closedIndicator.updateWithTotalBytes(100, downloadedBytes: self.downloadedBytes)
        filledIndicator.updateWithTotalBytes(100, downloadedBytes: self.downloadedBytes)
        mixedIndicator.updateWithTotalBytes(100, downloadedBytes: self.downloadedBytes)
    }
    
    func updateViewOneTime() {
        closedIndicator.setIndicatorAnimationDuration(1.0)
        filledIndicator.setIndicatorAnimationDuration(1.0)
        mixedIndicator.setIndicatorAnimationDuration(1.0)
        closedIndicator.updateWithTotalBytes(100, downloadedBytes: 100)
        filledIndicator.updateWithTotalBytes(100, downloadedBytes: self.downloadedBytes)
        mixedIndicator.updateWithTotalBytes(100, downloadedBytes: self.downloadedBytes)
    }
    
    @IBAction func settingChanged(sender: UISwitch) {
        if self.animationSwitch.on {
            //self.settings.setText("Multi Time Animation")
            self.startAnimation()
        }
        else {
            //self.settings.setText("One Time Animation")
            self.startAnimation()
        }
    }


}

