//
//  PIAListTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class PIAListTableViewCell: UITableViewCell
{
    
    @IBOutlet var editOutlet: UIButton!
    
    @IBOutlet var serilaNumber: UILabel!
    
    @IBOutlet var academyName: UILabel!
    
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
