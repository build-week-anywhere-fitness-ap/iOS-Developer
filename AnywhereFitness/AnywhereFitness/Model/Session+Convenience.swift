//
//  Session+Convenience.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Session {
    @discardableResult convenience init(id: Int64?, classId: Int64, dateTime: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id ?? 0
        self.classId = classId
        self.dateTime = dateTime
    }
    
    //TaskRepresentation -> Task
    @discardableResult convenience init?(sessionRepresentation: SessionRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let classId = sessionRepresentation.classId, let dateTime = sessionRepresentation.dateTime else { return nil}
        self.init(id: sessionRepresentation.id, classId: classId, dateTime: dateTime, context: context)
    }
    
    var sessionRepresentation: SessionRepresentation {
        return SessionRepresentation(id: id, classId: classId, dateTime: dateTime)
    }
    
}
