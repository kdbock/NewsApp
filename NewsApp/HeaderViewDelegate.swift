//
//  HeaderViewDelegate.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//


//
//  HeaderView.swift
//  NewsApp
//

import UIKit
import SafariServices

protocol HeaderViewDelegate: AnyObject {
    func didSelectNewsCategory(url: String)
    func didTapOrderClassifieds(url: String)
    func didSelectProfileOption(option: String)
}

class HeaderView: UIView {
    
    weak var delegate: HeaderViewDelegate?
    
    // Row 1
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search news..."
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    private let profileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "person.circle"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // Row 2
    private let categoriesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("News Categories", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let orderClassifiedsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Order Classifieds", for: .normal)
        btn.setTitleColor(BrandColors.gold, for: .normal)
        btn.layer.borderColor = BrandColors.gold.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BrandColors.gold
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = BrandColors.gold
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        // Two horizontal rows
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
            topRow.heightAnchor.constraint(equalToConstant: 50),
            
            bottomRow.topAnchor.constraint(equalTo: topRow.bottomAnchor),
            bottomRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomRow.heightAnchor.constraint(equalToConstant: 50),
            bottomRow.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Row 1: searchBar (left), profileButton (right)
        topRow.addSubview(searchBar)
        topRow.addSubview(profileButton)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: topRow.leadingAnchor, constant: 8),
            searchBar.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            searchBar.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -8),
            
            profileButton.trailingAnchor.constraint(equalTo: topRow.trailingAnchor, constant: -8),
            profileButton.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 30),
            profileButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Row 2: categoriesButton (left), orderClassifiedsButton (right)
        bottomRow.addSubview(categoriesButton)
        bottomRow.addSubview(orderClassifiedsButton)
        
        NSLayoutConstraint.activate([
            categoriesButton.leadingAnchor.constraint(equalTo: bottomRow.leadingAnchor, constant: 8),
            categoriesButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            
            orderClassifiedsButton.trailingAnchor.constraint(equalTo: bottomRow.trailingAnchor, constant: -8),
            orderClassifiedsButton.centerYAnchor.constraint(equalTo: bottomRow.centerYAnchor),
            orderClassifiedsButton.widthAnchor.constraint(equalToConstant: 150),
            orderClassifiedsButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupActions() {
        profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        categoriesButton.addTarget(self, action: #selector(didTapCategories), for: .touchUpInside)
        orderClassifiedsButton.addTarget(self, action: #selector(didTapOrderClassifieds), for: .touchUpInside)
    }
    
    @objc private func didTapProfile() {
        // iOS 14+ UIMenu example
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
    
    @objc private func didTapCategories() {
        // Another UIMenu for categories
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
    
    @objc private func didTapOrderClassifieds() {
        let url = "https://www.neusenews.com/order-classifieds"
        delegate?.didTapOrderClassifieds(url: url)
    }
}
