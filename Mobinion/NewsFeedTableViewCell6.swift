//
//  NewsFeedTableViewCell6.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/24/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell6: UITableViewCell
{
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var winnerBanner: UIImageView!
    @IBOutlet weak var winnerNo: UIImageView!

    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UITextView!
    @IBOutlet weak var text3: UILabel!
    
    
    @IBOutlet weak var discardBtn: UIButton!
    
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
