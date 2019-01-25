//
//  NSManagedObject+extension.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 25/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import CoreData

public extension NSManagedObject {
    
    // Fixes issue: https://github.com/drewmccormack/ensembles/issues/275
    convenience init(using context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
