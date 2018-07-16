//
//  Episode.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 07/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation

class Episode
{
    var title: String?
    var description: String?
    var thumbnailURL: URL?
    var createdAt: String?
    var author: String?
    var url: URL?
    
    init(title: String, description: String, thumbnailURL: URL, createdAt: String, author: String)
    {
        self.title = title
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.createdAt = createdAt
        self.author = author
    }
    
    init(epsDictionary: [String : Any]) {
        self.title = epsDictionary["title"] as? String
        description = epsDictionary["description"] as? String
        // url, createdAt, author, thumbnailURL
        url = URL(string: epsDictionary["link"] as! String)
        createdAt = epsDictionary["pubDate"] as? String
        author = epsDictionary["author"] as? String
        thumbnailURL = URL(string: epsDictionary["thumbnailURL"] as! String)
    }
    
    static func downloadAllEpisodes() -> [Episode]
    {
        var episodes = [Episode]()
        
        let jsonFile = Bundle.main.path(forResource: "DucBlog", ofType: "json")
        let jsonFileURL = URL(fileURLWithPath: jsonFile!)
        let jsonData = try? Data(contentsOf: jsonFileURL)
        /*
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let epsDictionaries = jsonDictionary["episodes"] as! [[String : Any]]
            for epsDictionary in epsDictionaries {
                let newEpisode = Episode(epsDictionary: epsDictionary)
                episodes.append(newEpisode)
            }
 
        }
 */
        
        return episodes
    }
}






















