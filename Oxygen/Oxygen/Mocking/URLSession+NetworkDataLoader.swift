//
//  URLSession+NetworkDataLoader.swift
//  Oxygen
//
//  Created by Ezra Black on 4/30/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
