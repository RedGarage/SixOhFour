//
//  DetailsTableViewController.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 8/13/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DetailsTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var timestampPicker: UIDatePicker!
    @IBOutlet weak var minTimeLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    
    var doneButton : UIBarButtonItem!
    
    //PUSHED IN DATA when segued
    var selectedJob : Job!
    var noMinDate = false
    var noMaxDate = false
    var nItem : Timelog!
    var nItemPrevious : Timelog!
    var nItemNext : Timelog!
    var jobLabelDisplay = String()
    
    var hideTimePicker = true
    
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryLabel.text = nItem.type
        timestampLabel.text = "\(nItem.time)"
        minTimeLabel.hidden = true
        commentTextView.text = nItem.comment
        commentTextView.delegate = self
        
        doneButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveDetails")
        self.navigationItem.rightBarButtonItem = doneButton
        var cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelDetails")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        timestampPicker.date = nItem.time
        
        datePickerChanged(timestampLabel!, datePicker: timestampPicker!)
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        
        // TODO : Need to set restrictions of 24hrs when picking times for both min and max. Hurdle = how are you going to handle when the WS only has 1 entry CI.. what is the min?
        if noMinDate == true {
            //No Minimum Data
            minTimeLabel.text = ""
        } else {
            timestampPicker.minimumDate = nItemPrevious.time
            minTimeLabel.text = "\(nItemPrevious.type): \(dateFormatter(nItemPrevious.time))"
        }
        
        // TODO : Need to set restrictions of 24hrs when picking times for both min and max
        if noMaxDate == true {
            //No NextTimeStamp for Maxium Data
            //And no MinDate to set 24hr restriction
            
            if nItem.type == "Clocked Out" {
                timestampPicker.maximumDate = NSDate().dateByAddingTimeInterval(8*60*60)
                maxTimeLabel.text = "Cannot exceed 8 hrs from now."
            } else {
                timestampPicker.maximumDate = NSDate()
                maxTimeLabel.text = "Cannot select a future time."
            }
        } else {
            timestampPicker.maximumDate = nItemNext.time
            maxTimeLabel.text = "\(nItemNext.type): \(dateFormatter(nItemNext.time))"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        jobLabel.text = selectedJob.company.name
        jobColorDisplay.color = selectedJob.color.getColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func timestampChanged(sender: AnyObject) {
        
        datePickerChanged(timestampLabel!, datePicker: timestampPicker!)
        
        if noMinDate == true {
            //need to add code that prevents the user from selecting a date that exceeds theyre previous shift
        } else {
            if (timestampPicker.date.compare(timestampPicker.minimumDate!)) == NSComparisonResult.OrderedAscending || timestampPicker.date == timestampPicker.minimumDate {
                minTimeLabel.hidden = false
                timestampLabel.text = "\(dateFormatter(timestampPicker.minimumDate!))"
            }
        }
        
        if noMaxDate == true {
            if timestampPicker.date.timeIntervalSinceNow > -120 {
                maxTimeLabel.hidden = false
            }
        } else {
            if timestampPicker.date.timeIntervalSinceDate(timestampPicker.maximumDate!) > -60 {
                maxTimeLabel.hidden = false
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        commentTextView.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        commentTextView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    func editItem() {
        nItem.type = entryLabel.text!
        nItem.time = timestampPicker.date
        nItem.comment = commentTextView.text
        nItem.lastUpdate = NSDate()
        
        if noMinDate == false && (timestampPicker.date.compare(timestampPicker.minimumDate!)) == NSComparisonResult.OrderedAscending {
            nItem.time = timestampPicker.minimumDate!
        } else {
            nItem.time = timestampPicker.date
        }
    }
    
    func saveDetails () {
        editItem()
        dataManager.save()
        self.performSegueWithIdentifier("unwindSaveDetailsTVC", sender: self)
    }
    
    func cancelDetails () {
        self.performSegueWithIdentifier("unwindCancelDetailsTVC", sender: self)
    }
    
    // MARK: - Date Picker
    
    func datePickerChanged(label: UILabel, datePicker: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        label.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    func hideTimePicker(status: Bool) {
        
        if status {
            timestampPicker.hidden = true
            minTimeLabel.hidden = true
            maxTimeLabel.hidden = true
            hideTimePicker = true
        } else {
            timestampPicker.hidden = false
            hideTimePicker = false
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func dateFormatter (timestamp: NSDate) -> String {
        // NOTE: Convert from NSDate to regualer
        let dateString = NSDateFormatter.localizedStringFromDate( timestamp , dateStyle: .MediumStyle, timeStyle: .MediumStyle)
        return dateString
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        commentTextView.resignFirstResponder()
        
        if hideTimePicker == false {
            hideTimePicker(true)
            hideTimePicker = true
        } else if indexPath.row == 2 && hideTimePicker {
            hideTimePicker(false)
            hideTimePicker = false
        } else if indexPath.row == 0 {
            let addJobStoryboard: UIStoryboard = UIStoryboard(name: "CalendarStoryboard", bundle: nil)
            let jobsListVC: JobsListTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("JobsListTableViewController")
                as! JobsListTableViewController
            jobsListVC.source = "details"
            jobsListVC.previousSelection = self.selectedJob
            
            self.navigationController?.pushViewController(jobsListVC, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if hideTimePicker && indexPath.row == 3 {
            hideTimePicker(true)
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
    }
    
    //MARK: Segues
    @IBAction func unwindFromJobsListTableViewControllerToDetails (segue: UIStoryboardSegue) {
        
        let sourceVC = segue.sourceViewController as! JobsListTableViewController
        selectedJob = sourceVC.selectedJob
        
        if sourceVC.selectedJob != nil {
            selectedJob = sourceVC.selectedJob
            jobColorDisplay.color = selectedJob.color.getColor
        }
    }
}