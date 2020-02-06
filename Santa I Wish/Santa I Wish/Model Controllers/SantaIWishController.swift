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
    
    private let baseURL = URL(string: "https://santaiwishbwunit4.firebaseio.com/")!
    
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
        let userID = Auth.auth().currentUser?.uid
        CoreDataStack.shared.saveToPersistentStore()
        putChild(child: child, id: userID) { (error) in
            if let error = error {
                NSLog("error putting childon firebase: \(error)")
            }
        }
        return child
    }
    
    func createLetter(withLetter: String, context: NSManagedObjectContext) {}
    
    // Fetches Child from CD -> Puts Item in Firebase -> Saves Item to CD
    func addItemToWishList(child: Child, item: Item, context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: (Error?) -> Void)  {
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                guard let name = child.name else { return }
                let namesToFetch = [name]
                
                let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name IN %@", namesToFetch)
                
                let children = try context.fetch(fetchRequest)
                let singleChild = children.filter({ $0.name == name })
                let userID = Auth.auth().currentUser?.uid
                
                putItem(child: child, id: userID, item: item) { (error) in
                    
                    if let error = error {
                        NSLog("Error putting Item in WishList: \(error)")
                        return
                    } else {
                        CoreDataStack.shared.save(context: context)
                    }
                }
                completion(nil)
            } catch {
                NSLog("Error adding Item to Child")
                completion(error)
                return
            }
        }
    }
    
    func createParentProfile(with name:String, email:String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)-> Parent {
        let parent = Parent(name: name, email: email, context: context)
        CoreDataStack.shared.saveToPersistentStore()
        print(parent)
        return parent
    }
    
    func testGettingDocuments() {
        
    }
    
    // MARK: Firebase
    
    // Fetch Parent from Firebase
    func fetchParentFromServer(name: String, completion: @escaping (Result<ParentRepresentation?, NetworkingError>) -> Void) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching parents: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from parents fetch data task")
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let parents = try decoder.decode([String: ParentRepresentation].self, from: data).map({ $0.value })
                let parentsFilter = parents.filter({ $0.name == name })
                let parent = parentsFilter[0]
                
                completion(.success(parent))
                return
            } catch {
                NSLog("Error decoding PersonRepresentation: \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
    
    // PUT Parent to Firebase
    func put(parentRepresentation: ParentRepresentation, id: String, completion: @escaping (Result<ParentRepresentation?, NetworkingError>) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent("ParentAccount")
            .appendingPathComponent(id)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(parentRepresentation)
            completion(.success(parentRepresentation))
            print("Sucefully PUT parent in Firebase")
        } catch {
            NSLog("Error encoding parent representation: \(error)")
            completion(.failure(.badEncoding))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting parent: \(error)")
                completion(.failure(.notPutInFB))
                return
            }
        }.resume()
    }
    
    // PUT Child in Firebase
    func putChild(child: Child, id: String?, completion: @escaping (NetworkingError?) -> Void) {
        guard let id = id else { return }
        guard let childRep = child.childRepresentation else { return }
        let requestURL = baseURL
            .appendingPathComponent("ParentAccount")
            .appendingPathComponent(id)
            .appendingPathComponent("children")
            .appendingPathComponent(childRep.name)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(child.childRepresentation)
            print("Sucefully PUT child in Firebase")
        } catch {
            NSLog("Error encoding child representation: \(error)")
            completion(.badEncoding)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting child: \(error)")
                completion(.serverError(error))
                return
            }
        }.resume()
    }
    
    // PUT Item in Firebase
    func putItem(child: Child, id: String?, item: Item, completion: @escaping (NetworkingError?) -> Void) {
        
        guard let id = id,
            let childRep = child.childRepresentation,
            let itemRep = item.itemRepresentation else { return }
        
        let requestURL = baseURL
            .appendingPathComponent("ParentAccount")
            .appendingPathComponent(id)
            .appendingPathComponent("children")
            .appendingPathComponent(childRep.name)
            .appendingPathComponent("Items")
            .appendingPathComponent(itemRep.name)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(item.itemRepresentation)
            print("Sucefully PUT item in Firebase")
        } catch {
            NSLog("Error encoding item representation: \(error)")
            completion(.badEncoding)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting item: \(error)")
                completion(.serverError(error))
                return
            }
        }.resume()
    }
}
