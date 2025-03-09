//
//  RSSItemCell.swift
//  NewsApp
//

import UIKit

class RSSItemCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let articleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true // Needed for tap gesture
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = BrandColors.darkGray
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true // Needed for tap gesture
        return label
    }()
    
    private let excerptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    // Bottom row: two columns
    private let readMoreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Read More", for: .normal)
        // Make link gold
        btn.setTitleColor(BrandColors.gold, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        // Tint gold
        btn.tintColor = BrandColors.gold
        return btn
    }()
    
    // MARK: - Actions
    
    /// Called when user taps image, title, or read more
    var openArticleAction: (() -> Void)?
    
    /// Called when user taps share
    var shareAction: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        
        // Add subviews
        [articleImageView, titleLabel, excerptLabel, readMoreButton, shareButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // Gestures for image & title
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapOpenArticle))
        articleImageView.addGestureRecognizer(imageTap)
        
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(didTapOpenArticle))
        titleLabel.addGestureRecognizer(titleTap)
        
        // Button actions
        readMoreButton.addTarget(self, action: #selector(didTapOpenArticle), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Image at top
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            articleImageView.heightAnchor.constraint(equalToConstant: 150), // Adjust as desired
            
            // Title below image
            titleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor),
            
            // Excerpt below title
            excerptLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            excerptLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            excerptLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Bottom row: two columns
            // Left: readMoreButton, Right: shareButton
            readMoreButton.topAnchor.constraint(equalTo: excerptLabel.bottomAnchor, constant: 8),
            readMoreButton.leadingAnchor.constraint(equalTo: excerptLabel.leadingAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            shareButton.centerYAnchor.constraint(equalTo: readMoreButton.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: excerptLabel.trailingAnchor)
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(with item: RSSItem) {
        titleLabel.text = item.title
        excerptLabel.text = item.description
        
        // Load image if available
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.articleImageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            articleImageView.image = nil
        }
    }
    
    // MARK: - Handlers
    
    @objc private func didTapOpenArticle() {
        openArticleAction?()
    }
    
    @objc private func didTapShare() {
        shareAction?()
    }
}
