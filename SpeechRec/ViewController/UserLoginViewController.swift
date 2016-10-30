//
//  UserLoginViewController.swift

//  Created by gj on 16/10/09.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit


class UserLoginViewController: BaseViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    /**
     login
     */
    @IBAction func login() {
        if !userNameTextField.text || !passwordTextField.text {
            return
        }
        view.endEditing(true)
        
        if let _ = User.CheckUser(userNameTextField.text!, password: passwordTextField.text!) {
        
            NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
        } else {
            showTips("Incorrect username or password!")
        }
    }
    
    /**
     register
     
     - parameter sender:
     */
    @IBAction func register(sender: UIButton) {
        let registerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterViewController")
        self.presentViewController(registerViewController, animated: true, completion: nil)
    }
}



extension UserLoginViewController: UITextFieldDelegate {
    /**
     return
     
     - parameter textField:
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            login()
            view.endEditing(true)
        }
        return true
    }
}
