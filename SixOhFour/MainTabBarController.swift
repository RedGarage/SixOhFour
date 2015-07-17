//
//  MainTabBarController.swift
//  SixOhFour
//
//  Created by Jem on 6/24/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //  each of these are relative to the storyboard files they belong to
        let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let clockInStoryboard: UIStoryboard = UIStoryboard(name: "ClockInStoryboard", bundle: nil)
        let calendarStoryboard: UIStoryboard = UIStoryboard(name: "CalendarStoryboard", bundle: nil)
        
        let clockInVC: UINavigationController = clockInStoryboard.instantiateViewControllerWithIdentifier("ClockInNavController") as! UINavigationController
        let calendarVC: UINavigationController = calendarStoryboard.instantiateViewControllerWithIdentifier("CalendarNavController") as! UINavigationController
        let addJobsVC: HomeViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        let homeIcon = UITabBarItem(title: "", image:UIImage(named: "home.png"), tag: 1)
        let clockInIcon = UITabBarItem(title: "", image:UIImage(named: "clock.png"), tag: 2)
        let calendarIcon = UITabBarItem(title: "", image:UIImage(named: "calendar.png"), tag: 3)

        addJobsVC.tabBarItem = homeIcon
        clockInVC.tabBarItem = clockInIcon
        calendarVC.tabBarItem = calendarIcon
        
        self.viewControllers = [UINavigationController(rootViewController: addJobsVC), clockInVC, calendarVC ]
        
        // Change color of the tab bar
//         self.tabBar.barTintColor = UIColor.darkGrayColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
