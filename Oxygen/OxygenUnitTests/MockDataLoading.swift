//
//  MockDataLoading.swift
//  OxygenUnitTests
//
//  Created by Ezra Black on 4/30/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
@testable import Oxygen
//does a urlsession without a actual session.
//no wifi? no network? no problem.
class MockDataLoader: NetworkDataLoader {
//    
    let data: Data?
    let response: URLResponse?
    let error: Error?

    internal init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            completion(self.data, self.response, self.error)
        }
    }
}
