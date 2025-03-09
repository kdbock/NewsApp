//
//  HeaderView.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.

import UIKit
import SafariServices

class HeaderView: UIView {
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - Top Row (3 columns)
    // 1) Left: Magnifying glass icon (tapping calls didTapSearch)
    private let searchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = BrandColors.gold  // Gold icon
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 2) Middle: neusenewslonglogo.png
    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "neusenewslonglogo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // 3) Right: Profile icon
    private let profileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "person.circle"), for: .normal)
        btn.tintColor = BrandColors.gold  // Gold icon
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Bottom Row (2 columns)
    // Left: News Categories
    private let categoriesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("News Categories", for: .normal)
        btn.setTitleColor(BrandColors.darkGray, for: .normal) // Dark gray text
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // Right: Order Classifieds
    private let orderClassifiedsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Order Classifieds", for: .normal)
        btn.setTitleColor(BrandColors.gold, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderColor = BrandColors.gold.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // White background for the entire header
        backgroundColor = .white
        
        // Two horizontal “rows”
        let topRow = UIView()
        let bottomRow = UIView()
        topRow.translatesAutoresizingMaskIntoConstraints = false
        bottomRow.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topRow)
        addSubview(bottomRow)
        
        NSLayoutConstraint.activate([
            topRow.topAnchor.constraint(equalTo: topAnchor),
            topRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            topRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            topRow.heightAnchor.constraint(equalToConstant: 44), // Adjust as desired
            
            bottomRow.topAnchor.constraint(equalTo: topRow.bottomAnchor),
            bottomRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomRow.heightAnchor.constraint(equalToConstant: 44),
            bottomRow.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // --- TOP ROW (3 columns) ---
        topRow.addSubview(searchButton)
        topRow.addSubview(logoImageView)
        topRow.addSubview(profileButton)
        
        // Left column: search button
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: topRow.leadingAnchor, constant: 8),
            searchButton.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Middle column: logo
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: topRow.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            logoImageView.widthAnchor.constraint(equalToConstant: 180) // Adjust as needed
        ])
        
        // Right column: profile button
        NSLayoutConstraint.activate([
            profileButton.trailingAnchor.constraint(equalTo: topRow.trailingAnchor, constant: -8),
            profileButton.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 30),
            profileButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // --- BOTTOM ROW (2 columns) ---
        bottomRow.addSubview(categoriesButton)
        bottomRow.addSubview(orderClassifiedsButton)
        
        NSLayoutConstraint.activate([
            // Left column: categories button
            categoriesButton.leadingAnchor.constraint(equalTo: bottomRow.leadingAnchor, constant: 8),
            categoriesButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            
            // Right column: order classifieds
            orderClassifiedsButton.trailingAnchor.constraint(equalTo: bottomRow.trailingAnchor, constant: -8),
            orderClassifiedsButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            orderClassifiedsButton.widthAnchor.constraint(equalToConstant: 150),
            orderClassifiedsButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupActions() {
        // Search icon
        searchButton.addTarget(self, action: #selector(didTapSearchIcon), for: .touchUpInside)
        
        // Profile dropdown
        profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        
        // Categories dropdown
        categoriesButton.addTarget(self, action: #selector(didTapCategories), for: .touchUpInside)
        
        // Order Classifieds
        orderClassifiedsButton.addTarget(self, action: #selector(didTapOrderClassifieds), for: .touchUpInside)
    }
    
    // MARK: - Search
    
    @objc private func didTapSearchIcon() {
        // Delegate method to show a search box, alert, or new view
        delegate?.didTapSearch()
    }
    
    // MARK: - Profile Menu
    
    @objc private func didTapProfile() {
        // iOS 14+ UIMenu
        let menu = UIMenu(title: "Profile Menu", children: [
            UIAction(title: "Profile", handler: { _ in
                self.delegate?.didSelectProfileOption(option: "Profile")
            }),
            UIAction(title: "Edit Profile", handler: { _ in
                self.delegate?.didSelectProfileOption(option: "Edit Profile")
            }),
            UIAction(title: "Bookmarks", handler: { _ in
                self.delegate?.didSelectProfileOption(option: "Bookmarks")
            })
        ])
        profileButton.showsMenuAsPrimaryAction = true
        profileButton.menu = menu
    }
    
    // MARK: - Categories Menu
    
    @objc private func didTapCategories() {
        let categories = [
            ("Local News", "https://www.neusenews.com/index/category/Local+News?format=rss"),
            ("State News", "https://www.neusenews.com/index/category/NC+News?format=rss"),
            ("Columns", "https://www.neusenews.com/index/category/Columns?format=rss"),
            ("Matters of Record", "https://www.neusenews.com/index/category/Matters+of+Record?format=rss"),
            ("Obituaries", "https://www.neusenews.com/index/category/Obituaries?format=rss"),
            ("Public Notice", "https://www.neusenews.com/index/category/Public+Notices?format=rss"),
            ("Classifieds", "https://www.neusenews.com/index/category/Classifieds?format=rss")
        ]
        
        let actions = categories.map { cat -> UIAction in
            let (title, url) = cat
            return UIAction(title: title, handler: { _ in
                self.delegate?.didSelectNewsCategory(url: url)
            })
        }
        
        let menu = UIMenu(title: "News Categories", children: actions)
        categoriesButton.showsMenuAsPrimaryAction = true
        categoriesButton.menu = menu
    }
    
    // MARK: - Order Classifieds
    
    @objc private func didTapOrderClassifieds() {
        let url = "https://www.neusenews.com/order-classifieds"
        delegate?.didTapOrderClassifieds(url: url)
    }
}

