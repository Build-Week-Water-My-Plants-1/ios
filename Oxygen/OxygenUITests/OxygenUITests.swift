//
//  OxygenUITests.swift
//  OxygenUITests
//
//  Created by Ezra Black on 5/1/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import XCTest

class OxygenUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
                
            }
        }
    }
    
    //MARK: LoginViewTests
    
    func testTextFieldTaps() throws {
        let app = XCUIApplication()
        app.launch()
        var value: Int = 0
        while value < 10 {
            app.textFields["RegisterViewController.UserNameTextField"].tap()
            value += 1
        }
        
        
    }
    
    func testRegister() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["RegisterViewController.UserNameTextField"].tap()
        app.textFields["RegisterViewController.UserNameTextField"].typeText("TestUserEzra")
        XCTAssertNotEqual(app.textFields["RegisterViewController.UserNameTextField"].label, "TestUserEzra")
        app.textFields["RegisterViewController.PhoneNumberTextField"].tap()
        app.textFields["RegisterViewController.PhoneNumberTextField"].tap()
        app.textFields["RegisterViewController.PhoneNumberTextField"].typeText("321-577-5555")
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.typeText("testpassword")
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.typeText("testpassword")
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["RegisterVC.RegisterButton"].tap()
        
    }
    
    func testLoginLifeCycle() throws {
        let app = XCUIApplication()
        app.launch()
        let finishedRegister = XCTestExpectation(description: "User has been registered")
        app.textFields["RegisterViewController.UserNameTextField"].tap()
        app.textFields["RegisterViewController.UserNameTextField"].typeText("TestUserEzra1235")
        app.textFields["RegisterViewController.PhoneNumberTextField"].tap()
        app.textFields["RegisterViewController.PhoneNumberTextField"].tap()
        app.textFields["RegisterViewController.PhoneNumberTextField"].typeText("321-577-2341")
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.typeText("testpassword")
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.typeText("testpassword")
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["RegisterVC.RegisterButton"].tap()
        finishedRegister.fulfill()
        wait(for: [finishedRegister], timeout: 30)
        app.textFields["LoginVC.UsernameTextfield"].tap()
        app.textFields["LoginVC.UsernameTextfield"].typeText("TestUserEzra1235")
        app.otherElements["LoginVC.PasswordTextfield"].tap()
        app.otherElements["LoginVC.PasswordTextfield"].tap()
        app.otherElements["LoginVC.PasswordTextfield"].typeText("testpassword")
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["LoginVC.LoginButton"].tap()
    }
    
    func testLoginCreatePlant() {
        let app = XCUIApplication()
        app.launch()
        let expect = XCTestExpectation(description: "Waiting for view to upload")
        app.buttons["RegisterVC.LoginButton"].tap()
        expect.fulfill()
        wait(for: [expect], timeout: 15)
        app.textFields["LoginVC.UsernameTextfield"].tap()
        app.textFields["LoginVC.UsernameTextfield"].typeText("TestUserEzra1235")
        app.otherElements["LoginVC.PasswordTextfield"].tap()
        app.otherElements["LoginVC.PasswordTextfield"].tap()
        app.otherElements["LoginVC.PasswordTextfield"].typeText("testpassword")
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let expectLogin = XCTestExpectation(description: "waiting to login")
        app.buttons["LoginVC.LoginButton"].tap()
        expectLogin.fulfill()
        wait(for: [expectLogin], timeout: 15)
        
        //PlantDetailController.PlantNameLabel
        //PlantDetailController.SpeciesNameLabel
        //PlantDetailController.WaterFrequencyLabel
        //PlantDetailController.ImageButton
        //PlantDetailController.SavePlantButton
        //PlantDetailController.CanelButton
        //PlantDetailController.PickerView
        
        //TODO: XCUI control for UI Detail
    }
    
    func testLoginToRegister() {
        let app = XCUIApplication()
        app.launch()
        let finishedRegister = XCTestExpectation(description: "User has been registered")
        app.textFields["RegisterViewController.UserNameTextField"].tap()
        app.textFields["RegisterViewController.UserNameTextField"].typeText("randomperson1")
        app.textFields["RegisterViewController.PhoneNumberTextField"].tap()
        app.textFields["RegisterViewController.PhoneNumberTextField"].tap()
        app.textFields["RegisterViewController.PhoneNumberTextField"].typeText("321-534-5102")
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.PasswordTextfield"].children(matching: .secureTextField).element.typeText("testpassword")
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.tap()
        app.otherElements["RegisterViewController.Password2Textfield"].children(matching: .secureTextField).element.typeText("testpassword")
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["RegisterVC.RegisterButton"].tap()
        finishedRegister.fulfill()
        wait(for: [finishedRegister], timeout: 30)
        app.buttons["LoginVC.RegisterButton"].tap()
    }
}
extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}
