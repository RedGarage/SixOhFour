//
//  ClockInJobsPopoverViewController.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/8/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

<<<<<<< HEAD
class ClockInJobsPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ClockInJobsTable: UITableView!
    
    
    var arrayOfJobs = [Job]()
    var selectedJob: Job!
    var selectedJobIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
=======
//@objc protocol writeValueBackDelegate2 {
//    func writeValueBack2(vc: ClockInJobsPopoverViewController, value: String)
//}


class ClockInJobsPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

//    var writeValueDelegate2: writeValueBackDelegate2?
    

    
    @IBOutlet weak var ClockInJobsTable: UITableView!
    
    var arrayOfJobs = [Job]()
    var selectedJob: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       labelFirstPlayer.text = namenSpelers[0]
>>>>>>> 8432c40... -Fixed pay rate format
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
<<<<<<< HEAD
        var request = NSFetchRequest(entityName: "Job")
=======
        var request = NSFetchRequest(entityName: "Jobs")
>>>>>>> 8432c40... -Fixed pay rate format
        request.returnsObjectsAsFaults = false ;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        arrayOfJobs = results as! [Job]
        
<<<<<<< HEAD
=======
//        if(results.count > 0 ) {
//            for res in results{
//                var myjob = res as! Jobs
//                if (myjob.job == "sec") {
//                    arrayOfJobs.append(myjob)
//                }
////            println(res)
//            }
//        }else {
//            println("nothing")
//        }
        
        
        // Do any additional setup after loading the view.
        
>>>>>>> 8432c40... -Fixed pay rate format
        ClockInJobsTable.delegate = self
        ClockInJobsTable.dataSource = self
        
        self.ClockInJobsTable.reloadData()
<<<<<<< HEAD
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfJobs.count
=======
        
        
        
       // arrayOfJobs = []
       // arrayOfJobs.append(Jobs)
    
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        //1
//        let appDelegate =
//        UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext!
//        
//        //2
//        let fetchRequest = NSFetchRequest(entityName:"Jobs")
//        
//        //3
//        var error: NSError?
//        
//        let fetchedResults =
//        managedContext.executeFetchRequest(fetchRequest,
//            error: &error) as? [NSManagedObject]
//        
//        if let results = fetchedResults {
//            arrayOfJobs = results
//        } else {
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
//    }

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

//    class PopupViewController: UIViewController
//    {
//        override var preferredContentSize: CGSize {
//            get {
//                return CGSize(width: 300, height: 275)
//            }
//            set {
//                super.preferredContentSize = newValue
//            }
//        }
//    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayOfJobs.count
>>>>>>> 8432c40... -Fixed pay rate format
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
<<<<<<< HEAD
        let cell = tableView.dequeueReusableCellWithIdentifier("ClockInJobsCell", forIndexPath: indexPath) as! JobsListCell
        
        cell.job = arrayOfJobs[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedJobIndex = indexPath.row
=======
        let cell = tableView.dequeueReusableCellWithIdentifier("ClockInJobsCell", forIndexPath: indexPath) as! JobsListCell // Old CUSTOM Cell = ClockIn_JobsCell
        
        cell.job = arrayOfJobs[indexPath.row]
//        cell.clockInJobButton.setTitle("JOB EXIST" , forState: UIControlState.Normal)

            return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedJob = arrayOfJobs[indexPath.row]

>>>>>>> 8432c40... -Fixed pay rate format
        self.dismissViewControllerAnimated(true, completion: {})
        
        self.performSegueWithIdentifier("unwindFromClockInPopoverViewControllerIdentifier", sender: self)
        
<<<<<<< HEAD
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
=======

    }
    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(true)
//        
//        if let delegate = writeValueDelegate2 {
//            delegate.writeValueBack2(self, value: "\(selectedJobList)")
//            println("writingBackselectedJobList")
//        } else {
//            println("NADA")
//        }
//    }
    
}
>>>>>>> 8432c40... -Fixed pay rate format
