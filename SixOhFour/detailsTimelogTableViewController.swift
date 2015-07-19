

import UIKit
import CoreData

class detailsTimelogViewController: UITableViewController, UIPickerViewDelegate {

    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var timestampPicker: UIDatePicker!
    
    var jobLabelDisplay = ""
    var jobColorDisplayPassed : UIColor!
    var doneButton : UIBarButtonItem!

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : TimeLogs? = nil // will change from pushed data Segue
//    var nItem : TimeLogs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobColorDisplay.color = jobColorDisplayPassed
        jobLabel.text = jobLabelDisplay
        entryLabel.text = nItem!.timelogTitle
        timestampLabel.text = nItem!.timelogTimestamp
        commentTextField.text = nItem!.timelogComment

        
        doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneSettingDetails")
        self.navigationItem.rightBarButtonItem = doneButton


        datePickerChanged(timestampLabel, timestampPicker)

        
    }
    
    @IBAction func timestampChanged(sender: AnyObject) {
        datePickerChanged(timestampLabel, timestampPicker)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editItem() {
        nItem!.timelogJob = jobLabel.text!
        nItem!.timelogTitle = entryLabel.text!
        nItem!.timelogTimestamp = timestampLabel.text!
        nItem!.timelogComment = commentTextField.text
        println(nItem)
        context!.save(nil)
    }
    
    func doneSettingDetails () {
        editItem()
        println(nItem)
        self.performSegueWithIdentifier("unwindFromDetailsTimelogViewController", sender: self)
    }
}

// MARK: - Date Picker

func datePickerChanged(label: UILabel, datePicker: UIDatePicker) {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
    
    label.text = dateFormatter.stringFromDate(datePicker.date)
    
    datePicker.maximumDate = NSDate()
    
//    if datePicker == timestampPicker {
//        if datePicker.date.compare(timestampPicker.date) == NSComparisonResult.OrderedDescending {
//            endLabel.text = label.text
//            endDatePicker.date = datePicker.date
//        } else {
//            endLabel.text = dateFormatter.stringFromDate(endDatePicker.date)
//        }
//    }
    
    
//    toggleSaveButton()
}


    