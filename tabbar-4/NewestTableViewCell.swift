//
//  NewestTableViewCell.swift
//  tabbar-4
//
//  Created by remote_edit on 2019/4/22.
//  Copyright © 2019 1c7. All rights reserved.
//

import UIKit

class NewestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var serieName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cc_image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
