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

 @objc class SantaIWishController: NSObject {
    
    private let baseURL = URL(string: "https://santaiwishbwunit4.firebaseio.com/")!
    
    private var token = "token"
    private let db = Firestore.firestore()
    private var userID: String?
    
    func getCredentials() {
        let user = Auth.auth().currentUser
        user?.getIDToken(completion: { (token, error) in
            if let error = error as NSError? {
                NSLog("error getting token: \(error)")
                return
            }
            UserDefaults.standard.set(token, forKey: self.token)
            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userID")
            self.userID = Auth.auth().currentUser?.uid
        })
    }
    
    func signOut() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: token)
    }
    
    @objc @discardableResult func addChild(withName name: String, age: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Child {
        
        let child = Child(name: name, age: String(age), context: context)
        userID = Auth.auth().currentUser?.uid
//        parent.addToChildren(child)
        
        CoreDataStack.shared.saveToPersistentStore()
        putChild(child: child, id: userID) { (error) in
            if let error = error {
                NSLog("error putting child to firebase: \(error)")
            }
        }
        return child
    }
    
    func createLetter(withLetter: String, context: NSManagedObjectContext) {}
    
    // Fetches Child from CD -> Puts Item in Firebase -> Saves Item to CD
    func addItemToWishList(child: Child, item: Item, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)  {
        userID = Auth.auth().currentUser?.uid
        putItem(child: child, id: userID, item: item) { (error) in
            
            if let error = error {
                NSLog("Error putting Item in WishList: \(error)")
                return
            } else {
                CoreDataStack.shared.save(context: context)
            }
        }
        
    }
    
    // Fetches Child from CD -> Puts Letter in Firebase -> Saves Letter to CD
    func addLetterToChild(child: Child, note: String, title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: (Error?) -> Void)  {
        
        let letter = Letter(note: note, child: child, title: title, context: CoreDataStack.shared.mainContext)
        child.addToLetters(letter)
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                userID = Auth.auth().currentUser?.uid
                putLetter(child: child, id: userID, letter: letter) { (error) in
                    
                    if let error = error {
                        NSLog("Error putting Letter in Child's Letters: \(error)")
                        return
                    } else {
                        CoreDataStack.shared.save(context: context)
                    }
                }
                completion(nil)
            } catch {
                NSLog("Error adding Letter to Child")
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
    
    // MARK: Firebase
    
    // Fetch Parent from Firebase
    //    func fetchParentFromServer(name: String, completion: @escaping (Result<ParentRepresentation?, NetworkingError>) -> Void) {
    //
    //        let requestURL = baseURL.appendingPathExtension("json")
    //
    //        let request = URLRequest(url: requestURL)
    //
    //        URLSession.shared.dataTask(with: request) { (data, _, error) in
    //
    //            if let error = error {
    //                NSLog("Error fetching parents: \(error)")
    //                completion(.failure(.serverError(error)))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                NSLog("No data returned from parents fetch data task")
    //                completion(.failure(.noData))
    //                return
    //            }
    //
    //            let decoder = JSONDecoder()
    //
    //            do {
    //
    //                let parents = try decoder.decode([String: ParentRepresentation].self, from: data).map({ $0.value })
    //                let parentsFilter = parents.filter({ $0.name == name })
    //                let parent = parentsFilter[0]
    //
    //                completion(.success(parent))
    //                return
    //            } catch {
    //                NSLog("Error decoding PersonRepresentation: \(error)")
    //                completion(.failure(.badDecode))
    //                return
    //            }
    //        }.resume()
    //    }
    
    func fetchKidsFromServer(completion: @escaping (NSError?) -> Void) {
        guard  let userID = UserDefaults.standard.object(forKey: "userID")  as? String else { return }
        let requestURL = baseURL.appendingPathComponent("ParentAccount")
            .appendingPathComponent(userID)
            .appendingPathComponent("children")
            .appendingPathExtension("json")
        print(requestURL)
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error as NSError? {
                NSLog("Error fetching parents: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from parents fetch data task")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                //print(String(data: data, encoding: .utf8))
                let kids = try decoder.decode([String: ChildRepresentation].self, from: data).map({ $0.value })
                print(kids)
            } catch let error as NSError {
                NSLog("Error decoding PersonRepresentation: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    // Fetch Item from Firebase
    func fetchItemsFromServer(child: Child, completion: @escaping (Result<[ItemRepresentation]?, NetworkingError>) -> Void) {
        
        userID = Auth.auth().currentUser?.uid
        
        guard let userID = userID,
            let childRep = child.childRepresentation else { return }
        //            let itemRep = item.itemRepresentation else { return }
        
        let requestURL = baseURL
            .appendingPathComponent("ParentAccount")
            .appendingPathComponent(userID)
            .appendingPathComponent("children")
            .appendingPathComponent(childRep.name)
            .appendingPathComponent("Items")
            //            .appendingPathComponent(itemRep.name)
            .appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching items: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from items fetch data task")
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let items = try decoder.decode([String: ItemRepresentation].self, from: data).map({ $0.value })
                //                let itemsFiltered = items.filter({ $0.name == item.name })
                //                let item = itemsFiltered[0]
                
                completion(.success(items))
                return
            } catch {
                NSLog("Error decoding itemsRepresentations: \(error)")
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
        print(requestURL)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(item.itemRepresentation)
        } catch {
            NSLog("Error encoding item representation: \(error)")
            completion(.badEncoding)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            if let error = error {
                NSLog("Error PUTting item: \(error)")
                completion(.serverError(error))
                return
            }
            completion(nil)
        }.resume()
    }
    
    // PUT Letter in Firebase
    func putLetter(child: Child, id: String?, letter: Letter, completion: @escaping (NetworkingError?) -> Void) {
        
        guard let id = id,
            let childRep = child.childRepresentation,
            let letterRep = letter.letterRepresentation else { return }
        
        let requestURL = baseURL
            .appendingPathComponent("ParentAccount")
            .appendingPathComponent(id)
            .appendingPathComponent("children")
            .appendingPathComponent(childRep.name)
            .appendingPathComponent("LetterToSanta")
            .appendingPathComponent(letterRep.title)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(letter.letterRepresentation)
            print("Sucefully PUT letter in Firebase")
        } catch {
            NSLog("Error encoding letter representation: \(error)")
            completion(.badEncoding)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting letter: \(error)")
                completion(.serverError(error))
                return
            }
            completion(nil)
        }.resume()
    }
}


//private func updateTasks(with representations: [TaskRepresentation]) throws {
//    let tasksWithID = representations.filter { $0.identifier != nil }
//    let identifiersToFetch = tasksWithID.compactMap { UUID(uuidString: $0.identifier!) }
//
//    let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, tasksWithID))
//
//    var tasksToCreate = representationsByID
//
//    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//    fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
//
//    let context = CoreDataStack.shared.container.newBackgroundContext()
//
//    context.perform {
//        do {
//            let existingTasks = try context.fetch(fetchRequest)
//
//            for task in existingTasks {
//                guard let id = task.identifier,
//                    let representation = representationsByID[id] else { continue }
//
//                self.update(task: task, with: representation)
//                tasksToCreate.removeValue(forKey: id)
//            }
//
//            for representation in tasksToCreate.values {
//                Task(taskRepresentation: representation)
//            }
//        } catch {
//            print("Error fetching tasks for UUIDs: \(error)")
//        }
//    }
//
//    try CoreDataStack.shared.save(context: context)
//}
