//
//  LoginViewController.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordPasswordField: PasswordField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: UIButton) {
        // TODO(HO): - Send to api controller and check if logged in if so
        navigationController?.popToViewController(PlantsTableViewController(), animated: true)
    }
    
    @IBAction func switchToRegister(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
