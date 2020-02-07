//
//  ProfileViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    var santaIWIshController = SantaIWishController()
    var childParent: Parent?
    var fetchResultsController: NSFetchedResultsController<Child> {
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
    
    // MARK: - View lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        do {
            
            let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
            let children = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            //        let predicate = NSPredicate(format: "%K == %@", "name", "\(String(describing: child?.name))")
            //        fetchRequest.predicate = predicate
            
//            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            print("Children: \(children)")
            let child = children.first
            print(child?.name)
            print("Child items count: \(child?.items?.count)")
            let fetchRequest2: NSFetchRequest<Item> = Item.fetchRequest()
            let items = try CoreDataStack.shared.mainContext.fetch(fetchRequest2)
            print("items count: \(items.count)")
            
            let item = items.first
            print("Item name: \(item?.name)")
            
            print("Item's child: \(item?.child)")
        } catch {
            print("Fetching chldren failed: \(error)")
        }
        

    }
    
    let childrenNames = ["kora"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCollectionView.reloadData()
    }

    @IBOutlet var profileCollectionView: UICollectionView!
    
    private func configureViews() {
        navigationController?.navigationBar.isHidden = true
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateChildProfile" {
            guard let childProfileVC = segue.destination as? AddChildViewController else { return }
            childProfileVC.santaIWishController = santaIWIshController
        } else if segue.identifier == "ProfileDetailSegue" {
            guard let childProfileVC = segue.destination as? ChildProfileDetailViewController else { return }
            
            if let sender = sender as? ProfileCollectionViewCell {
               guard let indexpPath = profileCollectionView.indexPath(for: sender) else { return }
               childProfileVC.child = fetchResultsController.object(at: indexpPath)
            }
            childProfileVC.santaIWishController = santaIWIshController
        }
    }
}

extension ProfileViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell()}
        let child = fetchResultsController.object(at: indexPath)
        cell.child = child
        return cell
    }
    
}
