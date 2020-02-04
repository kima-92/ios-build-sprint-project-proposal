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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
                
                if let err = err {
                    self.showErrorAlert(errorMessage: "Error creating Account: \(err.localizedDescription)")
                    NSLog("Error creating family account to PUT in Firebase: \(err)")
                } else {
                    let db = Firestore.firestore()
                    db.collection("ParentAccount").addDocument(data: ["name": name, "id": result!.user.uid]) { (error) in
                        
                        if let error = error {
                            //family was created but couldn't save the response we get back
                            self.showErrorAlert(errorMessage: "Error creating Account")
                            NSLog("Accound was created in Firebase, but got bad response: \(error)")
                        }
                    }
                    // TODO: Transition to next VC
                    self.performSegue(withIdentifier: .addNewChildSegue, sender: self)
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.hideKeyboardWhenTappedAround()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
