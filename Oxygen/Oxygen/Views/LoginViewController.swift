//
//  LoginViewController.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var apiController = ApiController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var switchToRegisterButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordPasswordField: PasswordField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        
        loginButton.isEnabled = false
        switchToRegisterButton.isEnabled = false
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        apiController.login(username: username, password: passwordPasswordField.password) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            case .failure(_):
                NSLog("Failed to log in.")
            }
        }
    }
    
    @IBAction func switchToRegister(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
