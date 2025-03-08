import UIKit

// MARK: - Business View Controller
class BusinessViewController: BaseRSSFeedViewController {
    init() {
        super.init(rssURL: URL(string: "https://www.magicmilemedia.com/blog?format=rss"))
        title = "Business"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
