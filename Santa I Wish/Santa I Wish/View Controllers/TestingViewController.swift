////
////  TestingViewController.swift
////  Santa I Wish
////
////  Created by macbook on 2/3/20.
////  Copyright © 2020 Lambda School. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseFirestore
//
//class TestingViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // In Signup VC
//        updateViews()
//        self.hideKeyboardWhenTappedAround()
////        phoneNumTextField.delegate = self
////        zipCodeTextField.delegate = self
//        
//        // In LoginVC
//        self.hideKeyboardWhenTappedAround()
//        
//    }
//    
//    
//    
//    
//    // MARK: This goes in the signup VC
//    
//    func signUpButtonTapped(_ sender: UIButton) {
//        registerNewUser()
//    }
//    
//    func registerNewUser() {
//        
//        // Validate the fields or save error mesage
//        let error = validateFields()
//        
//        if error != nil {
//            
//            // There's something wrong with the fields, show error message
//            showErrorAlert(errorMessage: error!)
//        } else {
//            
//            // Create clean version of data entry
//            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
//                let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//            
//            // MARK: SignUp/Create New Family account
//            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//                
//                if let err = err {
//                    showErrorAlert(errorMessage: "Error creating User")
//                } else {
//                    let db = Firestore.firestore()
//                    
//                    db.collection("users").add
//                }
//                
//            }
//        }
//    }
//    
//    // Validate that the data is correct.
//    // If correct -> return nil. If incorrect -> return error message
//    func validateFields() -> String? {
//        
//        //        // Check that all fields are filled in
//        //        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//        //            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//        //            phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//        //            usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//        //            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//        //
//        //            return "Please fill in all fields."
//        //        }
//        
//        // Check if the password is secure enough
//        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        if isPasswordValid(cleanedPassword) == false {
//            
//            return "Please make sure your password is at least 8 characters, contains a special character and a number."
//        }
//        return nil
//    }
//    
//    func isPasswordValid(_ password: String) -> Bool {
//        // 1 - Password length is 8.
//        // 2 - One Alphabet in Password.
//        // 3 - One Special Character in Password.
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate(with: password)
//    }
//    
//    func showErrorAlert(errorMessage: String) {
//        let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//    // MARK: Update Views
//    func updateViews() {
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//    
//}
////
////// Goes in Signup VC
////extension SignUpViewController: UITextFieldDelegate {
////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////
////        // Mobile validation
////        if textField == phoneNumTextField { // Put here any textfield that should only take number
////
////            let allowedCharacters = CharacterSet(charactersIn: "0123456789")//Here change this characters based on your requirement
////            let characterSet = CharacterSet(charactersIn: string)
////            return allowedCharacters.isSuperset(of: characterSet)
////        }
////
////        if textField == zipCodeTextField { // Put here any textfield that should only take number
////
////            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
////            let characterSet = CharacterSet(charactersIn: string)
////            return allowedCharacters.isSuperset(of: characterSet)
////        }
////        return true
////    }
//
//// MARK: This goes in the login VC
//
//}
