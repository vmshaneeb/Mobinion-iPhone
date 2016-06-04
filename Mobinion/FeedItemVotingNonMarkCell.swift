//
//  FeedItemVotingNonMarkCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 6/4/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class FeedItemVotingNonMarkCell: UITableViewCell
{
    @IBOutlet weak var sno: UILabel!
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    
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
