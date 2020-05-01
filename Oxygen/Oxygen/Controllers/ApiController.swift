//
//  ApiController.swift
//  Oxygen
//
//  Created by Hunter Oppel on 4/29/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

class ApiController {
    
    // MARK: - Typealias
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    // MARK: - Enums
    
    enum HTTPMethod: String {
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case failedRegister
        case failedLogin
        case noData
        case notSignedIn
        case failedFetch
        case otherError
        case noIdentifier
        case noDecode
        case noEncode
        case noRep
    }
    
    private enum LoginStatus {
        case notLoggedIn
        case LoggedIn(Bearer)
        
        static var isLoggedIn: Self {
            if let bearer = ApiController.bearer {
                return LoggedIn(bearer)
            } else {
                return notLoggedIn
            }
        }
    }
        
    // MARK: - Properties
    
    static var bearer: Bearer?
    
    private let baseURL = URL(string: "https://water-my-plants-12.herokuapp.com/api")!
    private lazy var registerURL = baseURL.appendingPathComponent("/auth/register")
    private lazy var loginURL = baseURL.appendingPathComponent("/auth/login")
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var dataLoader: NetworkDataLoader
    
    init(dataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - User Api
    
    func register(with user: User, completion: @escaping CompletionHandler = { _ in }) {
        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user.userRepresentation)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Register failed with error: \(error.localizedDescription)")
                    return completion(.failure(.failedRegister))
                }
                
                guard let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode != 200 {
                    NSLog("Response from server was bad: \(response)")
                    return completion(.failure(.failedRegister))
                }
                
                guard let data = data else {
                    NSLog("No data was returned from server.")
                    return completion(.failure(.noData))
                }
                
                let context = CoreDataStack.shared.container.newBackgroundContext()
                
                context.perform {
                    do {
                        let userRepresentation = try self.jsonDecoder.decode(UserRepresentation.self, from: data)
                        self.updateUser(user: user, userRepresentation: userRepresentation)
                        completion(.success(true))
                    } catch {
                        NSLog("Failed to decode user from server with error: \(error)")
                        completion(.failure(.otherError))
                    }
                }
            }
            .resume()
        } catch {
            NSLog("Failed to encode user \(user) with error \(error)")
            completion(.failure(.otherError))
        }
    }
    
    func login(username: String, password: String, completion: @escaping CompletionHandler = { _ in }) {
        let user = UserRepresentation(id: nil, username: username, password: password, phoneNumber: nil)
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Log in failed with error: \(error)")
                    return completion(.failure(.failedLogin))
                }
                
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    NSLog("Response from server was bad.")
                    return completion(.failure(.failedLogin))
                }
                
                guard let data = data else {
                    NSLog("No data was returned from server.")
                    return completion(.failure(.noData))
                }
                do {
                    Self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                } catch {
                    NSLog("Failed to decode bearer with error: \(error)")
                    completion(.failure(.otherError))
                }
            }
            .resume()
        } catch {
            NSLog("Something happened during login: \(error)")
            return completion(.failure(.failedLogin))
        }
    }
    
    // MARK: - Plant Api

    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        guard case let .LoggedIn(bearer) = LoginStatus.isLoggedIn else {
            NSLog("User not logged in")
            return completion(.failure(.notSignedIn))
        }
        let requestURL = baseURL.appendingPathComponent("/\(bearer.id)/plants")
        var request = URLRequest(url: requestURL)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error fetching plants: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch")
                completion(.failure(.noData))
                return
            }
            do {
                let plantRepresentations = try self.jsonDecoder.decode([PlantRepresentation].self, from: data)
                
                try self.updatePlants(with: plantRepresentations)
                completion(.success(true))
            } catch {
                NSLog("Error decoding plants from server: \(error)")
                completion(.failure(.noDecode))
            }
        }
        .resume()
    }
    
    // GET (Read)
    func getPlantNames(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                NSLog("Error fetching plants: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch")
                completion(.failure(.noData))
                return
            }
            
            do {
                let plantRepresentations = Array(try JSONDecoder().decode([String : PlantRepresentation].self, from: data).values)
                try self.updatePlants(with: plantRepresentations)
                completion(.success(true))
            } catch {
                NSLog("Error decoding plants from server: \(error)")
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    
    // PUT
    func sendPlantToServer(plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = plant.id,
            case let .LoggedIn(bearer) = LoginStatus.isLoggedIn else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("/\(bearer.id)/plants/\(uuid)")
        var request = URLRequest(url: requestURL)
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        do {
            guard let representation = plant.plantRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            NSLog("Error encoding plant \(plant): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error sending plant to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    // DELETE
    func deletePlantFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifer = plant.id else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifer).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error deleting plant from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    // MARK: - Helper Methods
    
    private func updatePlants(with representations: [PlantRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { $0.id }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var plantsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingPlants = try context.fetch(fetchRequest)
            
            for plant in existingPlants {
                guard let id = plant.id,
                    let idInt = Int(id),
                    let representation = representationsByID[idInt] else { continue }
                self.updatePlant(plant: plant, plantRepresentation: representation)
                plantsToCreate.removeValue(forKey: idInt)
            }
            
            for representation in plantsToCreate.values {
                Plant(plantRepresentation: representation)
            }
        } catch {
            NSLog("Error fetching tasks with UUIDs: \(identifiersToFetch), with error: \(error)")
        }
        
        try CoreDataStack.shared.mainContext.save()
    }
    
    private func updatePlant(plant: Plant, plantRepresentation: PlantRepresentation) {
        plant.id = plantRepresentation.idString
        plant.commonName = plantRepresentation.commonName
        plant.scientificName = plantRepresentation.scientificName
        plant.h2oFrequency = plantRepresentation.h2oFrequency
    }
    
    private func updateUser(user: User, userRepresentation: UserRepresentation) {
        guard let id = userRepresentation.id else { return }
        
        user.id = String(id)
        user.username = userRepresentation.username
        user.password = userRepresentation.password
        user.phoneNumber = userRepresentation.phoneNumber
    }
}
