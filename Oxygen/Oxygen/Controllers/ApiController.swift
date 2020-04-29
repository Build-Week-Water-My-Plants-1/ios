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
    
    // MARK: - Helper Methods
    
    private func updateUser(user: User, userRepresentation: UserRepresentation) {
        guard let id = userRepresentation.id else { return }
        
        user.id = String(id)
        user.username = userRepresentation.username
        user.password = userRepresentation.password
        user.phoneNumber = userRepresentation.phoneNumber
    }
}
