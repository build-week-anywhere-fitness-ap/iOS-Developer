//
//  InitialViewController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/28/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

var courseController: CourseController?

enum UserType {
    case client
    case instructor
}

class InitialViewController: UIViewController {
    var userType: UserType?

    override func viewDidLoad() {
        super.viewDidLoad()
        courseController = CourseController()
        
        //for locate local file
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(dir)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        if let userType = userType {
            if userType == .instructor {
                performSegue(withIdentifier: "TrainerShowSegue", sender: self)
            } else {
                performSegue(withIdentifier: "ClientShowSegue", sender: self)
            }
        } else {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            guard let loginVC = segue.destination as? LoginViewController else {fatalError("Error casting loginVC")}
            loginVC.delegate = self
        }
    }

}

extension InitialViewController: LoginDelegate {
    func setUserType(userType: UserType) {
        self.userType = userType
    }
    
    
}
