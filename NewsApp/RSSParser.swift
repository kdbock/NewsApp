//
//  RSSParser.swift
//  NewsApp
//
//  Created by Kristy Kelly on 3/8/25.
//


//
//  RSSParser.swift
//  NewsApp
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    
    private let data: Data
    
    private var items: [RSSItem] = []
    private var currentElement = ""
    
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = ""
    private var currentImageURL: String?
    
    private var completion: (([RSSItem]) -> Void)?
    
    init(data: Data) {
        self.data = data
    }
    
    func parse(completion: @escaping ([RSSItem]) -> Void) {
        self.completion = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: - XMLParserDelegate
    func parserDidStartDocument(_ parser: XMLParser) {
        items.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            // Reset for new item
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentImageURL = nil
        }
        
        // Some feeds use <media:content> or <enclosure> for images
        if elementName.lowercased() == "media:content" || elementName.lowercased() == "enclosure" {
            if let url = attributeDict["url"] {
                currentImageURL = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        switch currentElement.lowercased() {
        case "title":
            currentTitle += trimmed + " "
        case "link":
            currentLink += trimmed
        case "description":
            currentDescription += trimmed + " "
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = RSSItem(title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                               link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                               description: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                               imageURL: currentImageURL)
            items.append(item)
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(items)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completion?([])
    }
}
