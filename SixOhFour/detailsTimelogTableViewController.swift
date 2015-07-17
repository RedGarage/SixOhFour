

import UIKit
import CoreData

class detailsTimelogViewController: UITableViewController{ //, writeValueBackDelegate {
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
//    @IBAction func payRateButtonPressed(sender: AnyObject) {
//        let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
//        var payRateTableViewController: PayRateTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("PayRateTableViewController") as! PayRateTableViewController
//        payRateTableViewController.writeValueDelegate = self
//        navigationController?.pushViewController(payRateTableViewController, animated: true)
//    }
    
//    @IBAction func saveJobButton(sender: AnyObject) {
//        if nItem != nil {
//            editItem()
//        } else {
//            newItem()
//        }
//        navigationController?.popToRootViewControllerAnimated(true)
//    }
    
    @IBAction func doneButton(sender: AnyObject) {
            editItem()
            navigationController?.popToRootViewControllerAnimated(true)
        }

    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : TimeLogs? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(nItem)
        
        if nItem != nil {
        
            jobLabel.text = nItem?.timelogJob
            entryLabel.text = nItem?.timelogTitle
            timestampLabel.text = nItem?.timelogTimestamp
            commentTextField.text = nItem?.timelogComment
        
        } else {
            
        jobLabel.text = "Red Garage"
        entryLabel.text = "Test"
        timestampLabel.text = "Test2"
        commentTextField.text = "Test3"

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func writeValueBack(vc: PayRateTableViewController, value: String) {
//        self.payRateLabel.text = "$\(value)"
//    }
    
    
//    func newItem() {
//        let context = self.context
//        let ent = NSEntityDescription.entityForName("Jobs", inManagedObjectContext: context!)
//        
//        let nItem = TimeLogs(entity: ent!, insertIntoManagedObjectContext: context)
//        nItem.timelogJob = jobLabel.text!
//        nItem.timelogTitle = entryLabel.text!
//        nItem.timelogTimestamp = timestampLabel.text!
//        nItem.timelogComment = commentTextField.text!
//        context!.save(nil)
//    }
    
    
    func editItem() {
//        nItem!.timelogJob = jobLabel.text!
//        nItem!.timelogTitle = entryLabel.text!
//        nItem!.timelogTimestamp = timestampLabel.text!
//        nItem!.timelogComment = commentTextField.text!
        println(nItem)
        context!.save(nil)
    }
    
}
