//
//  FollowTableViewCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/23/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell
{

//    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileProfession: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
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
