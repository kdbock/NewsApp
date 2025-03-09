//
//  EditProfileViewController.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Name"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let locationField: UITextField = {
        let field = UITextField()
        field.placeholder = "Location / ZIP"
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let newsletterSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let newsletterLabel: UILabel = {
        let label = UILabel()
        label.text = "Newsletter Opt-In"
        label.textColor = BrandColors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pushSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let pushLabel: UILabel = {
        let label = UILabel()
        label.text = "Push Notifications"
        label.textColor = BrandColors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = BrandColors.gold
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Firebase
    private var userRef: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Database.database().reference().child("users").child(uid)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Edit Profile"
        
        setupViews()
        setupConstraints()
        
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
        fetchCurrentProfile()
    }
    
    private func setupViews() {
        view.addSubview(nameField)
        view.addSubview(locationField)
        
        view.addSubview(newsletterLabel)
        view.addSubview(newsletterSwitch)
        
        view.addSubview(pushLabel)
        view.addSubview(pushSwitch)
        
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameField.heightAnchor.constraint(equalToConstant: 44),
            
            locationField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12),
            locationField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            locationField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            locationField.heightAnchor.constraint(equalToConstant: 44),
            
            newsletterLabel.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: 20),
            newsletterLabel.leadingAnchor.constraint(equalTo: locationField.leadingAnchor),
            
            newsletterSwitch.centerYAnchor.constraint(equalTo: newsletterLabel.centerYAnchor),
            newsletterSwitch.leadingAnchor.constraint(equalTo: newsletterLabel.trailingAnchor, constant: 12),
            
            pushLabel.topAnchor.constraint(equalTo: newsletterLabel.bottomAnchor, constant: 20),
            pushLabel.leadingAnchor.constraint(equalTo: newsletterLabel.leadingAnchor),
            
            pushSwitch.centerYAnchor.constraint(equalTo: pushLabel.centerYAnchor),
            pushSwitch.leadingAnchor.constraint(equalTo: pushLabel.trailingAnchor, constant: 12),
            
            saveButton.topAnchor.constraint(equalTo: pushLabel.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 160),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Fetch Current Profile
    
    private func fetchCurrentProfile() {
        userRef?.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if let dict = snapshot.value as? [String: Any] {
                strongSelf.nameField.text = dict["name"] as? String
                strongSelf.locationField.text = dict["location"] as? String
                let newsletter = dict["newsletterOptIn"] as? Bool ?? false
                let push = dict["pushOptIn"] as? Bool ?? false
                strongSelf.newsletterSwitch.isOn = newsletter
                strongSelf.pushSwitch.isOn = push
            }
        })
    }
    
    // MARK: - Actions
    
    @objc private func didTapSave() {
        guard let name = nameField.text, !name.isEmpty else {
            showAlert("Error", "Name cannot be empty.")
            return
        }
        let location = locationField.text ?? ""
        let newsletter = newsletterSwitch.isOn
        let push = pushSwitch.isOn
        
        let updates: [String: Any] = [
            "name": name,
            "location": location,
            "newsletterOptIn": newsletter,
            "pushOptIn": push
        ]
        
        userRef?.updateChildValues(updates, withCompletionBlock: { [weak self] error, _ in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert("Update Failed", error.localizedDescription)
            } else {
                strongSelf.showAlert("Success", "Profile updated successfully.")
                strongSelf.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}


