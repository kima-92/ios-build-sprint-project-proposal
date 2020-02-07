//
//  SendSantaLetterViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class SendSantaLetterViewController: UIViewController {

    var santaIWishController: SantaIWishController?
    var child: Child?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var letter: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    func updateViews() {
        
        guard let child = child,
            let name = child.name else { return }
        
        print("Child name: \(name)")
        letter.text = ""
        self.hideKeyboardWhenTappedAround()
    }
}
