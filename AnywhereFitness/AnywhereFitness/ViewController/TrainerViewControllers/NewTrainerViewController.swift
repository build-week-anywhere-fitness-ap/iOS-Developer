//
//  NewTrainerViewController.swift
//  AnywhereFitness
//
//  Created by William Chen on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class NewTrainerViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var clientButtonOutlet: UIButton!
    @IBOutlet weak var trainerButtonOutlet: UIButton!
    
    var courseController = CourseController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        clientButtonOutlet.isSelected = true

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clientButton(_ sender: UIButton) {
        clientButtonOutlet.isSelected = true
        trainerButtonOutlet.isSelected = false
        
    }
    @IBAction func trainerButton(_ sender: Any) {
        trainerButtonOutlet.isSelected = true
        clientButtonOutlet.isSelected = false
        
        
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        createUser()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
    }
    
    func createUser() {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let userName = userNameTextField.text,
            let password = passwordTextField.text,
            
            !firstName.isEmpty,
            !userName.isEmpty,
            !password.isEmpty  else { return }
        
        courseController.currentUser?.firstName = firstName
        courseController.currentUser?.lastName = lastName
        courseController.currentUser?.username = userName
        courseController.currentUser?.password = password
        
        
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
