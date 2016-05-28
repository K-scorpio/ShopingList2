//
//  ShoppingListTableViewController.swift
//  ShoppingList2
//
//  Created by Kevin Hartley on 5/27/16.
//  Copyright © 2016 BigNerdRanch. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        ShoppingListController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        presentAlertController()
    }
    
    func presentAlertController() {
        var itemTextField: UITextField?
        let alertController = UIAlertController(title: "Add New Item", message: "What grocery item do you need?", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Grocery item"
            itemTextField = textField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let createAction = UIAlertAction(title: "Add", style: .Default) {(_) in
        guard let title = itemTextField?.text where title.characters.count > 0 else {
            return
        }
        ShoppingListController.sharedInstance.addItem(title)
    }
    alertController.addAction(cancelAction)
    alertController.addAction(createAction)
    presentViewController(alertController, animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = ShoppingListController.sharedInstance.fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = ShoppingListController.sharedInstance.fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("shoppingListCell", forIndexPath: indexPath) as? ButtonTableViewCell,
        shoppingList = ShoppingListController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? ShoppingList else {
            return ButtonTableViewCell()
        }
        // Configure the cell...
        cell.updateWithShoppingList(shoppingList)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = ShoppingListController.sharedInstance.fetchedResultsController.sections else {return nil}
        let value = Int(sections[section].name)
        if value == 0 {
            return "Not picked up"
        } else {
            return "Picked up"
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let index = ShoppingListController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? ShoppingList else {
                return
            }
            ShoppingListController.sharedInstance.removeItem(index)
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ShoppingListTableViewController: ShoppingListTableViewCellDelegate {
    func buttonCellButtonTapped(cell: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell),
        let shoppingList = ShoppingListController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? ShoppingList else {return}
        shoppingList.completed = !shoppingList.completed!.boolValue
        cell.shoppingListValueChanged(shoppingList.completed!.boolValue)
        ShoppingListController.sharedInstance.saveToPersistentStore()
    } 
}

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case.Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Move:
            guard let indexPath = indexPath, newIndexPath = newIndexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
