//
//  PollShared.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/9/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class PollShared: UITableViewCell
{
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var pollCreated: UILabel!
    @IBOutlet weak var pollIdentity: UIImageView!

    @IBOutlet weak var nameofSharer: UILabel!
    @IBOutlet weak var sharedOn: UILabel!
    @IBOutlet weak var voteNo: UILabel!
    
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var textBox: UITextView!
    
    @IBOutlet weak var expiryPic: UIImageView!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var totalPic: UIImageView!
    @IBOutlet weak var BgImg: UIImageView!
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