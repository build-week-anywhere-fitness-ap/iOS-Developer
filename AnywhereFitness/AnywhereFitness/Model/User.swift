//
//  User.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    var firstName: String?
    var lastName: String?
    let username: String?
    var password: String?
    let client: Int?
    let instructor: Int?
    let token: String?
}

