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
        //dont recomend. use a timer if possible. generally better. under the hood a timer is being made BUT generally speaking use a time because then you can cancel it if the view controller is not on screen for instance. 👇
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            completion(self.data, self.response, self.error)
        }
    }
}
