//
//  LoginViewController.swift
//  NewsApp
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "neusenewslogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username (Email)"
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
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = BrandColors.gold
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 1) Admin Login Button
    private let adminLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Admin Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed // or BrandColors.darkGray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 2) Register Button
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(adminLoginButton)
        view.addSubview(registerButton)
        
        setupConstraints()
        
        // Button targets
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        adminLoginButton.addTarget(self, action: #selector(didTapAdminLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Email
            emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailField.heightAnchor.constraint(equalToConstant: 44),
            
            // Password
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            
            // Forgot Password Button
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Admin Login Button (below login button)
            adminLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            adminLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adminLoginButton.widthAnchor.constraint(equalToConstant: 120),
            adminLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Register Button (below admin button)
            registerButton.topAnchor.constraint(equalTo: adminLoginButton.bottomAnchor, constant: 12),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapForgotPassword() {
        let forgotVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    // Normal user login
    @objc private func didTapLogin() {
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
        else {
            showAlert("Error", "Please enter email and password.")
            return
        }
        
        // Firebase Auth sign-in
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert("Login Failed", error.localizedDescription)
            } else {
                // Navigate to main tab bar
                let tabBarVC = MainTabBarController()
                strongSelf.navigationController?.pushViewController(tabBarVC, animated: true)
            }
        }
    }
    
    // 1) Admin Login
    @objc private func didTapAdminLogin() {
        // Hardcoded admin credentials (for testing)
        let adminEmail = "admin@example.com"
        let adminPassword = "AdminPassword123"  // Make sure this user exists in Firebase

        Auth.auth().signIn(withEmail: adminEmail, password: adminPassword) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert("Admin Login Failed", error.localizedDescription)
            } else {
                // Maybe load an Admin-specific screen or same tab bar with more privileges
                let tabBarVC = MainTabBarController()
                strongSelf.navigationController?.pushViewController(tabBarVC, animated: true)
            }
        }
    }
    
    // 2) Register a new account
    @objc private func didTapRegister() {
        // Navigate to a Register screen. You can create a RegisterViewController for new user sign-up.
        let registerVC = RegisterViewController()  // This is a placeholder class you'll define
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
