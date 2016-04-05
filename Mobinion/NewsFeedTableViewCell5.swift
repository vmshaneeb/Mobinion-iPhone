//
//  NewsFeedTableViewCell5.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/24/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell5: UITableViewCell
{
    @IBOutlet weak var nameofSharer: UILabel!
    @IBOutlet weak var sharedOn: UILabel!

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var voteIdentity: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var voteNo: UILabel!
    
    @IBOutlet weak var div: UIImageView!
    @IBOutlet weak var Im2: UIImageView!
    
    @IBOutlet weak var IMView: UIImageView!
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet weak var poleExpiryPic: UIImageView!
    @IBOutlet weak var poleExpiry: UILabel!
    @IBOutlet weak var totalPolePic: UIImageView!
    @IBOutlet weak var totalPoles: UILabel!
    
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
