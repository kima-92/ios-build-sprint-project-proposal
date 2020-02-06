//
//  AddItemViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var toyName: UITextField!
    @IBOutlet weak var toyImage: UIImageView!
    @IBOutlet weak var toyDescription: UITextView!
    var santiIWishCOntroller: SantaIWishController?
    var kid: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true
        )
    }
    
    @IBAction func saveButton(_ sender: Any) {

    }
}
