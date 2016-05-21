//
//  NotificationTableViewCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/8/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell
{

    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var detailsText: UITextView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
