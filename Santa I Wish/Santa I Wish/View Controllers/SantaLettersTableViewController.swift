//
//  SantaLettersTableViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class SantaLettersTableViewController: UITableViewController {
    
    var santaIWishController: SantaIWishController?
    var child: Child?
    
    var fetchResultsController: NSFetchedResultsController<Letter> {

            let fetchRequest: NSFetchRequest<Letter> = Letter.fetchRequest()

        let predicate = NSPredicate(format: "%K == %@", "child.name", getChildName())

            fetchRequest.predicate = predicate

            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            let moc = CoreDataStack.shared.mainContext
            let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self

            do {
                try fetchResultsController.performFetch()
            } catch {
                fatalError("Failed to fetch entities: \(error)")
            }
        return fetchResultsController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func getChildName() -> String {
        guard let child = child,
            let name = child.name else { return ""}
        
        return name
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "LetterCell", for: indexPath)
        let letter = fetchResultsController.object(at: indexPath)

        cell.textLabel?.text = letter.title
        return cell
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddLetterSegue" {
           guard let sendLetterVC = segue.destination as? SendSantaLetterViewController else { return }
            sendLetterVC.santaIWishController = santaIWishController
            sendLetterVC.child = child
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SantaLettersTableViewController: NSFetchedResultsControllerDelegate {
    
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
