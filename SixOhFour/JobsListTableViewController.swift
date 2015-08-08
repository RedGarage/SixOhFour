//
//  JobsListTableViewController.swift
//  SixOhFour
//
//  Created by jemsomniac on 7/10/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
<<<<<<< HEAD

class JobsListTableViewController: UITableViewController {

    var jobName: String!
    var jobColor: UIColor!
    var selectedJob: Job!
    var previousSelection: String!

    var jobsList = [Job]()
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsList = dataManager.fetch("Job") as! [Job]
=======
import CoreData

class JobsListTableViewController: UITableViewController {

    var jobsList = [Jobs]()
    var jobName: String!
    var jobColor: UIColor!
    var selectedJob: Jobs!
    var previousSelection: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Jobs")
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        jobsList = results as! [Jobs]
>>>>>>> 8432c40... -Fixed pay rate format
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

<<<<<<< HEAD
    
=======
>>>>>>> 8432c40... -Fixed pay rate format
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobsListCell", forIndexPath: indexPath) as! JobsListCell
        
<<<<<<< HEAD
        cell.jobNameLabel.text = jobsList[indexPath.row].company.name
        
        cell.jobColorView.color = jobsList[indexPath.row].color.getColor
=======
        cell.jobNameLabel.text = jobsList[indexPath.row].jobName
        
        var jc = JobColor()
        cell.jobColorView.color = jc.getJobColor(jobsList[indexPath.row].jobColor)
>>>>>>> 8432c40... -Fixed pay rate format
        
        if cell.jobNameLabel.text == previousSelection {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedJob = jobsList[indexPath.row]
<<<<<<< HEAD
                
        self.performSegueWithIdentifier("unwindFromJobsListTableViewController", sender: self)
    }
=======
        
        self.performSegueWithIdentifier("unwindFromJobsListTableViewController", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        
//    }
    

>>>>>>> 8432c40... -Fixed pay rate format
}
