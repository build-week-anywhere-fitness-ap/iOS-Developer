//
//  ClientForgotPasswordViewController.swift
//  AnywhereFitness
//
//  Created by William Chen on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ClientForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var clientForgotEmailTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clientFogotPasswordSubmit(_ sender: UIButton) {
        if clientForgotEmailTextfield.text != nil {
            showCFPAlert()
        } else { return }
    }
    
    private func showCFPAlert() {
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
