//
//  MainTabBarController.swift
//  NewsApp
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = BrandColors.gold
        
        let normalAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: BrandColors.darkGray]
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: BrandColors.gold
        ]

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
        
        // For iOS 15+
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.standardAppearance = appearance
    }

    private func setupViewControllers() {
        // Each tab is an RSS feed:
        // 1) Home
        let homeVC = RSSFeedViewController(feedURL: "https://www.neusenews.com/index?format=rss",
                                           title: "Home")
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house.fill"),
                                         tag: 0)

        // 2) Sports
        let sportsVC = RSSFeedViewController(feedURL: "https://www.neusenewssports.com/news-1?format=rss",
                                             title: "Sports")
        sportsVC.tabBarItem = UITabBarItem(title: "Sports",
                                           image: UIImage(systemName: "sportscourt.fill"),
                                           tag: 1)

        // 3) Politics
        let politicsVC = RSSFeedViewController(feedURL: "https://www.ncpoliticalnews.com/news?format=rss",
                                               title: "Politics")
        politicsVC.tabBarItem = UITabBarItem(title: "Politics",
                                             image: UIImage(systemName: "flag.fill"),
                                             tag: 2)

        // 4) Business
        let businessVC = RSSFeedViewController(feedURL: "https://www.magicmilemedia.com/blog?format=rss",
                                               title: "Business")
        businessVC.tabBarItem = UITabBarItem(title: "Business",
                                             image: UIImage(systemName: "briefcase.fill"),
                                             tag: 3)

        // 5) Classifieds
        let classifiedsVC = RSSFeedViewController(feedURL: "https://www.neusenews.com/index/category/Classifieds?format=rss",
                                                  title: "Classifieds")
        classifiedsVC.tabBarItem = UITabBarItem(title: "Classifieds",
                                                image: UIImage(systemName: "list.bullet.rectangle.portrait.fill"),
                                                tag: 4)

        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: sportsVC),
            UINavigationController(rootViewController: politicsVC),
            UINavigationController(rootViewController: businessVC),
            UINavigationController(rootViewController: classifiedsVC)
        ]
    }
}
