//
//  PayRateTableViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/9/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import CoreData

class PayRateTableViewController: UITableViewController {
    
    var payRate: PayRate!
    var saveButton: UIBarButtonItem!
    var job: Job!

    @IBOutlet weak var payTextField: UITextField!
    @IBOutlet weak var toggleOvertime: UISwitch!
    @IBOutlet weak var toggleSpecial: UISwitch!
    @IBOutlet weak var toggleShift: UISwitch!
    @IBOutlet weak var eightHrSwitch: UISwitch!
    @IBOutlet weak var twelveHrSwitch: UISwitch!
    @IBOutlet weak var holidaySwitch: UISwitch!
    
    @IBAction func holidaySwitch(sender: AnyObject) {
        //TODO: Implement Holiday Switch Functionality
    }
    
    @IBAction func twelveHrSwitch(sender: AnyObject) {
        //TODO: Implement 12hr Switch Functionality
    }
    
    @IBAction func eightHrSwitch(sender: AnyObject) {
        //TODO: Implement 8hr Switch Functionality
    }
    
    @IBAction func toggleOvertimeValue(sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func toggleSpecialValue(sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func toggleShiftValue(sender: AnyObject) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "savePayRate")
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.title = "Pay Rate"
        
        payTextField.text = payRate.payRate
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 && toggleOvertime.on == false {
            return 0
        }
        else if indexPath.section == 1 && indexPath.row == 2 && toggleOvertime.on == false {
            return 0
        }
        else if indexPath.section == 2 && indexPath.row == 1 && toggleSpecial.on == false {
            return 0
        }
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func savePayRate() {
        payRate.payRate = payTextField.text
        self.performSegueWithIdentifier("unwindFromPayRate", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
