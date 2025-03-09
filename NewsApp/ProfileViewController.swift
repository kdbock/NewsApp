//
//  ProfileViewController.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // Gold header background (optional custom header)
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = BrandColors.gold // #d2982a
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Profile photo (placeholder)
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = BrandColors.darkGray // #2d2c31
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location: N/A"
        label.font = .systemFont(ofSize: 16)
        label.textColor = BrandColors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsletterLabel: UILabel = {
        let label = UILabel()
        label.text = "Newsletter: Off"
        label.font = .systemFont(ofSize: 16)
        label.textColor = BrandColors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pushLabel: UILabel = {
        let label = UILabel()
        label.text = "Push Notifications: Off"
        label.font = .systemFont(ofSize: 16)
        label.textColor = BrandColors.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = BrandColors.darkGray // #2d2c31
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(BrandColors.gold, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderColor = BrandColors.gold.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Firebase
    private var userRef: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Database.database().reference().child("users").child(uid)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        editProfileButton.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        fetchUserProfile()
    }
    
    private func setupViews() {
        // Add the gold header
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        
        // Main content
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(locationLabel)
        view.addSubview(newsletterLabel)
        view.addSubview(pushLabel)
        view.addSubview(editProfileButton)
        view.addSubview(signOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Email
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Location
            locationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Newsletter
            newsletterLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            newsletterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Push
            pushLabel.topAnchor.constraint(equalTo: newsletterLabel.bottomAnchor, constant: 8),
            pushLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Edit Profile Button
            editProfileButton.topAnchor.constraint(equalTo: pushLabel.bottomAnchor, constant: 20),
            editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant: 120),
            editProfileButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Sign Out Button
            signOutButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 16),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 120),
            signOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Fetch User Profile
    
    private func fetchUserProfile() {
        userRef?.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if let dict = snapshot.value as? [String: Any] {
                let name = dict["name"] as? String ?? "N/A"
                let email = dict["email"] as? String ?? "N/A"
                let location = dict["location"] as? String ?? "N/A"
                let newsletter = dict["newsletterOptIn"] as? Bool ?? false
                let push = dict["pushOptIn"] as? Bool ?? false
                
                strongSelf.nameLabel.text = name
                strongSelf.emailLabel.text = email
                strongSelf.locationLabel.text = "Location: \(location)"
                strongSelf.newsletterLabel.text = "Newsletter: \(newsletter ? "On" : "Off")"
                strongSelf.pushLabel.text = "Push Notifications: \(push ? "On" : "Off")"
                
                // If you have a profile photo URL, load it here with SDWebImage or similar
                // let photoURL = dict["photoURL"] as? String ?? ""
            }
        })
    }
    
    // MARK: - Actions
    
    @objc private func didTapEditProfile() {
        let editVC = EditProfileViewController()
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc private func didTapSignOut() {
        do {
            try Auth.auth().signOut()
            // Navigate back to login or wherever
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Sign out error: \(error)")
        }
    }
}

