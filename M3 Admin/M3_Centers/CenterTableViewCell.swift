//
//  CenterTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 31/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class CenterTableViewCell: UITableViewCell
{

    @IBOutlet weak var centerName: UILabel!
    
    @IBOutlet weak var centerLocation: UILabel!
    
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
