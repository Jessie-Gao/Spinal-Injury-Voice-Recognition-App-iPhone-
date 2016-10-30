//
//  BaseViewController.swift
//  Firefly
//
//  Created by gj on 16/9/29.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit


class BaseViewController: SegueViewController {
    
    var animatedOnNavigationBar = true
    
    deinit {
        print("------------------\(String(self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        self.edgesForExtendedLayout = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // left
    func addNavigationBarLeftButton(taget: AnyObject?, action: Selector, image: UIImage) {
        let leftButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        leftButton.setImage(image, forState: .Normal)
        leftButton.addTarget(taget, action: action, forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
    }
    // right
    func addNavigationBarRightButton(taget: AnyObject?, action: Selector, image: UIImage) {
        let rightButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightButton.setImage(image, forState: .Normal)
        rightButton.addTarget(taget, action: action, forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    // title
    func addcenterBarItem(title: String) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 29, height: 31))
        titleLabel.text = title
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleLabel
        return titleLabel
    }
    
    // back
    func popBack() {
        if let root = self.navigationController?.viewControllers[0] {
            if root == self {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }

    
    func showTips(message: String)  {
        let tipView: PopLauncher = {
            
            let launcher = PopLauncher()
            return launcher
            
        }()
        tipView.showPopUp(UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00), informationString: message, durationOnScreen: 1.2, currentView: self.view, showsBackgroundGradient: false, isAboveTabBar: true)
    }
    
}
