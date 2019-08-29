//
//  TrainerSessionDetailViewController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class TrainerSessionDetailViewController: UIViewController {
    
    var session: Session?
    var course: Course?
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        saveButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        saveButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        saveButton.layer.cornerRadius = 7
        saveButton.layer.borderWidth = 1
        
        if let name = course?.name {
            courseLabel.text = "Session for \(name)"
        }
    }
    @IBAction func save(_ sender: UIButton) {
        if let session = session {
            //update
            courseController?.updateSession(session: session, dateTime: datePicker.date)
            navigationController?.popViewController(animated: true)
        } else {
            //create new
            guard let course = course else { return }
            courseController?.createSession(with: course.id, dateTime: datePicker.date)
            navigationController?.popViewController(animated: true)
        }
    }
    

}
