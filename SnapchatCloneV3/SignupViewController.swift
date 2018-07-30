//
//  SignupViewController.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var pswdfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        namefield.delegate = self
        emailfield.delegate = self
        pswdfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didAttemptSignup(_ sender: UIButton) {
        guard let email = emailfield.text else { return }
        guard let password = pswdfield.text else { return }
        guard let name = namefield.text else { return }
        if email == "" {
            let alertController = UIAlertController(title: "Error", message: "Enter your email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error == nil, let user = user {
                    user.profileChangeRequest().displayName = name
                    self.performSegue(withIdentifier: "signupToMain", sender: nil)
                } else {
                    // if error occurs with signup
                    let alertController = UIAlertController(title: "Error", message: "An error occurred with signing up. Please try again.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
