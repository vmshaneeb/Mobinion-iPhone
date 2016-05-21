//
//  AroundMeTableViewCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/7/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class AroundMeTableViewCell: UITableViewCell
{

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contest_Image: UIImageView!
    
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
