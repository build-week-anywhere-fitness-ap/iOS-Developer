//
//  Pass+Convenience.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Pass {
    @discardableResult convenience init(id: Int64?, classId: Int64, clientId: Int64, completed: Bool, timesUsed: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id ?? 0
        self.classId = classId
        self.clientId = clientId
        self.completed = completed
        self.timesUsed = timesUsed
    }
    
    //TaskRepresentation -> Task
    @discardableResult convenience init?(passRepresentation: PassRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let clientId = passRepresentation.clientId, let classId = passRepresentation.classId, let completed = passRepresentation.completed, let timesUsed = passRepresentation.timesUsed else { return nil}
        self.init(id: passRepresentation.id, classId: classId, clientId: clientId, completed: completed, timesUsed: timesUsed, context: context)
    }
    
    var passRepresentation: PassRepresentation {
        return PassRepresentation(id: id, classId: classId, clientId: clientId, completed: completed, timesUsed: timesUsed)
    }
    
}

