//
//  LoginViewController.swift
//  AnywhereFitness
//
//  Created by William Chen on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func setUserType(userType: UserType)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    @IBOutlet weak var trainerloginButton: UIButton!
    
    var delegate: LoginDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        trainerloginButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        trainerloginButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        trainerloginButton.layer.cornerRadius = 7
        trainerloginButton.layer.borderWidth = 1
        
        
        
        
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        loginButton.isEnabled = false
        login()
    }
    
    private func login() {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        courseController?.login(username: username, password: password, completion: { (error) in
            if let error = error {
                NSLog("Error login: \(error)")
                DispatchQueue.main.async {
                    self.loginButton.isEnabled = true
                }
                return
            }
            DispatchQueue.main.async {
                if courseController?.currentUser?.client == true {
                    self.delegate?.setUserType(userType: .client)
                    self.dismiss(animated: true, completion: nil)
                } else if courseController?.currentUser?.instructor == true {
                    self.delegate?.setUserType(userType: .instructor)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("cant login")
                    self.loginButton.isEnabled = true
                }
            }
        })
    }

    
    

}
