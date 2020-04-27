//
//  DocumentTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var downloadButton: UIButton!
    var cellIndex:NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
