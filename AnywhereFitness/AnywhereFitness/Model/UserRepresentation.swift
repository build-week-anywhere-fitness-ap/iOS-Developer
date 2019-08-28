//
//  User.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    let id: Int64?
    let firstName: String?
    let lastName: String?
    let username: String?
    let password: String?
    let client: Int64?
    let instructor: Int64?
    let token: String?
}
