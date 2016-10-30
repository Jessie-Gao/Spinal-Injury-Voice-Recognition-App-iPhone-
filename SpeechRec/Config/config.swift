//  Created by gj on 16/10/09.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import Foundation
import UIKit


    
let JPushProduction = true

/*jpush*/
let jpushAppKey = "524c917e66dbf909526054cd"


let userDidLoginNotification = "UserDidLoginNotification"
let userDidLogOutNotification = "userDidLogOutNotification"

let RefreshDataNotification = "RefreshDataNotification"


let yijiOrange = UIColor(red:0.93, green:0.51, blue:0.22, alpha:1.00)
let yijiBlue = UIColor(red:0.13, green:0.32, blue:0.62, alpha:1.00)
let yijiBackColor = UIColor(hex: 0x22A1E7)



/// cancel missoin Block
public typealias CancelableTask = (cancel: Bool) -> Void

/**
 delay issue
 
 - parameter time: delay time
 - parameter work: execute
 
 - returns: cancel
 */
public func delay(time: NSTimeInterval, work: dispatch_block_t) -> CancelableTask? {
    
    var finalTask: CancelableTask?
    
    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key
        } else {
            dispatch_async(dispatch_get_main_queue(), work)
        }
    }
    
    finalTask = cancelableTask
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        if let task = finalTask {
            task(cancel: false)
        }
    }
    
    return finalTask
}

/**
 cancel execute
 
 - parameter cancelableTask: cancel mission
 */
public func cancel(cancelableTask: CancelableTask?) {
    cancelableTask?(cancel: true)
}
