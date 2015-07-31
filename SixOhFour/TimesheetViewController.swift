//
//  TimesheetViewController.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/24/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class TimesheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
