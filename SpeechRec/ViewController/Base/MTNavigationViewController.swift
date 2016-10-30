
//
//  MTNavigationController.swift
//

import UIKit

class MTNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationBar.translucent = false   // not transparent
        self.navigationBar.backgroundColor = nil
        navigationBar.shadowImage = nil
        navigationBar.barStyle = .Default
        navigationBar.setBackgroundImage(UIImage.imageWithColor(yijiBlue), forBarMetrics: .Default)
        
        let textAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18)
        ]
        
        navigationBar.titleTextAttributes = textAttributes
//        navigationBar.tintColor = nil
    
        
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.delegate = self
            delegate = self
        }
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToViewController(viewController, animated: false)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.enabled = true
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }
}

public extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

