//
//  ClockInJobsPopoverViewController.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/8/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockInJobsPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var ClockInJobsTable: UITableView!
    
    var arrayOfJobs = [Jobs]()
    var selectedJob: Jobs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Jobs")
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        arrayOfJobs = results as! [Jobs]
    
        ClockInJobsTable.delegate = self
        ClockInJobsTable.dataSource = self
        
        self.ClockInJobsTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayOfJobs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ClockInJobsCell", forIndexPath: indexPath) as! JobsListCell
        
        cell.job = arrayOfJobs[indexPath.row]

        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedJob = arrayOfJobs[indexPath.row]

        self.dismissViewControllerAnimated(true, completion: {})
        
        self.performSegueWithIdentifier("unwindFromClockInPopoverViewControllerIdentifier", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
