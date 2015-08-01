
//  ClockInViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, NSFetchedResultsControllerDelegate {
    
    var timer = NSTimer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    var hours: Int = 0

    var breakTimer = NSTimer()
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    var breakFractions: Int = 0
    var breakHours: Int = 0
    
    
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTitleLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!

    var stopWatchString: String = ""
    var breakWatchString: String = ""
    
    var timelogTimestamp: [String] = []
    var timelogDescription: [String] = []
    
    var timelogFlow: Int = 0
    var breakCount: Int = 0
    
    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobTitleDisplayButton: UIButton!
    @IBOutlet weak var jobTitleDisplayLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var breakButton: UIButton! //lapreset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.lapsTableView.rowHeight = 30.0
        jobTitleDisplayLabel.text = "Select Job"
        workTitleLabel.text = " "
        workTimeLabel.text = "00:00:00"
        breakButton.enabled = false
        breakTitleLabel.text = " "
        breakTimeLabel.text = " "
        }
    
//MARK: IBActions:
//2 buttons control clockin,clockout,start break, end break, reset

    @IBAction func startStop(sender: AnyObject) {
        
        //CLOCK IN
        if timelogFlow == 0 {
            workTitleLabel.text = "Time you've worked"
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)
            startStopButton.setTitle("Clock Out", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            breakButton.enabled = true
            
            timelogDescription.append("Clocked In")
            appendToTimeTableView()
            saveToCoreDate()
            
            timelogFlow = 1
            println(timelogFlow)
        } else {
            //CLOCK OUT
            
            workTitleLabel.text = "Total time you worked for the shift"
            timelogDescription.append("Clocked Out")
            appendToTimeTableView()
            saveToCoreDate()
            
            timer.invalidate()
            
            startStopButton.setTitle("Done with Shift", forState: UIControlState.Normal)
            startStopButton.enabled = false
            breakButton.setTitle("Reset", forState: UIControlState.Normal)
            
            timelogFlow = 2
            println(timelogFlow)
            
        }
        
    }
    
    @IBAction func lapReset(sender: AnyObject) {
        
        //STARTED BREAK
        if timelogFlow == 1 {
            
            breakTimeLabel.text = "00:00:00"
            breakTitleLabel.text = "Time you've been on break"
            
            breakMinutes = 0
            breakSeconds = 0
            breakFractions = 0
            breakHours = 0
            
            breakCount++
            
            breakTitleLabel.textColor = UIColor.blueColor()
            breakTimeLabel.textColor = UIColor.blueColor()
            
            timer.invalidate()
            
            breakTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimer"), userInfo: nil, repeats: true)
            
            startStopButton.enabled = false
            breakButton.setTitle("End Break", forState: UIControlState.Normal)
            
            if breakCount == 1 {
                timelogDescription.append("Started Break")
            } else {
                timelogDescription.append("Started Break #\(breakCount)")
            }
            
            appendToTimeTableView()
            saveToCoreDate()
            
            timelogFlow = 3
            println(timelogFlow)
            
            
            //ENDED BREAK
        } else if timelogFlow == 3 {
            workTitleLabel.text = "Total time you've worked"
            breakTimeLabel.text = breakWatchString
            
            breakTitleLabel.textColor = UIColor.grayColor()
            breakTimeLabel.textColor = UIColor.grayColor()
            breakTitleLabel.text = "Duration of your last break"
            
            
            breakTimer.invalidate()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runWorkTimer"), userInfo: nil, repeats: true)
            
            
            startStopButton.enabled = true
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            if breakCount == 1 {
                timelogDescription.append("Ended Break")
            } else {
                timelogDescription.append("Ended Break #\(breakCount)")
            }
            
            appendToTimeTableView()
            saveToCoreDate()
            
            
            timelogFlow = 1
            println(timelogFlow)
            
            //added if statement to handle break time of 0sec
            if breakSeconds < 1 {
                breakTimeLabel.text = "00:00:00"
                println("this is happening")
            } else {
                breakTimeLabel.text = breakWatchString
                println("this is happening2")
            }
            
            //RESET
        } else {
            
            startStopButton.setTitle("Clock In", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            breakButton.enabled = false
            
            //clears all the laps when clicked reset
            timelogTimestamp.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            
            fractions = 0
            minutes = 0
            seconds = 0
            hours = 0
            
            breakCount = 0
            
            workTitleLabel.text = " "
            workTimeLabel.text = "00:00:00"
            breakTimeLabel.text = " "
            breakTitleLabel.text = " "
            
            startStopButton.enabled = true
            
            timelogTimestamp = []
            timelogDescription = []
            
            timelogFlow = 0
        }
    }
    
//MARK: functions
    
    func allTimeLogsFetchRequest() -> NSFetchRequest {
        
        var fetchRequest = NSFetchRequest(entityName: "TimeLogs")
        
        fetchRequest.predicate = nil
        
        return fetchRequest
    }
    
    func saveToCoreDate(){
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newTimeLogs = NSEntityDescription.insertNewObjectForEntityForName("TimeLogs", inManagedObjectContext: context) as! NSManagedObject
        
        newTimeLogs.setValue("" + timelogDescription.last!, forKey: "timelogTitle")
        newTimeLogs.setValue("" + timelogTimestamp.last!, forKey: "timelogTimestamp")
        
        context.save(nil)
        
        println(newTimeLogs)
    }
    
    func appendToTimeTableView() {
        var timeStampAll = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)
        timelogTimestamp.append(timeStampAll)
        lapsTableView.reloadData()
    }

    
    func runBreakTimer() {

        breakSeconds += 1
        
        if breakSeconds == 60 {
            breakMinutes += 1
            breakSeconds = 0
        }
        if breakMinutes == 60 {
            breakHours += 1
            breakMinutes = 0
        }
    
        breakWatchString  = getWatchString(breakFractions, seconds: breakSeconds, minutes: breakMinutes, hours: breakHours)
        breakTimeLabel.text = breakWatchString
    }
    
    //redundant code - need to combine both timers
    func runWorkTimer() {
        
        seconds += 1
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        stopWatchString  = getWatchString(fractions, seconds: seconds, minutes: minutes, hours: hours)
        workTimeLabel.text = stopWatchString
    }
    
    func getWatchString(fractions: Int, seconds: Int, minutes: Int, hours: Int) -> String {
        let fractionsString = String.secondsString(fractions)
        let secondsString = String.secondsString(seconds)
        let minutesString = String.minutesString(minutes)
        let hoursString = String.hoursString(hours)
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    //Getting data from Popover - When selecting Job
    @IBAction func unwindFromClockInPopoverViewControllerAction (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! ClockInJobsPopoverViewController
        
        if((sourceVC.selectedJob) != nil ) {
            
            jobTitleDisplayLabel.text = sourceVC.selectedJob.company.name
            
            var jc = JobColor()
            
            jobColorDisplay.color = jc.getJobColor(sourceVC.selectedJob.color.name)
        }
    }

    
//Table View funct
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        
        cell.textLabel!.font = UIFont.systemFontOfSize(12.0)
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12.0)
        
        cell.textLabel!.text = timelogDescription[timelogTimestamp.count - indexPath.row - 1] //descending order
        cell.detailTextLabel?.text = timelogTimestamp[timelogTimestamp.count - indexPath.row - 1] //descending order

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelogTimestamp.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetails", sender: tableView)
    }


//Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //Popover Effect - Drop down menu --->>>>>
        if let popupView = segue.destinationViewController as? UIViewController
        {
            if let popup = popupView.popoverPresentationController
            {
                popup.delegate = self
            }
        } //Popover Effect Ended <<<<<-------
        
        //Timelog Details
        if segue.identifier == "showDetails" {
            let destinationVC = segue.destinationViewController as! UIViewController
            destinationVC.navigationItem.title = ""
            destinationVC.hidesBottomBarWhenPushed = true;
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target: nil, action: nil)
        }

    }
    
    //Popover Effect - Drop down menu --->>>>>
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }//Popover Effect Ended <<<<<-------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

