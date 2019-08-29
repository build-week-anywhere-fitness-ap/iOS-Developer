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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = course?.name {
            courseLabel.text = "Session for \(name)"
        }
    }
    @IBAction func save(_ sender: UIButton) {
        if let session = session {
            //update
        } else {
            //create new
            guard let course = course else { return }
            courseController?.createSession(with: course.id, dateTime: datePicker.date)
            navigationController?.popViewController(animated: true)
        }
    }
    

}
