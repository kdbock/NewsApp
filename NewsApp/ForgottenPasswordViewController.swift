//
//  ForgotPasswordViewController.swift
//  NewsApp
//

import UIKit
import FirebaseCore
import FirebaseAuth


class ForgotPasswordViewController: UIViewController {
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your email address to receive a password reset link."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = BrandColors.gold
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        view.backgroundColor = .white
        
        view.addSubview(instructionLabel)
        view.addSubview(emailField)
        view.addSubview(submitButton)
        
        setupConstraints()
        
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: instructionLabel.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: instructionLabel.trailingAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 44),
            
            submitButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 120),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapSubmit() {
        guard let email = emailField.text, !email.isEmpty else {
            showAlert("Error", "Please enter your email.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert("Error", error.localizedDescription)
            } else {
                strongSelf.showAlert("Success", "A password reset link has been sent.")
                // Optionally pop back to login
                strongSelf.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
