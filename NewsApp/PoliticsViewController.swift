import UIKit

// MARK: - Politics View Controller
class PoliticsViewController: BaseRSSFeedViewController {
    init() {
        super.init(rssURL: URL(string: "https://www.ncpoliticalnews.com/news?format=rss"))
        title = "Politics"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
