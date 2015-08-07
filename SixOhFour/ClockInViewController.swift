
//  ClockInViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 6/26/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class ClockInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var saveOption: UILabel!
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTitleLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var editBreakInstruction: UILabel!
    
    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobTitleDisplayButton: UIButton!
    @IBOutlet weak var jobTitleDisplayLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var editBreakButton: UIButton!
    
    var timer = NSTimer()
    

    var breakTimer = NSTimer()
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    var breakHours: Int = 0

    var breakMinutesSet: Int = 30
    var breakSecondsSet: Int = 0
    var breakHoursSet: Int = 0

    var breakMinutesChange: Int = 0
    var breakHoursChange: Int = 0

    var breakTimerOver = NSTimer()
    

    var workedTimeString: String = ""
    var breakWatchString: String = ""
    
    var flow: String = "Idle"
    var breakCount: Int = 0
    
    var jobListEmpty = true
    var selectedJobIndex: Int = 0
    var noMinDate: Bool = false
    var noMaxDate: Bool = false

    var nItemClockIn : Timelog!
    var nItemClockInPrevious : Timelog!
    var nItemClockInNext : Timelog!

    var newTimelog : Timelog!
    var timelogsList = [Timelog]()
    var timelogTimestamp: [NSDate] = []
    var timelogDescription: [String] = []
    
    var totalBreaktime : Double = 0.0
    var selectedRowIndex: Int = -1
    var elapsedTime : Int = 0
    var duration : Double = 0.0

    var currentWorkedShift : WorkedShift!
    
    var jc = JobColor()

    
    var frc : NSFetchedResultsController = NSFetchedResultsController()
    let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lapsTableView.rowHeight = 30.0
        workTitleLabel.text = " "
        workTimeLabel.text = "00:00:00"
        breakButton.enabled = false
        breakTitleLabel.hidden = true
        breakTimeLabel.hidden = true
        editBreakInstruction.hidden = true
        editBreakButton.enabled = false
        saveOption.hidden = true
        saveOption.textColor = UIColor.blueColor()
        
        
        frc = getFetchedResultsController()
        frc.delegate = self
        frc.performFetch(nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        if jobListEmpty {
            startStopButton.enabled = false
            workTimeLabel.textColor = UIColor.grayColor()
        }
        
        
        //SELECTS THE FIRST JOB WHEN APP IS LOADED
        if selectedJobIndex == 0 {
            
            // Fetch jobs list to keep refreshing changes
            var request = NSFetchRequest(entityName: "Job")
            request.returnsObjectsAsFaults = false ;
            
            var results:NSArray = context.executeFetchRequest(request, error: nil)!
            
            if results.count > 0 {
                //Fetches the first jobs
                var firstJob = results[0] as! Job
                jobTitleDisplayLabel.text = firstJob.company.name

                jobTitleDisplayLabel.textColor = UIColor.blackColor()
                jobColorDisplay.hidden = false
                jobColorDisplay.color = jc.getJobColor(firstJob.color.name)
                jobColorDisplay.setNeedsDisplay()
                
                jobListEmpty = false
                
                if flow == "Idle" {
                    startStopButton.enabled = true
                }
                
            } else {
                jobTitleDisplayLabel.text = "Add a Job"
                jobTitleDisplayLabel.textColor = UIColor.blueColor()
                jobColorDisplay.hidden = true
            }
            
        } else {

            var request = NSFetchRequest(entityName: "Job")
            request.returnsObjectsAsFaults = false ;
            
            var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
            var arrayOfJobs = [Job]()
            arrayOfJobs = results as! [Job]
            jobTitleDisplayLabel.text = arrayOfJobs[selectedJobIndex].company.name
            jobColorDisplay.color = jc.getJobColor(arrayOfJobs[selectedJobIndex].color.name)
            jobColorDisplay.setNeedsDisplay()

        }
        
        if flow == "clockedOut" {
            breakButton.setTitle("Save to \(jobTitleDisplayLabel.text!)", forState: UIControlState.Normal)

            sumUpBreaks(flow)
            sumUpWorkDuration()
            saveDurationToWorkedShift()
        } else if flow == "onBreak" {
            //while your on break you can see the duration adjustments
            sumUpBreaks(flow)
            sumUpWorkDuration()
        }


        lapsTableView.reloadData()
    
    }
    
//MARK: IBActions:
//2 buttons control clockin,clockout,start break, end break, reset

    @IBAction func startStop(sender: AnyObject) {
        
        //CLOCK IN -- Begin  the shift
        if flow == "Idle" {
            flow = "onTheClock"

            workTitleLabel.text = "Time you've worked"
            
            startStopButton.setTitle("Clock Out", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            breakButton.enabled = true
            
            timelogDescription.append("Clocked In")
            appendToTimeTableView()
            saveToCoreData()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runAndUpdateWorkTimer"), userInfo: nil, repeats: true)
            
            
        } else if flow == "onTheClock" {
            //CLOCK OUT
            flow = "clockedOut"

            workTitleLabel.text = "Total time you've worked"
            timelogDescription.append("Clocked Out")
            appendToTimeTableView()
            saveToCoreData()
            saveTimelogsToWorkedShift()
            timer.invalidate()
            
            startStopButton.setTitle("", forState: UIControlState.Normal)
            startStopButton.enabled = false
            breakButton.setTitle("Save to \(jobTitleDisplayLabel.text!)", forState: UIControlState.Normal)
            
            saveOption.hidden = false

            sumUpBreaks(flow)
            sumUpWorkDuration()
            saveDurationToWorkedShift()
            
        }
        
    }
    
    

    
    @IBAction func lapReset(sender: AnyObject) {
    
        //STARTED BREAK
        if flow == "onTheClock" {
            flow = "onBreak"
            
            breakTimeLabel.hidden = false
            breakTitleLabel.hidden = false
            editBreakInstruction.hidden = false
            editBreakButton.enabled = true

            breakReset ()


            
            
            displayBreaktime ()

            
            breakTitleLabel.textColor = UIColor.blueColor()
            breakTimeLabel.textColor = UIColor.blueColor()
            editBreakInstruction.textColor = UIColor.blueColor()
            
            
            breakTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimer"), userInfo: nil, repeats: true)

            timer.invalidate()

            startStopButton.enabled = false
            breakButton.setTitle("End Break", forState: UIControlState.Normal)
            
            if breakCount < 2 {
            timelogDescription.append("Started Break")
            } else {
            timelogDescription.append("Started Break #\(breakCount)")
            }
            
            appendToTimeTableView()
            saveToCoreData()

            breakCount++
            
        //ENDED BREAK
        } else if flow == "onBreak" {
            flow = "onTheClock"
            
            breakTimerOver.invalidate()

            breakTimeLabel.hidden = true
            breakTitleLabel.hidden = true
            editBreakInstruction.hidden = true
            editBreakButton.enabled = false

            breakReset()
            
            breakTimer.invalidate()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runAndUpdateWorkTimer"), userInfo: nil, repeats: true)
            
            startStopButton.enabled = true
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            
            if breakCount == 1 {
                timelogDescription.append("Ended Break")
            } else {
                timelogDescription.append("Ended Break #\(breakCount)")
            }
    
            appendToTimeTableView()
            saveToCoreData()
            sumUpBreaks(flow)
            
            breakTimeLabel.text = "0\(breakHours):\(breakMinutes):0\(breakSeconds)"
            
        //RESET and SAVE (WorkedShift to current JOB that is picked)
        } else if flow == "clockedOut" {

            startStopButton.setTitle("Clock In", forState: UIControlState.Normal)
            breakButton.setTitle("Start Break", forState: UIControlState.Normal)
            breakButton.enabled = false
            
            saveWorkedShiftToJob()
            
            //clears all the laps when clicked reset
            timelogTimestamp.removeAll(keepCapacity: false)
            timelogDescription.removeAll(keepCapacity: false)
            timelogsList = []
            
            lapsTableView.reloadData()
            
            breakCount = 0

            workTitleLabel.text = " "
            workTimeLabel.text = "00:00:00"
            breakTimeLabel.text = " "
            breakTitleLabel.text = " "

            duration = 0
            totalBreaktime = 0
            
            startStopButton.enabled = true
            
            saveOption.hidden = true
            
            //Wait to reset to idle - this is bc viewdidappear for duration calc.
            flow = "Idle"
        }
        
        
    }
    
    @IBAction func selectJobButton(sender: AnyObject) {
        if jobListEmpty {
            let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
            let addJobsVC: AddJobTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("AddJobTableViewController") as! AddJobTableViewController
                    
            self.navigationController?.pushViewController(addJobsVC, animated: true)
            
        } else {
            self.performSegueWithIdentifier("displayJobList", sender: self)
        }
    }
    
//MARK: Functions
    
    
    func TimeLogsFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Timelog")
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: TimeLogsFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func saveToCoreData(){
        
        let ent = NSEntityDescription.entityForName("Timelog", inManagedObjectContext: context)
        newTimelog = Timelog(entity: ent!, insertIntoManagedObjectContext: context)
        
        newTimelog.setValue("" + timelogDescription.last!, forKey: "type")
        newTimelog.time = NSDate()
        newTimelog.setValue("", forKey: "comment")
        
        timelogsList.append(newTimelog)
        
        context.save(nil)

        println(newTimelog)
        
        println(timelogDescription)
    }
    
    func saveTimelogsToWorkedShift() {
        
        let workedShiftEnt = NSEntityDescription.entityForName("WorkedShift", inManagedObjectContext: context)
        currentWorkedShift = WorkedShift(entity: workedShiftEnt!, insertIntoManagedObjectContext: context)
        
        var set = NSSet(array: timelogsList)
        
        currentWorkedShift.setValue(set, forKey: "timelogs")
        
        println(currentWorkedShift)
        
    }

    func saveDurationToWorkedShift() {
        
        currentWorkedShift.setValue(duration, forKey: "duration")
        println(currentWorkedShift)

    }
    
    func saveWorkedShiftToJob() {
        
        var request = NSFetchRequest(entityName: "Job")
        request.returnsObjectsAsFaults = false ;
        
        var selectedJob = jobTitleDisplayLabel.text
        var predicateJob = NSPredicate(format: "company.name == %@" , selectedJob!)
        
        request.predicate = predicateJob
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        var arrayOfJobs = [Job]()
        arrayOfJobs = results as! [Job]

        currentWorkedShift.job = arrayOfJobs[0]

    }

    
    func appendToTimeTableView() {

        timelogTimestamp.append(NSDate())
        lapsTableView.reloadData()
        
        var indexPathScroll = NSIndexPath(forRow: timelogsList.count, inSection: 0)
        self.lapsTableView.scrollToRowAtIndexPath(indexPathScroll, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
    }

//DURATION FUNCTIONS!!!!!!!
    
    func runAndUpdateWorkTimer() {
        runWorkTimer()
        updateWorkTimerLabel()
    }
    
    func runWorkTimer() {
        //currently calculated since clock in and subtracting the total breaktime duration
        let elapsedTimeInterval = NSDate().timeIntervalSinceDate(timelogTimestamp[0])
        
        elapsedTime = Int(elapsedTimeInterval) - Int(totalBreaktime)
    }
    
    func updateWorkTimerLabel() {
        
        var elapsedSecond :Int = 0
        var elapsedMinute :Int = 0
        var elapsedHour :Int = 0
        
        if elapsedTime >= 3600 {
            elapsedSecond = (elapsedTime % 60 ) % 60
            elapsedMinute = (elapsedTime % 3600 ) / 60
            elapsedHour = elapsedTime / 60 / 60
        } else if elapsedTime >= 60 {
            elapsedSecond = elapsedTime % 60
            elapsedMinute = elapsedTime / 60
            elapsedHour = 0
        } else {
            elapsedSecond = elapsedTime
            elapsedMinute = 0
            elapsedHour = 0
        }
        
        let secondsString = elapsedSecond > 9 ? "\(elapsedSecond)" : "0\(elapsedSecond)"
        let minutesString = elapsedMinute > 9 ? "\(elapsedMinute)" : "0\(elapsedMinute)"
        let hoursString = elapsedHour > 9 ? "\(elapsedHour)" : "0\(elapsedHour)"
        
        workedTimeString  = "\(hoursString):\(minutesString):\(secondsString)"
        workTimeLabel.text = workedTimeString
    }
    
    func sumUpBreaks(flow : String) {
        
        var subtractor: Int!
        
        if flow == "onBreak" {
            subtractor = 1
        } else {
            subtractor = 0
        }
        
        if breakCount > 0 {
            
            var breakCountdown = (breakCount-subtractor) * 2
            var tempTotalBreaktime : Double = 0
            var partialBreaktime: Double = 0
            
            if breakCount-subtractor >= 1 {
            
                for i in 1...(breakCount-subtractor) {
                partialBreaktime = timelogTimestamp[breakCountdown].timeIntervalSinceDate(timelogTimestamp[breakCountdown-1])
                tempTotalBreaktime = tempTotalBreaktime + partialBreaktime
                breakCountdown = breakCountdown - 2
                }
            
            }
            totalBreaktime = tempTotalBreaktime
        }
    }
    
    func sumUpWorkDuration() {
        
            let totalShiftTimeInterval = (timelogTimestamp.last)!.timeIntervalSinceDate(timelogTimestamp[0])
            duration = (totalShiftTimeInterval) - (totalBreaktime)
            elapsedTime = Int(duration)
            updateWorkTimerLabel()
        
    }
    
    func runBreakTimer() {
      
        let secondsStringBreak = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
        let minutesStringBreak = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
        let hoursStringBreak = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
        
        breakWatchString  = "\(hoursStringBreak):\(minutesStringBreak):\(secondsStringBreak)"
        breakTimeLabel.text = breakWatchString
        
        if breakSeconds > 0 {
            breakSeconds--
        } else if breakSeconds == 0 && breakMinutes > 0 {
            breakMinutes--
            breakSeconds = 59
        } else if breakMinutes == 0 && breakHours > 0 {
            breakHours--
            breakMinutes = 59
        } else {
            
            notifyBreakOver ()
            breakTimer.invalidate()
            breakTimerOver = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimerOver"), userInfo: nil, repeats: true)
            
        }
    }
    
    //redundant code - need to combine both timers
    func runBreakTimerOver() {
        
        //Show time over break
        breakTitleLabel.textColor = UIColor.redColor()
        breakTitleLabel.text = "You are running over your breaktime"
        breakTimeLabel.textColor = UIColor.redColor()
        editBreakInstruction.textColor = UIColor.redColor()
        editBreakButton.enabled = false
        editBreakInstruction.hidden = true
        
        breakSeconds += 1
        
        if breakSeconds == 60 {
            breakMinutes += 1
            breakSeconds = 0
        }
        
        if breakMinutes == 60 {
            breakHours += 1
            breakMinutes = 0
        }
        
        let breakSecondsString = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
        let breakMinutesString = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
        let breakHoursString = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
        
        breakWatchString  = "\(breakHoursString):\(breakMinutesString):\(breakSecondsString)"
        breakTimeLabel.text = breakWatchString

    }
    
    func displayBreaktime () {
        
        //Display Break time instantly
        let secondsStringBreak = breakSeconds > 9 ? "\(breakSeconds)" : "0\(breakSeconds)"
        let minutesStringBreak = breakMinutes > 9 ? "\(breakMinutes)" : "0\(breakMinutes)"
        let hoursStringBreak = breakHours > 9 ? "\(breakHours)" : "0\(breakHours)"
        breakWatchString  = "\(hoursStringBreak):\(minutesStringBreak):\(secondsStringBreak)"
        breakTimeLabel.text = breakWatchString
        
        
        if breakHoursSet > 0 {
            breakTitleLabel.text = "Your break is set to \(breakHoursSet) hr and \(breakMinutesSet) min"
        } else if breakHoursSet == 0 && breakMinutesSet > 0 {
            breakTitleLabel.text = "Your break is set to \(breakMinutesSet) min"
        } else if breakMinutesSet == 0 && breakSecondsSet > 0 {
            breakTitleLabel.text = "Your break is set to \(breakSecondsSet) sec"
        }
    }
    
    func breakReset () {
        breakMinutes = breakMinutesSet
        breakSeconds = breakSecondsSet
        breakHours = breakHoursSet
    }
    
    func notifyBreakOver() {
        //Notifications outside the App (Home screen and Lock Screen)
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "PUCHIE"
        localNotification.alertBody = "Your breaktime is over!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) //seconds from now
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        //Notifications insdie the App (Home screen and Lock Screen)
        let alert: UIAlertController = UIAlertController(title: "Breaktime is over!",
            message: "Please choose from the following:",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "View", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Clock In", style: .Default, handler: {
            action in self.lapReset(true)
        }))
        alert.addAction(UIAlertAction(title: "Add 5 Minutes", style: .Default, handler: { action in
            
            self.breakTimerOver.invalidate()
            self.breakMinutes = 5
            self.breakSeconds = 0
            self.breakHours = 0
            self.breakTimeLabel.textColor = UIColor.blueColor()
            self.editBreakInstruction.hidden = true
            self.editBreakButton.enabled = false
            self.breakTitleLabel.textColor = UIColor.blueColor()
            self.breakTitleLabel.text = "You've extended your break by 5 minutes"
            self.breakTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runBreakTimer"), userInfo: nil, repeats: true)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// MARK: Table View functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        
        cell.textLabel!.font = UIFont.systemFontOfSize(12.0)
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12.0)

        cell.textLabel!.text = timelogsList[indexPath.row].type
        cell.detailTextLabel!.text = NSDateFormatter.localizedStringFromDate( (timelogsList[indexPath.row].time) , dateStyle: .MediumStyle, timeStyle: .MediumStyle)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelogTimestamp.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.nItemClockIn = timelogsList[indexPath.row] // send up actual
        selectedRowIndex = indexPath.row
        
        if (indexPath.row) == 0 {
            noMinDate = true // user select CLOCKIN so noMinDate
        } else {
            noMinDate = false
            self.nItemClockInPrevious = timelogsList[indexPath.row - 1]
        }
        
        if (timelogsList.count - indexPath.row - 1) == 0 {
            noMaxDate = true //user select last TIMELOD so noMaxDat is sent, and will use NSDATE instead
        } else {
            noMaxDate = false
            self.nItemClockInNext = timelogsList[indexPath.row + 1]
        }
        
        self.performSegueWithIdentifier("showDetails", sender: tableView.cellForRowAtIndexPath(indexPath))

    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

// MARK: Segues (Show)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {

        //Select a Job
        if segue.identifier == "displayJobsList" {
            
            let destinationVC = segue.destinationViewController as! ClockInJobsPopoverViewController
            destinationVC.navigationItem.title = ""
            destinationVC.hidesBottomBarWhenPushed = true;
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target: nil, action: nil)
        }
        
        //Editbreaktime
        if segue.identifier == "editBreaktimeSegue" {
            let destinationVC = segue.destinationViewController as! SetBreakTimeViewController
            destinationVC.navigationItem.title = "Set Breaktime"
            destinationVC.hidesBottomBarWhenPushed = true;
            
            //Passes 2 data variables
            destinationVC.breakMinutes = self.breakMinutesSet
            destinationVC.breakHours = self.breakHoursSet
            //Pass same 2 variable to get the delta
            destinationVC.breakMinutesSetIntial = self.breakMinutesSet
            destinationVC.breakHoursSetIntial = self.breakHoursSet
        }
        
        //Send Core Data to Timelog Details
        if segue.identifier == "showDetails" {
            
            let destinationVC = segue.destinationViewController as! detailsTimelogViewController
            destinationVC.hidesBottomBarWhenPushed = true;
            
            destinationVC.nItem = self.nItemClockIn
            destinationVC.nItemPrevious = self.nItemClockInPrevious
            destinationVC.nItemNext = self.nItemClockInNext
            destinationVC.jobLabelDisplay = jobTitleDisplayLabel.text!
            destinationVC.noMinDate = self.noMinDate
            destinationVC.noMaxDate = self.noMaxDate
        }

    }

// MARK: Segues (Unwind) = Getting data from sourceVC
    
    @IBAction func unwindFromClockInPopoverViewControllerAction (segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! ClockInJobsPopoverViewController
        
        if((sourceVC.selectedJobIndex) != nil ) {
            selectedJobIndex = sourceVC.selectedJobIndex
        }
    }
    
    @IBAction func unwindFromSetBreakTimeViewController (segue: UIStoryboardSegue) {
        
        let sourceVC = segue.sourceViewController as! SetBreakTimeViewController
        
        if((sourceVC.breakHours) >= 0 ) {
            breakHoursSet = sourceVC.breakHours
            println("breakHoursSet from SetBreaktime = \(breakHours)")
            breakHoursChange = ( sourceVC.breakHours - sourceVC.breakHoursSetIntial )
            println("breakHoursChange = \(breakHoursChange)")
            
            breakHours =  (breakHours + breakHoursChange)
            
            if breakHours < 0 {
                breakHours = 0
                breakMinutes = breakMinutes - 59
            }
            
         
        }
        
        if((sourceVC.breakMinutes) >= 0 ) {
            breakMinutesSet = sourceVC.breakMinutes
            println("breakMinutesSet from SetBreaktime = \(breakMinutes)")
            breakMinutesChange = ( sourceVC.breakMinutes - sourceVC.breakMinutesSetIntial )
            println("breakMinutesChange = \(breakMinutesChange)")
            breakMinutes = (breakMinutes + breakMinutesChange)
            
            if breakMinutes < 0 {
                breakMinutes = 0
                breakSeconds = breakSeconds - 59
                
                if breakSeconds < 0 {
                    breakSeconds = 0
                }
            }
        }
        
        displayBreaktime ()

    }
    
    @IBAction func unwindFromDetailsTimelogViewController (segue: UIStoryboardSegue) {
        
        let sourceVC = segue.sourceViewController as! detailsTimelogViewController
        
        timelogTimestamp[selectedRowIndex] = sourceVC.nItem.time
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

