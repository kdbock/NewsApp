//
//  RegisterViewController.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email (Username)"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let phoneField: UITextField = {
        let field = UITextField()
        field.placeholder = "Phone Number"
        field.borderStyle = .roundedRect
        field.keyboardType = .phonePad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let zipField: UITextField = {
        let field = UITextField()
        field.placeholder = "ZIP Code"
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    // Daily Newsletter Switch + Label
    private let dailyNewsletterLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily 7:00 AM Newsletter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyNewsletterSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    // Breaking News Text Alerts Switch + Label
    private let breakingNewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Breaking News Text Alerts"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let breakingNewsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = BrandColors.gold
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Register"
        
        // Add subviews
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(phoneField)
        view.addSubview(zipField)
        
        view.addSubview(dailyNewsletterLabel)
        view.addSubview(dailyNewsletterSwitch)
        
        view.addSubview(breakingNewsLabel)
        view.addSubview(breakingNewsSwitch)
        
        view.addSubview(createAccountButton)
        
        setupConstraints()
        
        // Button target
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Username Field
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            usernameField.heightAnchor.constraint(equalToConstant: 44),
            
            // Password Field
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            
            // Phone Field
            phoneField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12),
            phoneField.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            phoneField.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            phoneField.heightAnchor.constraint(equalToConstant: 44),
            
            // ZIP Field
            zipField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 12),
            zipField.leadingAnchor.constraint(equalTo: phoneField.leadingAnchor),
            zipField.trailingAnchor.constraint(equalTo: phoneField.trailingAnchor),
            zipField.heightAnchor.constraint(equalToConstant: 44),
            
            // Daily Newsletter Label
            dailyNewsletterLabel.topAnchor.constraint(equalTo: zipField.bottomAnchor, constant: 24),
            dailyNewsletterLabel.leadingAnchor.constraint(equalTo: zipField.leadingAnchor),
            
            // Daily Newsletter Switch
            dailyNewsletterSwitch.centerYAnchor.constraint(equalTo: dailyNewsletterLabel.centerYAnchor),
            dailyNewsletterSwitch.leadingAnchor.constraint(equalTo: dailyNewsletterLabel.trailingAnchor, constant: 12),
            
            // Breaking News Label
            breakingNewsLabel.topAnchor.constraint(equalTo: dailyNewsletterLabel.bottomAnchor, constant: 24),
            breakingNewsLabel.leadingAnchor.constraint(equalTo: dailyNewsletterLabel.leadingAnchor),
            
            // Breaking News Switch
            breakingNewsSwitch.centerYAnchor.constraint(equalTo: breakingNewsLabel.centerYAnchor),
            breakingNewsSwitch.leadingAnchor.constraint(equalTo: breakingNewsLabel.trailingAnchor, constant: 12),
            
            // Create Account Button
            createAccountButton.topAnchor.constraint(equalTo: breakingNewsLabel.bottomAnchor, constant: 40),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalToConstant: 160),
            createAccountButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapCreateAccount() {
        guard
            let email = usernameField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            showAlert("Error", "Please provide a username (email) and password.")
            return
        }
        
        // Attempt Firebase registration with email and password
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.showAlert("Registration Failed", error.localizedDescription)
            } else {
                // Registration success
                // Optionally store phone, zip, and switch preferences in Firestore or Realtime Database
                // For example (pseudo-code):
                /*
                let phone = strongSelf.phoneField.text ?? ""
                let zip = strongSelf.zipField.text ?? ""
                let dailyOptIn = strongSelf.dailyNewsletterSwitch.isOn
                let breakingOptIn = strongSelf.breakingNewsSwitch.isOn
                
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "phone": phone,
                    "zip": zip,
                    "dailyNewsletter": dailyOptIn,
                    "breakingNewsAlerts": breakingOptIn
                ]
                
                if let userID = authResult?.user.uid {
                    db.collection("users").document(userID).setData(userData) { err in
                        if let err = err {
                            print("Error saving user data: \(err)")
                        }
                    }
                }
                */
                
                strongSelf.showAlert("Success", "Your account has been created.")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
