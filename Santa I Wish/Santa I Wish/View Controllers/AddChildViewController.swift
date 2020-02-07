//
//  AddChildViewController.swift
//  Santa I Wish
//
//  Created by macbook on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class AddChildViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    var santaIWishController: SantaIWishController?
    var childParent: Parent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
//        guard let name = nameTextfield.text, !name.isEmpty, let ageString = ageTextfield.text, !ageString.isEmpty, let age = Int(ageString), let parent = childParent else { return }
        //        santaIWishController?.addChild(withName: name, parent: parent, age: age)
        
                guard let name = nameTextfield.text, !name.isEmpty, let ageString = ageTextfield.text, !ageString.isEmpty, let age = Int(ageString) else { return }
        santaIWishController?.addChild(withName: name, age: age)

        navigationController?.popViewController(animated: true)
    }
    
}
