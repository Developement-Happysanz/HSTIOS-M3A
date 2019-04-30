//
//  ProjectPeriodTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 09/04/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class ProjectPeriodTableViewCell: UITableViewCell {

    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var fromLabel: UILabel!
    
    @IBOutlet var toLabel: UILabel!
    
    @IBOutlet var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
