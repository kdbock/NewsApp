//
//  RSSFeedViewController.swift
//  NewsApp
//

import UIKit
import SafariServices

class RSSFeedViewController: UIViewController {

    private let feedURL: String
    private var items: [RSSItem] = []
    
    // Table
    private let tableView = UITableView()
    
    // Custom header
    private let headerView = HeaderView()
    
    init(feedURL: String, title: String) {
        self.feedURL = feedURL
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Setup header
        headerView.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Setup table
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RSSItemCell.self, forCellReuseIdentifier: "RSSItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        setupConstraints()
        fetchRSSFeed()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header at top
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100), // 2 rows * 50 each
            
            // Table below header
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchRSSFeed() {
        guard let url = URL(string: feedURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            // Parse XML
            let parser = RSSParser(data: data)
            parser.parse { [weak self] result in
                DispatchQueue.main.async {
                    self?.items = result
                    self?.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RSSFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell", for: indexPath) as? RSSItemCell
        else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        // Open article link whenever user taps image, title, or "Read More"
        cell.openArticleAction = { [weak self] in
            guard let link = URL(string: item.link) else { return }
            let safariVC = SFSafariViewController(url: link)
            self?.present(safariVC, animated: true)
        }
        
        // Share action
        cell.shareAction = { [weak self] in
            let textToShare = "\(item.title) - \(item.link)"
            let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            self?.present(activityVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Optionally, open link when row is tapped
        // But you specifically said only image, title, read more
        // so we can leave row tap with no action
    }
}

// MARK: - HeaderViewDelegate
extension RSSFeedViewController: HeaderViewDelegate {
    func didSelectNewsCategory(url: String) {
        let categoryVC = RSSFeedViewController(feedURL: url, title: "Category")
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func didTapOrderClassifieds(url: String) {
        guard let link = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: link)
        present(safariVC, animated: true)
    }
    
    func didSelectProfileOption(option: String) {
        // Handle "Profile", "Edit Profile", "Bookmarks"
        let alert = UIAlertController(title: "Selected: \(option)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // If your HeaderViewDelegate includes didTapSearch(), implement it:
    // func didTapSearch() { ... }
}
