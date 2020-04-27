//
//  SchemeTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 24/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class SchemeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var schemeName: UILabel!
    @IBOutlet weak var serialNUmber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
