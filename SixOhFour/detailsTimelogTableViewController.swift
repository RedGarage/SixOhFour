

import UIKit
import CoreData

class detailsTimelogViewController: UITableViewController, UIPickerViewDelegate {

    @IBOutlet weak var jobColorDisplay: JobColorView!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var timestampPicker: UIDatePicker!
    
    var entrySelectedIndex : Int = -1
    var jobLabelDisplay = ""
    var jobColorDisplayPassed : UIColor!
    var doneButton : UIBarButtonItem!

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : TimeLogs? = nil // will change from pushed data Segue
    
    var nItem2 : TimeLogs? = nil // will change from pushed data Segue
    
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

        if nItem2 == nil {
            //No Minimum Data
        } else {
            println("YOOOOOOOOOOOOOOOOOOOOOOOnItem2 = \(nItem2)")
            
            //Calculate Minimum date (convert String to NSDate)
        let minDateString = nItem2!.timelogTimestamp
        let dateFormatterMin = NSDateFormatter()
        dateFormatterMin.dateFormat = "MMM dd, yyyy, hh:mm:ss aa"
        let minDate = dateFormatterMin.dateFromString(minDateString)
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var newMinDate = calendar.dateByAddingUnit(.CalendarUnitHour, value: -7, toDate: minDate!, options: nil)
        println("newMinDate = \(newMinDate)")
        timestampPicker.minimumDate = newMinDate
        }
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

}


    