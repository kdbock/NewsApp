import UIKit

// MARK: - Classifieds View Controller
class ClassifiedsViewController: BaseRSSFeedViewController {
    init() {
        super.init(rssURL: URL(string: "https://www.neusenews.com/index/category/Classifieds?format=rss"))
        title = "Classifieds"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
