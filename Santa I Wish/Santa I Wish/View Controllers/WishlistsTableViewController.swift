//
//  WishlistsTableViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class WishlistsTableViewController: UITableViewController {

    // MARK: - properties
    var santaIWishController: SantaIWishController?
    var childParent: Parent?
    var child: Child?
    var items: [ItemRepresentation]?
    
//    var fetchResultsController: NSFetchedResultsController<Child> {
//
//        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
//
//        let predicate = NSPredicate(format: "%K == %@", "name", "\(String(describing: child?.name))")
//        fetchRequest.predicate = predicate
//
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        let moc = CoreDataStack.shared.mainContext
//        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
//        fetchResultsController.delegate = self
//
//        do {
//            try fetchResultsController.performFetch()
//        } catch {
//            fatalError("Failed to fetch entities: \(error)")
//        }
//        return fetchResultsController
//    }
    
    var fetchResultsController: NSFetchedResultsController<Item> {

//        if let child = child {

            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

            let predicate = NSPredicate(format: "%K == %@", "child.name", "Raelyn")


//            let predicate = NSPredicate(format: "child == %@", child)
            fetchRequest.predicate = predicate

            //        let predicate = NSPredicate(format: "ANY child.name == %@", "\(String(describing: child?.name))")
            //        fetchRequest.predicate = predicate

            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            let moc = CoreDataStack.shared.mainContext
            let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self

            do {
                try fetchResultsController.performFetch()
            } catch {
                fatalError("Failed to fetch entities: \(error)")
            }
//        }
        return fetchResultsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getItems()
    }
    
    func getItems() {
        
        guard let child = child else { return }
        
        santaIWishController?.fetchItemsFromServer(child: child, completion: { (result) in
            
            do {
                let results = try result.get()
                self.items = results
            } catch {
                NSLog("Couldn't fetch Items for WishList ")
            }
        })
    }
 
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
//        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToyCell", for: indexPath)
        let item = fetchResultsController.object(at: indexPath)
        
//        let item = items?[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
           guard let addItemVC = segue.destination as? AddItemViewController else { return }
            addItemVC.santaIWishController = santaIWishController
            addItemVC.child = child
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension WishlistsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.beginUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let indexPath = indexPath else { return }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        }
    
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
}
