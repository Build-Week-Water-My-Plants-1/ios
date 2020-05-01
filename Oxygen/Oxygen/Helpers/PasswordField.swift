//
//  PasswordField.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import UIKit

class PasswordField: UIControl {
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private var passwordHidden = true
    private let textFieldMargin: CGFloat = 6.0
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()

    func setup() {
        addSubview(textField)
        addSubview(showHideButton)
        // Turn off Autoresizing Mask translation
        textField.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.translatesAutoresizingMaskIntoConstraints = false

        // Constrain
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            showHideButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -textFieldMargin),
            showHideButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            showHideButton.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 0.7),
            showHideButton.widthAnchor.constraint(equalTo: showHideButton.heightAnchor)
        ])
        // Initialize labels and text field
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)

        textField.isEnabled = true
        showHideButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        showHideButton.addTarget(self, action: #selector(showHideTapped), for: .touchUpInside)
    }
    //adds custom labels etc, and makes this page the textfield delegate of the view.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textField.delegate = self
        setup()
    }
    //function to run the eye icon and present the text as secure or not.
    @objc private func showHideTapped() {
        if passwordHidden == true {
            showHideButton.setImage(UIImage(systemName: "eye"), for: .normal)
            textField.isSecureTextEntry = false
        } else {
            showHideButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            textField.isSecureTextEntry = true
        }
        passwordHidden.toggle()
    }
}

//replaces, changes, and resets pasword strings and user text.
extension PasswordField: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        password = textField.text ?? ""
        sendActions(for: [.valueChanged])
    }
 //this is putting the user input as the password instance, and resigning the textfiled when return is hit.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password = textField.text ?? ""
        sendActions(for: [.valueChanged])
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        password = textField.text ?? ""
        sendActions(for: [.valueChanged, .editingDidEnd])
    }
}
