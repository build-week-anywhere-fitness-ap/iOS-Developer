//
//  CourseRepresentation.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/28/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct CourseRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case location
        case instructorId = "instructor_id"
        case type
        case id
    }
    var id: Int64?
    var name: String?
    var location: String?
    var type: String?
    var instructorId: Int64?
}
