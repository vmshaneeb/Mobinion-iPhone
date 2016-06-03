//
//  CurrentStandImgCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 6/2/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class CurrentStandImgCell: UITableViewCell
{
    @IBOutlet weak var profImg: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
