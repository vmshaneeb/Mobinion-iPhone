//
//  CreatePollTableViewCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/19/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class CreatePollTableViewCell: UITableViewCell
{

    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var optionsField: UITextField!
    
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
