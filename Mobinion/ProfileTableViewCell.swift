//
//  ProfileTableViewCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/7/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell
{
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var textView: UITextView!

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
