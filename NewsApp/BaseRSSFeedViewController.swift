//
//  BaseRSSFeedViewController.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//  (Consolidated for demonstration)
//

import UIKit

// MARK: - Base View Controller for RSS Feed Sections
class BaseRSSFeedViewController: UIViewController {
    let rssURL: URL?

    init(rssURL: URL?) {
        self.rssURL = rssURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        // Title Label
        let label = UILabel()
        label.text = "Content for \(navigationItem.title ?? "This Section") will be displayed here."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        // Add Top Navigation View
        let topNavigationView = TopNavigationView()
        topNavigationView.translatesAutoresizingMaskIntoConstraints = false

        // RSS Feed Placeholder View
        let rssFeedPlaceholder = UIView()
        rssFeedPlaceholder.backgroundColor = .lightGray.withAlphaComponent(0.2)
        rssFeedPlaceholder.translatesAutoresizingMaskIntoConstraints = false

        // Placeholder Label
        let placeholderLabel = UILabel()
        placeholderLabel.text = "RSS Feed Content Here"
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add Subviews
        view.addSubview(topNavigationView)
        view.addSubview(rssFeedPlaceholder)
        view.addSubview(label)
        rssFeedPlaceholder.addSubview(placeholderLabel)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // Top Navigation Constraints
            topNavigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topNavigationView.heightAnchor.constraint(equalToConstant: 50),

            // RSS Feed Placeholder Constraints
            rssFeedPlaceholder.topAnchor.constraint(equalTo: topNavigationView.bottomAnchor),
            rssFeedPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rssFeedPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rssFeedPlaceholder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // Placeholder Label Constraints
            placeholderLabel.centerXAnchor.constraint(equalTo: rssFeedPlaceholder.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: rssFeedPlaceholder.centerYAnchor),

            // Title Label Constraints
            label.topAnchor.constraint(equalTo: rssFeedPlaceholder.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: rssFeedPlaceholder.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: rssFeedPlaceholder.trailingAnchor, constant: -20)
        ])
    }
}
