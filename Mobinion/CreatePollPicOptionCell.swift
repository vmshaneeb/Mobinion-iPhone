//
//  CreatePollPicOptionCell.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 5/19/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate
{
    func tapSnapViewinCell(cell: CreatePollPicOptionCell)
    func tapChooseViewinCell(cell: CreatePollPicOptionCell)
}

class CreatePollPicOptionCell: UITableViewCell
{

    @IBOutlet weak var countField: UILabel!
    
    @IBOutlet weak var imagePlaceHolderView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var imagePlaceHolderImageView: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var snapView: UIView!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var takesnapBtn: UIButton!
    @IBOutlet weak var choosefileBtn: UIButton!
    
    var delegate: ImagePickerDelegate?
    
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
    
    @IBAction func snapBtn(sender: AnyObject)
    {
        delegate?.tapSnapViewinCell(self)
    }
    
    @IBAction func chooseBtn(sender: AnyObject)
    {
        delegate?.tapChooseViewinCell(self)
    }
    
    @IBAction func delBtn(sender: UIButton)
    {
        imagePlaceHolderImageView.image = nil
        stackView.hidden = false
    }
}
