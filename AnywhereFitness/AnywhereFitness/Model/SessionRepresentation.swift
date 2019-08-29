//
//  SessionRepresentation.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct SessionRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case dateTime
        case classId = "class_id"
        case id
    }
    var id: Int64?
    var classId: Int64?
    var dateTime: Date?
}
