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
    var job: Job!
    var pickerVisible = false
    
    let pickerData = ["Red", "Blue", "Green", "Yellow", "Purple"]
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func saveJobButton(sender: AnyObject) {
        if job != nil {
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
        
        if job != nil {
            nameTextField.text = job.company.name
            positionTextField.text = job.position
            payRateLabel.text = "\(job.payRate)"
            colorLabel.text = job.color.name
            var jc = JobColor()
            jobColorView.color = jc.getJobColor(colorLabel.text!)
        }
        
        if job != nil {
            payRate.payRate = "\(job.payRate)"
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
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("Job", inManagedObjectContext: context!)
        let com = NSEntityDescription.entityForName("Company", inManagedObjectContext: context!)
        let col = NSEntityDescription.entityForName("Color", inManagedObjectContext: context!)
        
        
        let company = Company(entity: com!, insertIntoManagedObjectContext: context)
        let color = Color(entity: col!, insertIntoManagedObjectContext: context)
        let job = Job(entity: ent!, insertIntoManagedObjectContext: context)
        
        
        company.name = nameTextField.text
        color.name = colorLabel.text!
        
        
        job.setValue(company, forKey: "company")
        job.position = positionTextField.text
        job.payRate = NSDecimalNumber(string: payRateLabel.text)
        job.setValue(color, forKey: "color")
        
        println(job.company.name)
        println(job.color.name)
        
        println(color)
        print(job)
        print(company)
        context!.save(nil)
    }
    
    func editItem() {
        job.company.name = nameTextField.text
        job.position = positionTextField.text
        job.payRate = NSDecimalNumber(string: payRateLabel.text)
        job.color.name = colorLabel.text!
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