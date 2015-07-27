//
//  AddJobTableViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class AddJobTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var payRateLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var jobColorView: JobColorView!
    @IBOutlet weak var saveJobButton: UIBarButtonItem!
    
    var payRate = PayRate()
    
    let pickerData = ["Red", "Blue", "Green", "Yellow", "Purple"]
    
    var pickerVisible = false
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var nItem : Jobs? = nil
    
//    @IBAction func payRateButtonPressed(sender: AnyObject) {
//        let addJobStoryboard: UIStoryboard = UIStoryboard(name: "AddJobStoryboard", bundle: nil)
//        var payRateTableViewController: PayRateTableViewController = addJobStoryboard.instantiateViewControllerWithIdentifier("PayRateTableViewController") as! PayRateTableViewController
//        payRateTableViewController.writeValueDelegate = self
//        
//        payRateTableViewController.
//        
//        navigationController?.pushViewController(payRateTableViewController, animated: true)
//    }
    
    @IBAction func saveJobButton(sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func unwindFromPayRateTableViewController(segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! PayRateTableViewController
        payRateLabel.text = sourceVC.payRate.payRate
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        colorPicker.dataSource = self
        colorPicker.delegate = self

        if nItem != nil {
            nameTextField.text = nItem?.jobName
            positionTextField.text = nItem?.jobPosition
            payRateLabel.text = nItem?.jobPay
// (colorLabel.text = nItem?.jobColor)
            if jobColorView != nil {
                var jc = JobColor()
                jobColorView.color = jc.getJobColor(colorLabel.text!)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if nameTextField.text == "" {
            self.navigationItem.rightBarButtonItem!.enabled = false
        }
        
         nameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        var selectedColor = 0
        
        for var i = 0; i < pickerData.count; i++ {
            var color = colorLabel.text!
            if pickerData[i] == color {
                selectedColor = i
            }
        }
        
        colorPicker.selectRow(selectedColor, inComponent: 0, animated: true)
    }
    
    func textFieldDidChange(textField: UITextField) {
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if textField.text.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            self.navigationItem.rightBarButtonItem!.enabled = true

        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            pickerVisible = !pickerVisible
            tableView.reloadData()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 4 {
            if pickerVisible == false {
                return 0.0
            }
            return 150.0
        }
        return 44.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func writeValueBack(vc: PayRateTableViewController, value: String) {
//        self.payRateLabel.text = "$\(value)"
//    }
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("Jobs", inManagedObjectContext: context!)
            
        let nItem = Jobs(entity: ent!, insertIntoManagedObjectContext: context)
        nItem.jobName = nameTextField.text
        nItem.jobPosition = positionTextField.text
        nItem.jobPay = payRateLabel.text!
// (nItem.jobColor = colorLabel.text!)
        context!.save(nil)
    }
        
    func editItem() {
        nItem!.jobName = nameTextField.text
        nItem!.jobPosition = positionTextField.text
        nItem!.jobPay = payRateLabel.text!
// (nItem!.jobColor = colorLabel.text!)
        context!.save(nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorLabel.text = pickerData[row]
        
        var jc = JobColor()
        jobColorView.color = jc.getJobColor(pickerData[row])
        jobColorView.setNeedsDisplay()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "payRate" {
            let destinationVC = segue.destinationViewController as! PayRateTableViewController
            destinationVC.payRate = self.payRate
        }
    }
    
}
