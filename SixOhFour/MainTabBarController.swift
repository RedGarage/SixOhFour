//
//  MainTabBarController.swift
//  SixOhFour
//
//  Created by Jem on 6/24/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
        let clockInStoryboard: UIStoryboard = UIStoryboard(name: "ClockInStoryboard", bundle: nil)
        let calendarStoryboard: UIStoryboard = UIStoryboard(name: "CalendarStoryboard", bundle: nil)
        
        let clockInVC: UINavigationController = clockInStoryboard.instantiateViewControllerWithIdentifier("ClockInNavController") as! UINavigationController
        let calendarVC: UINavigationController = calendarStoryboard.instantiateViewControllerWithIdentifier("CalendarNavController") as! UINavigationController
        let addJobsVC: UINavigationController = addJobStoryboard.instantiateViewControllerWithIdentifier("JobsNavController") as! UINavigationController
        
        let jobsIcon = UITabBarItem(title: "", image:UIImage(named: "list.png"), tag: 1)
        let clockInIcon = UITabBarItem(title: "", image:UIImage(named: "clock.png"), tag: 2)
        let calendarIcon = UITabBarItem(title: "", image:UIImage(named: "calendar.png"), tag: 3)

        addJobsVC.tabBarItem = jobsIcon
        clockInVC.tabBarItem = clockInIcon
        calendarVC.tabBarItem = calendarIcon
        
        self.viewControllers = [addJobsVC, clockInVC, calendarVC ]
        
        // Set the root view to Clock In once the user has added a job
        let results = dataManager.fetch("Job") as! [Job]
        
        if results.count > 0 {
            self.selectedIndex = 1
        } else {
            self.selectedIndex = 0
        }
        
        // Pre-populate the Color table when the app is opened for the first time
        var colors = dataManager.fetch("Color") as! [Color]
        
        let defaultColors = ["Red", "Magenta", "Purple", "Blue", "Cyan", "Green", "Yellow", "Orange", "Brown", "Gray"]

        if colors.isEmpty {
            for colorName in defaultColors {
                let color = dataManager.addItem("Color") as! Color
                color.name = colorName
                color.isSelected = false
                
                dataManager.save()
            }
        }
    
        
        //Check for any timelogs that arent assigned to workedshift
        //TODO: Remove this checkpoint when fully tested and confirmed that there are no timelog leaks
        let predicateLeak = NSPredicate(format: "workedShift == nil")
        var timelogs = [Timelog]()
        timelogs = dataManager.fetch("Timelog", predicate: predicateLeak) as! [Timelog]

        if timelogs.count > 0 {
            println("Second Checkpoint = see if there are any openTLs:")
            println("openTLs = \(timelogs.count)")
            for i in timelogs {
                dataManager.delete(i)
            }
        }
        
        // Recreate the first 50 Notifications
        let app = UIApplication.sharedApplication()
        app.cancelAllLocalNotifications()
        
        let limit = 25 // limit to 50 notifications (pair of 25)
        var index = 0
        
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: true)
        let schedule = dataManager.fetch("ScheduledShift", sortDescriptors: [sortDescriptor]) as! [ScheduledShift]
        
        for sched in schedule {
            if index == limit {
                break
            } else {
                let formatter = NSDateFormatter()
                formatter.dateStyle = .NoStyle
                formatter.timeStyle = .ShortStyle
                formatter.timeZone = NSTimeZone()
                
                let start = formatter.stringFromDate(sched.startTime)
                let end = formatter.stringFromDate(sched.endTime)
                
                var startNotification = UILocalNotification()
                startNotification.alertBody = "You are scheduled to clock in at \(start)"
                startNotification.alertAction = "clock in"
                startNotification.fireDate = sched.startTime
                startNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(startNotification)
                
                var endNotification = UILocalNotification()
                endNotification.alertBody = "You are scheduled to clock out at \(end)"
                endNotification.alertAction = "clock out"
                endNotification.fireDate = sched.endTime
                endNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(endNotification)
            }
            index++
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
