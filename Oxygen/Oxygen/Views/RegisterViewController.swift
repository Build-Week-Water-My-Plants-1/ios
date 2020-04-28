//
//  RegisterViewController.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Labels
    
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    // MARK: - TextFields
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    /*
    I kept the naming convention the same of "nameConnectionType" but it makes it look strange.
     We might want to change it in the future but should be fine for now. You can access the
     inputted user password with {passwordField}.password. (HO)
    */
    @IBOutlet weak var passwordPasswordField: PasswordField!
    @IBOutlet weak var confirmPasswordPasswordField: PasswordField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions

    @IBAction func registerAccount(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
