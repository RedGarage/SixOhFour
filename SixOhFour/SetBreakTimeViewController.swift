//
//  SetBreakTimeViewController.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/16/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class SetBreakTimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var SetBreakTimePicker: UIPickerView!
    
    var breakHours = 3
    var breakMinutes = 59
    var breaktimeLabel : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.SetBreakTimePicker.dataSource = self
        self.SetBreakTimePicker.delegate = self

        var breaktimeLabel = "\(breakMinutes) min"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Set Break Time Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return breakHours
        } else if component == 1 {
            return breakMinutes
        } else {
            return 0
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if component == 0 {
        return "\(row)"
        } else {
        return "\(row)"
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            breaktimeLabel = "None"
        } else {
            breaktimeLabel = "\(row) minutes before"
        }
    }}
