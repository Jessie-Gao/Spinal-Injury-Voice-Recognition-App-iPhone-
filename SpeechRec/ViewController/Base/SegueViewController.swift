//
//  SegueViewController.swift
//  Firefly
//
//  Created by gj on 16/9/29.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit

class SegueViewController: UIViewController {
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
        if let navigationController = navigationController {
            guard navigationController.topViewController == self else {
                return
            }
        }
        
        super.performSegueWithIdentifier(identifier, sender: sender)
    }
}
