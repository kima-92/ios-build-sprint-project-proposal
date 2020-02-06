//
//  ChildProfileDetailViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ChildProfileDetailViewController: UIViewController {

    // MARK: - Properties
    var santaIWishController: SantaIWishController?
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var ageTextfield: UILabel!
    @IBOutlet weak var lettersView: UIView!
    @IBOutlet weak var wishListView: UIView!
    @IBOutlet weak var wishListLabel: UILabel!
    @IBOutlet weak var lettersToSantaLabel: UILabel!
    var child: Child? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
        updateViews()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  private func updateViews() {
    
    guard isViewLoaded else { return }
    guard let child = child,
        let age = child.age else { return }
    
    nameTextField.text = child.name
    ageTextfield.text = "Age: \(age)"
    wishListLabel.text = "wishList items: \(child.items?.count ?? 0)"
    lettersToSantaLabel.text = "letters to santa: \(child.letters?.count ?? 0)"
    
    hideKeyboardWhenTappedAround()
    }
    
    private func styleViews() {
        wishListView.layer.cornerRadius = 20
        lettersView.layer.cornerRadius = 20
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowWishListSegue" {
            
            if let wishListTableVC = segue.destination as? WishlistsTableViewController {
                wishListTableVC.santaIWishController = self.santaIWishController
                wishListTableVC.child = self.child
            }
        }
    }
}
