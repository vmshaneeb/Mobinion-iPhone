//
//  polls_TableViewCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/7/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class polls_TableViewCell: UITableViewCell
{

    @IBOutlet weak var pollType: UILabel!
    @IBOutlet weak var pollCreated: UILabel!
    @IBOutlet weak var pollContent: UITextView!
    @IBOutlet weak var expIcon: UIImageView!
    @IBOutlet weak var expType: UILabel!

    
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
