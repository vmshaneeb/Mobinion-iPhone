//
//  NewsFeedTableViewCell4.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/24/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell4: UITableViewCell
{
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var followPic: UIImageView!
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var profJob: UILabel!

    @IBOutlet weak var followBtn: UIButton!
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
