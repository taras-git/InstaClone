//
//  ViewController.swift
//  InstagramClone
//
//  Created by user on 3/3/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signupModeActive = true

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    fileprivate func signUpUser(username : String, password : String) {
        let user = PFUser()
        user.username = username
        user.password = password

        user.signUpInBackground(block: { (isSuccess, error) in
            if let error = error {
                self.displayAlert(title: "Error in form", message: error.localizedDescription)
                print(error.localizedDescription)
            } else {
                print("User signed up")
                self.performSegue(withIdentifier: "showUserTable", sender: self)
            }
        })
    }

    @IBAction func signupOrLogin(_ sender: UIButton) {
        if userName.text == "" || password.text == "" {
            displayAlert(title: "Error in form", message: "Please enter username and password")
        } else if let username = userName.text {
            if let password = password.text {
                if (signupModeActive) {
                    signUpUser(username: username, password: password)
                } else {
                    PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                        if user != nil {
                            print("login success")
                            self.performSegue(withIdentifier: "showUserTable", sender: self)
                        } else {
                            self.displayAlert(title: "Could not login", message: error!.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    @IBAction func swithcLoginMode(_ sender: UIButton) {
        if (signupModeActive) {
            signupModeActive = false
            signupButton.setTitle("Log in", for: [])
            loginButton.setTitle("Sign up", for: [])
        } else {
            signupModeActive = true
            signupButton.setTitle("Sign up", for: [])
            loginButton.setTitle("Log in", for: [])
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    func displayAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }


    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        navigationController?.navigationBar.isHidden = true
    }

}

