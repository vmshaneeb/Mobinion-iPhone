//
//  CreatePollPicOptionCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/19/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

class CreatePollPicOptionCell: UITableViewCell
{

    @IBOutlet weak var countField: UILabel!
    @IBOutlet weak var imagePlaceHolderView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var imagePlaceHolderImageView: UIImageView!
    @IBOutlet weak var snapView: UIView!
    @IBOutlet weak var chooseView: UIView!
    
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
