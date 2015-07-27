//
//  JobsListCell.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/10/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class JobsListCell: UITableViewCell {

    @IBOutlet weak var jobColorView: JobColorView!
    @IBOutlet weak var jobNameLabel: UILabel!
    
    var job: Jobs! {
        didSet {
            jobNameLabel.text = job.jobName
            
            var jc = JobColor()
// (jobColorView.color = jc.getJobColor(job.jobColor))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
