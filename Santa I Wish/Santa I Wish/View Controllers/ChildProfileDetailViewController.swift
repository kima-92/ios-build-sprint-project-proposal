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
        updateViews()
        styleViews()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  private func updateViews() {
    guard isViewLoaded else { return }
    guard let child = child else { return }
    nameTextField.text = child.name
    ageTextfield.text = child.age
    wishListLabel.text = "wishList items: \(child.items?.count ?? 0)"
    lettersToSantaLabel.text = "letters to santa: \(child.letters?.count ?? 0)"
    }
    
    private func styleViews() {
        wishListView.layer.cornerRadius = 20
        lettersView.layer.cornerRadius = 20
    }
}
