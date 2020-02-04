//
//  LoginViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        login()
    }
    
    func login() {
        
        // Validate the fields, or save error mesage to display
        let error = validateFields()
        
        if error != nil {
            showErrorAlert(errorMessage: error!)
        } else {
            
            // Clean version of data entry
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                if let err = err {
                    self.showErrorAlert(errorMessage: "Unsuccessful Login: \(err.localizedDescription)")
                    NSLog("Error trying to login: \(err)")
                } else {
                    // TODO: Use the result coming back from the response
                    self.performSegue(withIdentifier: .segueFromLogin, sender: self)
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
        navigationController?.setNavigationBarHidden(true, animated: true)
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
