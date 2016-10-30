//
//  TeatherCell.swift
//  FindTeather
//
//  Created by gj on 2016/9/12.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {


    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var skillLabel: MTAlignLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        skillLabel.textColor = yijiBlue
    }

    
    func bind(model: Answer) {
        
        nameLabel.text = model.date
        
        skillLabel.text  = model.answer
        skillLabel.sizeToFit()
        
    }

}

