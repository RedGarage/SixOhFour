//
//  HomeViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/24/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var job: Job!
    var jobsList = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        tableView.reloadData()
    }
    
    func fetchData() {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Job")
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        jobsList = results as! [Job]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return jobsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobsListCell", forIndexPath: indexPath) as! JobsListCell
        
        cell.jobNameLabel.text = jobsList[indexPath.row].company.name
        
        var jc = JobColor()
        cell.jobColorView.color = jc.getJobColor(jobsList[indexPath.row].color.name)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.job = jobsList[indexPath.row]

        self.performSegueWithIdentifier("jobOverview", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "jobOverview" {
            let destinationVC = segue.destinationViewController as! JobOverviewViewController
            destinationVC.job = self.job
        }
    }
    
}