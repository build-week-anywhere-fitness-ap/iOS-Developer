//
//  ClientClassDetailViewController.swift
//  AnywhereFitness
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ClientClassDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var getPassButton: UIButton!
    
    var course: Course?
    var session: Session?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        getPassButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        getPassButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        getPassButton.layer.cornerRadius = 7
        getPassButton.layer.borderWidth = 1
        guard let course = course, let session = session else { return }
        nameLabel.text = course.name
        typeLabel.text = course.type
        locationLabel.text = course.location
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeLabel.text = dateformatter.string(from: session.dateTime!)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getPassTapped(_ sender: UIButton) {
        guard let courseId = course?.id else { return }
        courseController?.createPass(with: courseId)
    }
}
