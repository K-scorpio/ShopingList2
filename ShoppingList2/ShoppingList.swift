//
//  ShoppingList.swift
//  ShoppingList2
//
//  Created by Kevin Hartley on 5/27/16.
//  Copyright © 2016 BigNerdRanch. All rights reserved.
//

import Foundation
import CoreData


class ShoppingList: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    convenience init?(title: String, completed: Bool = false, insertIntoManagedObjectContext context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName("ShoppingList", inManagedObjectContext: context) else {
            return nil
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.title = title
        self.completed = completed
    }

}
