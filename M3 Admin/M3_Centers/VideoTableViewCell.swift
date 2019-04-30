//
//  VideoTableViewCell.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 08/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import YouTubePlayer


class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
