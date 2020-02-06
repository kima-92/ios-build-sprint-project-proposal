//
//  SantaIWishController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData
import FirebaseAuth
import FirebaseFirestore
import UIKit
import Firebase

class SantaIWishController {
    
private var token = "token"
private let db = Firestore.firestore()

    func getCredentials() {
        let user = Auth.auth().currentUser
        user?.getIDToken(completion: { (token, error) in
            if let error = error as NSError? {
                NSLog("error getting token: \(error)")
                return
            }
            UserDefaults.standard.set(token, forKey: self.token)
        })
    }
    
    func signOut() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: token)
    }
    
@discardableResult func addChild(withName name: String, age: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Child {
        let child = Child(name: name, age: String(age), context: context)
        CoreDataStack.shared.saveToPersistentStore()
     let userID = Auth.auth().currentUser?.uid
   
    let childJson: [String: Any] = [
    "age": child.childRepresentation?.age ?? 0,
    "name": child.childRepresentation?.name ?? "",
    "letters": child.childRepresentation?.letters ?? [],
    "items": child.childRepresentation?.items ?? []
    
    ]

        return child
    }
    
func createLetter(withLetter: String, context: NSManagedObjectContext) {}
    
func addItemToWishList(itemName name: String, note: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {}
    
func createParentProfile(with name:String, email:String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)-> Parent {
        let parent = Parent(name: name, email: email, context: context)
        CoreDataStack.shared.saveToPersistentStore()
        print(parent)
    return parent
    }
    
//    private func getDocument() -> String {
//        var documentID: String  = ""
//        let ref =  db.collection("ParentAccount")
//      
//    }
}
