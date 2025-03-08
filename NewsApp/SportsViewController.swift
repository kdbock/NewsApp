import UIKit

class SportsViewController: BaseRSSFeedViewController {
    init() {
        super.init(rssURL: URL(string: "https://www.neusenewssports.com/news-1?format=rss"))
        title = "Sports"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
