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
        saveButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        saveButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        saveButton.layer.cornerRadius = 7
        saveButton.layer.borderWidth = 1
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
