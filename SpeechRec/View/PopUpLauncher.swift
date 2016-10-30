//
//  PopUpLauncher.swift
//  FindTeather
//
//  Created by gj on 2016/9/21.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit

class PopLauncher : NSObject {
    
    //  Gradient Background View
    let gradientBackground : UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        view.layer.masksToBounds = true
        return view
        
    }()
    
    //  PopUpView
    let downloadedPopup : UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
        
        
    }()
    
    //  Information Label
    let informationLabel : UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(red:0.13, green:0.32, blue:0.62, alpha:1.00)
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize( 15)
        return label
        
    }()
    
    
    //  Initialisation
    override init() {
        super.init()
        
        //  Setup the View and Background
        
        
    }
    
    // Show Pop Up
    func showPopUp(roundedViewBackgroundColor: UIColor, informationString : String, durationOnScreen: Double, currentView: UIView, showsBackgroundGradient: Bool, isAboveTabBar: Bool) {
        
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            //  Gradient Background
            gradientBackground.backgroundColor = UIColor.clearColor()
            gradientBackground.frame = CGRect(x: 0, y: -60, width: window.frame.width, height: 60)
            
            
            //  Show Gradient if true
            if showsBackgroundGradient == true {
                
                self.backgroundGradientLayer( gradientBackground, overLayView: currentView)
                
            }
            
            gradientBackground.layer.masksToBounds = true
            window.addSubview(gradientBackground)
            
            
            
            //  Download Popup
            gradientBackground.addSubview(downloadedPopup)
            downloadedPopup.frame = CGRect(x: 25, y: 10, width: gradientBackground.width - 50, height: 40)
            downloadedPopup.backgroundColor = roundedViewBackgroundColor
            
            
            
            //  Information Label
            downloadedPopup.addSubview(informationLabel)
            informationLabel.frame = CGRect(x: 10, y: 10, width: downloadedPopup.width - 20, height: 20)
            informationLabel.text = informationString
            
            
            
            //  #### Timer to Hide it
            
            NSTimer.scheduledTimerWithTimeInterval(durationOnScreen, target: self, selector: #selector(dismissConfimationPopup), userInfo: nil, repeats: false)
            
            //  #### Animate the Views In
            UIView.animateWithDuration( 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                
                if isAboveTabBar == true {
                    
                    self.gradientBackground.frame = CGRect(x: 0, y: 64 , width: window.frame.width, height: 60)
                    
                } else {
                    
                    self.gradientBackground.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 60)
                }
                
                
                }, completion: nil)
            
        }
    }
    
    //  Dismiss Views
    func dismissConfimationPopup() {
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 10.0, initialSpringVelocity: 1, options: .CurveLinear, animations: { 
            if let window = UIApplication.sharedApplication().keyWindow {
                
                self.gradientBackground.frame = CGRect(x: 0, y: -60, width: window.frame.width, height: 60)
                
            }
            }) { (comp) in
                
        }

        
    }
    
    //  Gradient Layer Setup
    func backgroundGradientLayer(view: UIView, overLayView: UIView) {
        
        let gradient = CAGradientLayer()
        gradient.frame = overLayView.frame
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        let colors : [CGColor] = [UIColor(white: 1, alpha: 0.0).CGColor, UIColor(white: 1, alpha: 0.95).CGColor, UIColor(white: 1, alpha: 1.0).CGColor]
        let location = [0.0, 0.05, 1.0]
        gradient.colors = colors
        gradient.opaque = true
        gradient.locations = location
        view.layer.addSublayer(gradient)
        
    }
}
