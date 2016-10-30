
//  Created by gj on 16/7/15.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import Foundation

public class User {

    
    var userName: String
    var password : String
    var realName : String
    
    var infoDict :[String: String] {
        get {
            return  ["userName": userName, "password": password, "realName": realName]
        }
    }
    
    public init(source: Dictionary<String,AnyObject>) {
        
        self.userName = source["userName"] as! String
        self.password = source["password"] as! String
        self.realName = source["realName"] as! String
        
    }


    
    //private var userInfo: Dictionary<String, AnyObject>? = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as? Dictionary
    
    // register
    func registerUser() -> Bool {
        
        if var defusers =  NSUserDefaults.standardUserDefaults().objectForKey("users") as? Array<Dictionary<String, String>> {
            for info in defusers {
                if info["userName"] == self.userName {
                    return false
                }
            }
            defusers.append(self.infoDict)
            NSUserDefaults.standardUserDefaults().setObject(defusers, forKey: "users")
            
            bindUser()
            return true
        }
        return false
    }
    
    func bindUser() {
        NSUserDefaults.standardUserDefaults().setObject(self.infoDict, forKey: "userInfo")
        
    }
    
    
    // login or not
    public static var isLogined: Bool {
        get {
            if let _ = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as? [String: String]  {
                return true
            }
            return false
        }
    }
    
}


extension User {
    // add default user
    class func addDefaultUser() {
        
        let users = [["userName":"aaa", "realName":"Joy", "password":"111111"]]
        if let defusers =  NSUserDefaults.standardUserDefaults().objectForKey("users") {
            print(defusers)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(users, forKey: "users")
        }
    }

    // check the account and password
    class func CheckUser(userName: String, password: String) -> User? {
        if let defusers =  NSUserDefaults.standardUserDefaults().objectForKey("users") as? Array<Dictionary<String, String>>  {
            for info in defusers {
                if info["userName"] == userName && info["password"] == password {
                    let user = User(source: info)
                    user.bindUser()
                    return user
                }
            }
        }
        return nil
    }
    
    class func loginOut() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userInfo")
        
    }
    
    class var loginUserName: String {
        get {
            if let info = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as? [String: String]  {
                return info["userName"]!
            }
            return ""
        }

    }
    class var loginRealName: String {
        get {
            if let info = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as? [String: String]  {
                return info["realName"]!
            }
            return ""
        }
        
    }
}


