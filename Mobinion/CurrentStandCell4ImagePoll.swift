//
//  CurrentStandCell4ImagePoll.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 6/3/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class CurrentStandCell4ImagePoll: UITableViewCell
{
    
    @IBOutlet weak var pollPieColor: UIImageView!
    @IBOutlet weak var pollImg: UIImageView!
    @IBOutlet weak var totVotes: UILabel!

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
