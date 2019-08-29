//
//  PassRepresentation.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
struct PassRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case classId = "class_id"
        case clientId = "client_id"
        case completed
        case timesUsed
    }
    var id: Int64?
    var classId: Int64?
    var clientId: Int64?
    var completed: Bool?
    var timesUsed: Int64?
}
