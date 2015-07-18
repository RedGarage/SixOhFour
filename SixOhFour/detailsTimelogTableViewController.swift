

import UIKit
import CoreData

class detailsTimelogViewController: UITableViewController{ //, writeValueBackDelegate {
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    var doneButton : UIBarButtonItem!

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : TimeLogs! // will change from pushed data Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        jobLabel.text = nItem?.timelogJob
        entryLabel.text = nItem?.timelogTitle
        timestampLabel.text = nItem?.timelogTimestamp
        commentTextField.text = nItem?.timelogComment

        
        doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneSettingDetails")
        self.navigationItem.rightBarButtonItem = doneButton

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func editItem() {
        nItem!.timelogJob = jobLabel.text!
        nItem!.timelogTitle = entryLabel.text!
        nItem!.timelogTimestamp = timestampLabel.text!
        nItem!.timelogComment = commentTextField.text!
        println(nItem)
        context!.save(nil)
    }
    
    func doneSettingDetails () {
        editItem()
        println(nItem)
        self.performSegueWithIdentifier("unwindFromDetailsTimelogViewController", sender: self)
    }
}
