//
//  CreateCourseViewController.swift
//  AnywhereFitness
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class CreateCourseViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveButton.isEnabled = false
        createCourse()
    }
    
    func createCourse() {
        guard let name = nameTextField.text, !name.isEmpty, let type = typeTextField.text, !type.isEmpty, let location = locationTextField.text, !location.isEmpty else {
            DispatchQueue.main.async {
                self.saveButton.isEnabled = true
            }
            return
        }
        courseController?.createCourse(with: name, location: location, type: type)
        navigationController?.popViewController(animated: true)
    }
    
}
