//
//  OxygenUnitTests.swift
//  OxygenUnitTests
//
//  Created by Ezra Black on 4/29/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import XCTest
@testable import Oxygen

class OxygenUnitTests: XCTestCase {
        //MARK: - Singletons -
    var bearer: Bearer?

    //MARK: User Tests
    
    func testUserCreate() {
        let user = UserRepresentation(id: 1, username: "eggy", password: "weggy", phoneNumber: "555-555-5555")
        if user.id == 1,
            user.username == "eggy",
            user.password == "weggy",
            user.phoneNumber == "555-555-5555" {
            XCTAssert(user.id == 1)
            XCTAssert(user.username == "eggy")
            XCTAssert(user.password == "weggy")
            XCTAssert(user.phoneNumber == "555-555-5555")
        }
    }
    
    
    
    func testForRegisterResults() {
        
    }
    
    
    func testForLoginResults() {
        let expectation = self.expectation(description: "Wait for results")
        let controller = ApiController()
        controller.login(username: "test", password: "password") {_ in
            print("Returned Results ⚠️")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    //MARK: Plant Tests
    
    func testPlantTableView() {
        let _ = PlantsTableViewController()
    }
    
    func testCreatingPlant(){
        let controller = ApiController()
        //  var plantRep: PlantRepresentation?
        guard let newBearer = bearer else {return}
        let plant = Plant(commonName: "Eggy", scientificName: "Weggy", image: "")
        let newPlant = plant
        let resultsExpectation = expectation(description: "wait for results")
        controller.sendPlantToServer(plant: newPlant) { (_ ) in
            self.bearer = newBearer
            resultsExpectation.fulfill()
        }
        wait(for: [resultsExpectation], timeout: 2)
        XCTAssertNotNil(newBearer)
    }
    
    //MARK: Networking Specific Tests
    
    func testSpeedOfNetworkRequestGetPlantNames() {
        measure {
            let expectation = self.expectation(description: "Wait for results")
            let controller = ApiController(dataLoader: URLSession(configuration: .ephemeral))
            controller.getPlantNames { (_ ) in
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testUserRegister() {
        
    }
    
    
    //MARK: JSON Testing
    //TODO: Implement the searchresults structure to be able to conform to the data loading and create a mock request using the JSON provided in the MockJSON
    func testValidData() {
        let mockDataLoader = MockDataLoader(data: goodResultData, response: nil, error: nil)
        let expectation = self.expectation(description: "Wait for results")
        let controller = ApiController(dataLoader: mockDataLoader)
        controller.fetchPlantsFromServer { (_ ) in
            //MARK: Fetching broken due to Backend Errors.
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
