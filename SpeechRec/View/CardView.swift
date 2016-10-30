
//  Created by gj on 16/10/15.
//  Copyright (c) 2015 SpeechRec. All rights reserved.
//

import UIKit

typealias QuestionReplayedBlock = (index: Int) -> Void

class CardView: UIView {

    var replayedBlock: QuestionReplayedBlock?
    
    let questionLabel = UILabel()
    
    var checkBoxs: [VKCheckbox] = []
    
    var questionDes: String? {
        get {return self.questionDes}
        set {
            self.questionLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.33
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 3.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 5.0;
        
        questionLabel.frame = CGRect(x: 10, y: 10, width: Int(self.frame.size.width - 20), height: 64)
        questionLabel.numberOfLines = 0;
        questionLabel.font = UIFont.boldSystemFontOfSize(17)
        questionLabel.textColor = UIColor.whiteColor()
        self.addSubview(questionLabel)
        
        for i in 1...9 {
            let checkBox = VKCheckbox()
            checkBox.frame = CGRect(x: 30, y: Int(questionLabel.maxY) + i * (10 + 30) , width: 30, height: 30)
            checkBox.line             = .Normal
            checkBox.bgColorSelected  = yijiBlue
            checkBox.bgColor          = UIColor.whiteColor()
            checkBox.color            = UIColor.whiteColor()
            checkBox.borderColor      = UIColor.whiteColor()
            checkBox.borderWidth      = 2
            checkBox.cornerRadius     = CGRectGetHeight(checkBox.frame) / 2
            checkBoxs.append(checkBox)
            self.addSubview(checkBox)
            
            let textLabel = UILabel(frame: CGRect(x: 75, y: Int(checkBox.y), width: 100, height: 30))
            textLabel.text = String(i)
            textLabel.font = UIFont.systemFontOfSize(18)
            textLabel.textColor = UIColor.whiteColor()
            self.addSubview(textLabel)
            
            checkBox.checkboxValueChangedBlock = { isOn in
                if isOn {
                    self.replayedBlock?(index: self.checkBoxs.indexOf(checkBox)!)
                }
            }
        }
    }
    
    // choose
    internal func choiseOption(index: Int) {
        
        for cb in checkBoxs {
            cb.setOn(false)
        }

        checkBoxs[index] .setOn(true, animated: true)

    }
}
