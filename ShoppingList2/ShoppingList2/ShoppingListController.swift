//
//  ShoppingListController.swift
//  ShoppingList2
//
//  Created by Kevin Hartley on 5/27/16.
//  Copyright © 2016 BigNerdRanch. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    static let sharedInstance = ShoppingListController()
    
    var fetchedResultsController: NSFetchedResultsController
    
    //CRUD
    
    init() {
        let request = NSFetchRequest(entityName: "ShoppingList")
        let sortDescriptor = NSSortDescriptor(key: "completed", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        _ = try? fetchedResultsController.performFetch()
    }
    
    
    func addItem(title: String) {
        _ = ShoppingList(title: title)
        saveToPersistentStore()
    }
    
    func removeItem(shoppingList: ShoppingList) {
        let doc = Stack.sharedStack.managedObjectContext
        doc.deleteObject(shoppingList)
        saveToPersistentStore()
    }
    
    func updateItem(shoppingList: ShoppingList) {
        
    }
    
    func saveToPersistentStore() {
        let moc = Stack.sharedStack.managedObjectContext
        do {
            try moc.save()
        } catch {
            print("Error saving to persistent store")
        }
    }
}