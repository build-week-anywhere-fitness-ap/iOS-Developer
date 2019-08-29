//
//  ForgotPasswordViewController.swift
//  AnywhereFitness
//
//  Created by William Chen on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var trainerForgotEmailTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        if trainerForgotEmailTextfield.text != nil {
            showTFPAlert()
        } else { return }
    }
    
        private func showTFPAlert() {
            let alert = UIAlertController(title: "Password reset sent", message: "We have sent a password reset code to the email provided.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
