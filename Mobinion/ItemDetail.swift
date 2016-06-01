//
//  ItemDetail.swift
//  Grabber
//
//  Created by Hamdan on 08/04/15.
//  Copyright (c) 2015 Novateur Glow. All rights reserved.
//

import UIKit

class ItemDetail: UITableViewCell
{
    @IBOutlet var PrdctDescp:UILabel!
    @IBOutlet var Price:UILabel!
    @IBOutlet var ChckBtn:UIButton!
    @IBOutlet var Qty:UILabel!
    @IBOutlet var ItemImg:UIImageView!
//    @IBOutlet var OrderNum:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



