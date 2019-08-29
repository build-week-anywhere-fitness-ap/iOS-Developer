//
//  NewTrainerViewController.swift
//  AnywhereFitness
//
//  Created by William Chen on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var clientButtonOutlet: UIButton!
    @IBOutlet weak var trainerButtonOutlet: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var client = true
    var trainer = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        clientButtonOutlet.isSelected = true
        signupButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        signupButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        signupButton.layer.cornerRadius = 7
        signupButton.layer.borderWidth = 1
        
        cancelButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cancelButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        cancelButton.layer.cornerRadius = 7
        cancelButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clientButton(_ sender: UIButton) {
        clientButtonOutlet.isSelected = true
        trainerButtonOutlet.isSelected = false
        client = true
        trainer = false
        
    }
    @IBAction func trainerButton(_ sender: Any) {
        trainerButtonOutlet.isSelected = true
        clientButtonOutlet.isSelected = false
        trainer = true
        client = false
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        signupButton.isEnabled = false
        createUser()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createUser() {
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let userName = userNameTextField.text,
            let password = passwordTextField.text,

            
            !firstName.isEmpty,
            !userName.isEmpty,
            !password.isEmpty  else {
                signupButton.isEnabled = true
                return
                
        }

        courseController?.signUp(firstName: firstName, lastName: lastName, username: userName, password: password, client: client, instructor: trainer) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Error signing up: \(error)")
                    self.signupButton.isEnabled = true
                    return
                }
                print("sign up complete")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
