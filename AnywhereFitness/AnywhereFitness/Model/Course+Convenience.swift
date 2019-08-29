//
//  Course+Convenience.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/28/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Course {
    @discardableResult convenience init(name: String, type: String?, location: String, instructorId: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.name = name
        self.instructorId = instructorId
        self.type = type
        self.location = location
    }
    
    //TaskRepresentation -> Task
    @discardableResult convenience init?(courseRepresentation: CourseRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let name = courseRepresentation.name, let location = courseRepresentation.location, let instructorId = courseRepresentation.instructorId else { return nil}
        self.init(name: name, type: courseRepresentation.type, location: location, instructorId: instructorId, context: context)
    }
    
    var courseRepresentation: CourseRepresentation {
        return CourseRepresentation(id: id, name: name, location: location, type: type, instructorId: instructorId)
    }
    
}
