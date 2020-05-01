//
//  RegisterViewController.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - Properties
    var apiController = ApiController()
    // MARK: - Activity Indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Buttons
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var switchToLoginButton: UIButton!
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

        activityIndicator.isHidden = true
    }
    // MARK: - Actions

    @IBAction func registerAccount(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            passwordPasswordField.password == confirmPasswordPasswordField.password else { return }
        registerButton.isEnabled = false
        switchToLoginButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let user = User(id: nil,
                        username: username,
                        password: passwordPasswordField.password,
                        phoneNumber: phoneNumber)
        apiController.register(with: user) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.showAlert(title: "Failure", message: "Couldn't register new user.")
                }
            }
        }
    }
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
