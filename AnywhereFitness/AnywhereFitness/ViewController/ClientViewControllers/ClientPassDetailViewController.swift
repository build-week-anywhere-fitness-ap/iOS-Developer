//
//  ClientPassDetailViewController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ClientPassDetailViewController: UIViewController {


    @IBOutlet weak var timesRemainingLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    
    var pass: Pass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let completed = pass?.completed, completed {
            timesRemainingLabel.text = "no more pass"
        }
        
        guard let timesUsed = pass?.timesUsed else { return }
        timesRemainingLabel.text = "Remaining times: \(10 - timesUsed)"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func checkinTapped(_ sender: UIButton) {
       
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
