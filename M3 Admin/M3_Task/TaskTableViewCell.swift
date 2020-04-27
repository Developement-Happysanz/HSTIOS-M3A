//
//  TaskTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 22/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet var subView: UIView!
    @IBOutlet var tasktitle: UILabel!
    @IBOutlet weak var taskDetails: UILabel!
    @IBOutlet var deleteOutlet: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var assignedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
