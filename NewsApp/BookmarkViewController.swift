//
//  BookmarkViewController.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct BookmarkItem {
    let articleID: String
    let title: String
    let link: String
    // Add other fields as needed: thumbnailURL, excerpt, etc.
}

class BookmarkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    
    private var bookmarks: [BookmarkItem] = []
    
    // Firebase reference
    private var bookmarksRef: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Database.database().reference().child("users").child(uid).child("bookmarks")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Bookmarks"
        
        setupTableView()
        fetchBookmarks()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchBookmarks() {
        // Example structure:
        // /users/{uid}/bookmarks/
        //     articleID1: { title: "...", link: "..." }
        //     articleID2: { title: "...", link: "..." }
        
        bookmarksRef?.observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            var temp: [BookmarkItem] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    let articleID = snap.key
                    let title = dict["title"] as? String ?? "No Title"
                    let link = dict["link"] as? String ?? ""
                    
                    let item = BookmarkItem(articleID: articleID, title: title, link: link)
                    temp.append(item)
                }
            }
            
            strongSelf.bookmarks = temp
            strongSelf.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = bookmarks[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = BrandColors.darkGray
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = bookmarks[indexPath.row]
        // Option 1: Open in-app browser
        // Option 2: Navigate to an ArticleDetailViewController
        // For now, just print the link
        print("Selected article link: \(item.link)")
    }
}

