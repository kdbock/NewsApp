//
//  RSSItemCell.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//


//
//  RSSItemCell.swift
//  NewsApp
//

import UIKit

class RSSItemCell: UITableViewCell {
    
    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let excerptLabel = UILabel()
    private let readMoreButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    var readMoreAction: (() -> Void)?
    var shareAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = BrandColors.darkGray
        titleLabel.numberOfLines = 2
        
        excerptLabel.font = UIFont.systemFont(ofSize: 14)
        excerptLabel.textColor = .darkGray
        excerptLabel.numberOfLines = 2
        
        readMoreButton.setTitle("Read More", for: .normal)
        readMoreButton.tintColor = .systemBlue
        readMoreButton.addTarget(self, action: #selector(didTapReadMore), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .systemBlue
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        // Layout
        [articleImageView, titleLabel, excerptLabel, readMoreButton, shareButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            articleImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            excerptLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            excerptLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            excerptLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            readMoreButton.topAnchor.constraint(equalTo: excerptLabel.bottomAnchor, constant: 4),
            readMoreButton.leadingAnchor.constraint(equalTo: excerptLabel.leadingAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            shareButton.centerYAnchor.constraint(equalTo: readMoreButton.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    @objc private func didTapReadMore() {
        readMoreAction?()
    }
    
    @objc private func didTapShare() {
        shareAction?()
    }
    
    func configure(with item: RSSItem) {
        titleLabel.text = item.title
        excerptLabel.text = item.description
        
        // Attempt to load the image if available
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            // Asynchronously load the image (basic approach)
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
}
