//
//  TaskCell.swift
//  Done
//
//  Created by Michael Miles on 1/7/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
