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
