//
//  User.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/26/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
struct User: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let password: String
    let client: Bool
    let trainer: Bool
}
