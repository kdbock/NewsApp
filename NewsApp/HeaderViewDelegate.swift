//
//  HeaderViewDelegate.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//

import Foundation

protocol HeaderViewDelegate: AnyObject {
    func didSelectNewsCategory(url: String)
    func didTapOrderClassifieds(url: String)
    func didSelectProfileOption(option: String)
    func didTapSearch()
}
