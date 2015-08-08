//
//  JobOverviewViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/16/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class JobOverviewViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overtimeLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var weekEarningLabel: UILabel!
    @IBOutlet weak var lastThirtyDaysLabel: UILabel!
    @IBOutlet weak var yearToDateLabel: UILabel!
    
    var editButton: UIBarButtonItem!
    var job: Job!

    override func viewDidLoad() {
        super.viewDidLoad()
        editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editJob")
        self.navigationItem.rightBarButtonItem = editButton
        
        self.title = job.company.name
        
        nameLabel.text = job.company.name
        positionLabel.text = job.position
        payLabel.text = "\(numberFormatter.stringFromNumber(pay)!)/hr"
        
        calculateRegHours()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "WorkedShift")
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        allWorkedShifts = results as! [WorkedShift]
    }
    
    func calculateRegHours() {
        fetchData()
        
        println(allWorkedShifts) 
    }
    
    func editJob() {
        self.performSegueWithIdentifier("editJob", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editJob" {
            let destinationVC = segue.destinationViewController as! AddJobTableViewController
            destinationVC.job = self.job
        }
    }
    
}
