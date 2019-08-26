//
//  Course.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
struct Course: Codable {
    let courseName: String
    let courseCategories: String
    let trainerName: String
    let location: String
    let time: Date
}
