//
//  TimeTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 11/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var toTime: UILabel!
    
    @IBOutlet weak var fromTime: UILabel!
    
    @IBOutlet weak var sessionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
