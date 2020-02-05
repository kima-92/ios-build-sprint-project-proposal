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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
    }
    
}
