//
//  SelectionViewController.swift
//  AnywhereFitness
//
//  Created by William Chen on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//Users/williamchen/Desktop/iOS-Developer/AnywhereFitness/AnywhereFitness/ViewController/

import UIKit



class SelectionViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        courseController = CourseController()

    }
    
    @IBAction func clientButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func trainerButtonTapped(_ sender: UIButton) {
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
