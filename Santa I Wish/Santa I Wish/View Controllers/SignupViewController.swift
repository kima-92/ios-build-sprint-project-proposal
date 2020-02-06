//
//  SignupViewController.swift
//  Santa I Wish
//
//  Created by macbook on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var santaIWishController = SantaIWishController()
    var childParent: Parent?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        registerNewAccount()
    }
    
    func registerNewAccount() {
        
        // Validate the fields, or save error mesage to display
        let error = validateFields()
        
        if error != nil {
            showErrorAlert(errorMessage: error!)
        } else {
            
            // Clean version of data entry
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            // Creating new Account
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                self.santaIWishController.getCredentials()
                if let err = err {
                    self.showErrorAlert(errorMessage: "Error creating Account: \(err.localizedDescription)")
                    NSLog("Error creating family account to PUT in Firebase: \(err)")
                } else {
                    let db = Firestore.firestore()
                    db.collection("ParentAccount").addDocument(data: ["name": name, "id": result!.user.uid]) { (error) in
                        let parent = self.santaIWishController.createParentProfile(with: name, email: email)
                    self.childParent = parent
                        if let error = error {
                            //family was created but couldn't save the response we get back
                            self.showErrorAlert(errorMessage: "Error creating Account")
                            NSLog("Account was created in Firebase, but got bad response: \(error)")
                        }
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController else { return }
                    profileVC.childParent = self.childParent
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }
    
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> String? {
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // TODO: Comment back in for production
        
        //        // Check if the password is secure enough
        //        if isPasswordValid(cleanedPassword) == false {
        //
        //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        //        }
        return nil
    }

    func isPasswordValid(_ password: String) -> Bool {
        // 1 - Password length is 8.
        // 2 - One Alphabet in Password.
        // 3 - One Special Character in Password.
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func updateViews() {
        passwordTextField.isSecureTextEntry = true
        navigationController?.navigationBar.isHidden = true 
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backbutton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
