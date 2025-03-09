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
        // Change link color to gold
        button.setTitleColor(BrandColors.gold, for: .normal)
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
    
    // Social Login Buttons
    
    private let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed // Google brand color (approx)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let appleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Apple", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black // Apple brand color
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let facebookSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Facebook", for: .normal)
        button.setTitleColor(.white, for: .normal)
        // Typical Facebook brand color
        button.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        // Change link color to gold
        button.setTitleColor(BrandColors.gold, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Ad space placeholder
    private let adContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Label for the “Hyper-local news...” text
    private let localNewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Hyper-local news with no pop-up ads, no AP news and no online subscription fees. No kidding!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove the default navigation bar title if needed
        // title = "Login" // commented out
        
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        
        // Social logins
        view.addSubview(googleSignInButton)
        view.addSubview(appleSignInButton)
        view.addSubview(facebookSignInButton)
        
        view.addSubview(registerButton)
        view.addSubview(adContainerView)
        view.addSubview(localNewsLabel)
        
        setupConstraints()
        
        // Button targets
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        googleSignInButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
        facebookSignInButton.addTarget(self, action: #selector(didTapFacebookSignIn), for: .touchUpInside)
        
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
            
            // Google Sign-In Button
            googleSignInButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 240),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Apple Sign-In Button
            appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 12),
            appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleSignInButton.widthAnchor.constraint(equalToConstant: 240),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Facebook Sign-In Button
            facebookSignInButton.topAnchor.constraint(equalTo: appleSignInButton.bottomAnchor, constant: 12),
            facebookSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            facebookSignInButton.widthAnchor.constraint(equalToConstant: 240),
            facebookSignInButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Register Button
            registerButton.topAnchor.constraint(equalTo: facebookSignInButton.bottomAnchor, constant: 12),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Ad container (placeholder)
            adContainerView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            adContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            adContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            adContainerView.heightAnchor.constraint(equalToConstant: 10),
            
            // “Hyper-local news...” label
            localNewsLabel.topAnchor.constraint(equalTo: adContainerView.bottomAnchor, constant: 20),
            localNewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            localNewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            localNewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapForgotPassword() {
        let forgotVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotVC, animated: true)
    }
    
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
    
    @objc private func didTapGoogleSignIn() {
        // TODO: Implement Google sign-in
        // e.g. using Firebase GoogleAuthProvider and GoogleSignIn SDK
        print("Google Sign-In tapped")
    }
    
    @objc private func didTapAppleSignIn() {
        // TODO: Implement Apple sign-in
        // e.g. using Firebase OAuthProvider or ASAuthorizationController
        print("Apple Sign-In tapped")
    }
    
    @objc private func didTapFacebookSignIn() {
        // TODO: Implement Facebook sign-in
        // e.g. using Firebase FacebookAuthProvider and FBSDKLoginKit
        print("Facebook Sign-In tapped")
    }
    
    @objc private func didTapRegister() {
        // Navigate to a Register screen
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
