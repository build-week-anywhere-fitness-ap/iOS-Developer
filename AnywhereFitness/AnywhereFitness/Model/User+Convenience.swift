////
////  User+Convenience.swift
////  AnywhereFitness
////
////  Created by Bradley Yin on 8/28/19.
////  Copyright © 2019 bradleyyin. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//extension User {
//    @discardableResult convenience init(id: Int64, firstName: String, lastName: String, username: String, password: String, client: Int64, instructor: Int64, token: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(context: context)
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.username = username
//        self.password = password
//        self.client = client
//        self.instructor = instructor
//    }
//    
//    @discardableResult convenience init?(userRepresentation: UserRepresentation, username: String, password: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        guard let id = userRepresentation.id, let firstName = userRepresentation.firstName, let lastName = userRepresentation.lastName, let client = userRepresentation.client, let instructor = userRepresentation.instructor, let token = userRepresentation.token else { return nil }
//        self.init(id: id, firstName: firstName, lastName: lastName, username: username, password: password, client: client, instructor: instructor, token: token, context: context)
//    }
//    
//    var userRepresentation: UserRepresentation {
//        return UserRepresentation(id: id, firstName: firstName, lastName: lastName, username: username, password: password, client: client, instructor: instructor, token: token)
//    }
//}
