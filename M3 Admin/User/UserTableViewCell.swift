//
//  UserTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 19/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var role: UILabel!
    
    @IBOutlet var status: UILabel!
    
    @IBOutlet weak var downloadOutlet: UIButton!
    
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
