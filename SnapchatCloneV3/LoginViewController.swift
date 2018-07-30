//
//  LoginViewController.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var pswdfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailfield.delegate = self
        pswdfield.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Checks if user is signed in -- skip login if possible.
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "loginToMain", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didAttemptLogin(_ sender: UIButton) {
        guard let emailText = emailfield.text else { return }
        guard let passwordText = pswdfield.text else { return }
        FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText) { (user, error) in
            
            if error == nil {
                self.performSegue(withIdentifier: "loginToMain", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Login failed. Please try again.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
