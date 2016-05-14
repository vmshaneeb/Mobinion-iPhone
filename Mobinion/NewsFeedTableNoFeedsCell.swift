//
//  NewsFeedTableNoFeedsCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/24/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NewsFeedTableNoFeedsCell: UITableViewCell
{
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var choosePic: UIImageView!
    @IBOutlet weak var textBox: UITextView!
    
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
