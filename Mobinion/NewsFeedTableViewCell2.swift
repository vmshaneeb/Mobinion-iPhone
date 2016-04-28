//
//  NewsFeedTableViewCell2.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/24/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell2: UITableViewCell
{
    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var VotName: UILabel!
    @IBOutlet weak var voCreated: UILabel!
    @IBOutlet weak var voteIdentifier: UIImageView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet weak var expiryPic: UIImageView!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var totalPic: UIImageView!
    @IBOutlet weak var totalNos: UILabel!
    
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
