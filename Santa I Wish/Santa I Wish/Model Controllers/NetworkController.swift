//
//  NetworkController.swift
//  Santa I Wish
//
//  Created by macbook on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct NetworkController {
    private let baseURL = URL(string: "https://santaiwishbwunit4.firebaseio.com/")!

    // MARK: Fetch Parent from Firebase
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
    
    // MARK: PUT Parent to Firebase
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
            print("Sucefully PUT parent in Firebase")
        } catch {
            NSLog("Error encoding parent representation: \(error)")
            completion(.badEncoding)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting parent: \(error)")
                completion(.serverError(error))
                return
            }
        }.resume()
    }

}
