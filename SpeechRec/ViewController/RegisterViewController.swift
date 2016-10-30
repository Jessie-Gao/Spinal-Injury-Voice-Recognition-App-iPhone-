//
//  RegisterViewController.swift
//  SpeechRec
//
//  Created by gj on 2016/10/9.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var realNameField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    /**
     register
     
     */
    @IBAction func registerUser(sender: UIButton) {
        if !userNameTextField.text || !realNameField.text || !passwordTextField.text || !password2Field.text {
            return
        }
        if password2Field.text != passwordTextField.text {
            passwordTextField.shakeWith(3)
            password2Field.shakeWith(3)
            return
        }
        view.endEditing(true)
        
        let user = User(source: ["userName": userNameTextField.text!, "realName":realNameField.text!, "password": passwordTextField.text!])
        if user.registerUser() {
            NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
        }
    }

    /**
     cancel
     */
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userNameTextField {
            realNameField.becomeFirstResponder()
        }
        else if textField == realNameField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            password2Field.becomeFirstResponder()
        }
        return true
    }
}
