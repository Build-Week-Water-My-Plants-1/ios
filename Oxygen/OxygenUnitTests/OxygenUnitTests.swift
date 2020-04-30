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
    
    var bearer: Bearer?
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
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
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = ApiController()
        controller.login(username: "test", password: "password") {_ in
              print("Returned Results ⚠️")
//            XCTAssertGreaterThan(, 0)
//             XCTAssertGreaterThan(controller.searchResults.count, 0)
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
          var plant: Plant?
          guard let newPlant = plant else {return}
          let resultsExpectation = expectation(description: "wait for results")
        controller.sendPlantToServer(plant: newPlant) { (_ ) in
            self.bearer = newBearer
            resultsExpectation.fulfill()
        }
           wait(for: [resultsExpectation], timeout: 2)
          XCTAssertNotNil(newBearer)
      }
}
