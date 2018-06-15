//
//  TweeterFeedController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 09/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import ActiveLabel

struct feed {
    var text : String!
    let screen_name : String!
    let name : String!
    let imageProfile: String!
    let imageDesc: String!
    let created: Date
}

class TweeterFeedController: UITableViewController {

    
    var feedsStruct = [feed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNavigationBarItems()
        
        getTweetsArray(searchPhrase: "#psg"){status,tweetsArray,error in
            if status{
                
                for tweet in tweetsArray!{
                    //print("\(tweet)\n")
                    
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (feedsStruct.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        let labelName = cell?.viewWithTag(2) as! UILabel
        labelName.text = feedsStruct[indexPath.row].name
        
        
        
        let labelScreenName = cell?.viewWithTag(6) as! UILabel

            let formatter = DateFormatter()
            if Date().timeIntervalSince(feedsStruct[indexPath.row].created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            let createdText = formatter.string(from: feedsStruct[indexPath.row].created)
            labelScreenName.text = "@" + feedsStruct[indexPath.row].screen_name + " • " + createdText
       
        
        
            let labelText = cell?.viewWithTag(5) as! UILabel
            labelText.text = feedsStruct[indexPath.row].text
        
        
        let profileImageURL = cell?.viewWithTag(4) as! UIImageView
                    if let profileImage = feedsStruct[indexPath.row].imageProfile {
                        profileImageURL.loadImageUsingUrlString(urlString: profileImage)
                        profileImageURL.roundedCorners()
                    }
                    else {
                        profileImageURL.image = nil
                    }
        
        
        
        var mediaImageURL = cell?.viewWithTag(1) as! UIImageView
        
        if let mediaImage = feedsStruct[indexPath.row].imageDesc {
            if mediaImage != "vide" {
                mediaImageURL.isHidden = false
                mediaImageURL.loadImageUsingUrlString(urlString: mediaImage)
                mediaImageURL.roundedCorners()
                
            }
            else {
                mediaImageURL.isHidden = true
            }
            
        }
        else {
            mediaImageURL.image = nil
            mediaImageURL.isHidden = true
        }
        return cell!
    }

    private var defaultTweetImageViewHeightConstraint: CGFloat!
    
    
    public func getTweetsArray(searchPhrase: String, completion: @escaping ((Bool, [String]?, String?)->Void)){
        
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=" + searchPhrase + "&result_type=popular&count=100"
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(url!, headers: ["Authorization":"Bearer AAAAAAAAAAAAAAAAAAAAABjczAAAAAAAmpsyum03hAwA3jfPdbcpIrWLwXY%3Dg5wRYqAQUdGvCiPYoWV6vAsJ5ELWctM37PDkaAFXeX1NOFgn8Y"])
            .responseJSON { (response) in
                if response.result.isSuccess{
                    DispatchQueue.main.async { [unowned self] in
                        let json = JSON(response.result.value)
                        //print(json)
                        
                        let tweetsArray = json["statuses"].arrayValue
                        
                        var result = [String]()
                        var image = [String]()
                        for statuses in tweetsArray{
                            /*
                            let namesArray = statuses["entities"]["user_mentions"].arrayValue
                            let user = statuses["user"].dictionary
                            
                            guard let retweeted_status = statuses["retweeted_status"].dictionary else { return }
                            let created = retweeted_status["created_at"]?.description
                            let date = self.twitterDateFormatter(dateString: created!)
                            print(retweeted_status["user"]!["profile_image_url"].description)
                            
                            //for name in namesArray{
                            
                            self.feedsStruct.append(feed.init(text: retweeted_status["text"]?.description, screen_name: retweeted_status["user"]!["screen_name"].description, name: retweeted_status["user"]!["name"].description, imageProfile: retweeted_status["user"]!["profile_image_url"].description, created: date))
                            
                            print(self.feedsStruct.count)
                            self.tableView.reloadData()
                            
                            */
                            //}
                            
                            let text = statuses["text"].description
                            
                            let screen_name = statuses["user"]["screen_name"].description
                            let name = statuses["user"]["name"].description
                            let imageProfile = statuses["user"]["profile_image_url"].description
                            let created = statuses["created_at"].description
                            let date = self.twitterDateFormatter(dateString: created)
                        
                            let urlsArray = statuses["urls"].description
                            
                            var imageDesc: String
                            

                            if let namesArray = statuses["entities"]["media"].array {
                                for media in namesArray{
                                    let imageDesc = media["media_url"].debugDescription
                                    self.feedsStruct.append(feed.init(text: text, screen_name: screen_name, name: name, imageProfile: imageProfile, imageDesc: imageDesc, created: date))
                                }
                            }
                            else {
                                self.feedsStruct.append(feed.init(text: text, screen_name: screen_name, name: name, imageProfile: imageProfile, imageDesc: "vide", created: date))
                            }
                            
                            
                          

                            self.tableView.reloadData()
                        }
                        
                        completion(true, result, nil)
                    }
                }

                
                else{
                    completion(false, nil, "error")
                }
        }
    }
    
    func twitterDateFormatter(dateString : String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
    let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func alerteMessage(message : String) {
        
        var newMessage = ""
        if (message == "Could not connect to the server." ) {
            newMessage = "Impossible de se connecter au serveur."
            
            let alert = UIAlertController(title: "Erreur", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    

// TAB BAR
func setupNavigationBarItems() {
    //setupLeftNavItem()
    //setupRightNavItems()
    setupRemainingNavItems()
}

private func setupRemainingNavItems() {
    let titleImageView = UIImageView(image: #imageLiteral(resourceName: "title_icon"))
    titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    titleImageView.contentMode = .scaleAspectFit
    
    navigationItem.titleView = titleImageView
    
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.isTranslucent = false
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    
    let navBarSeparatorView = UIView()
    navBarSeparatorView.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
    view.addSubview(navBarSeparatorView)
    navBarSeparatorView.anchors(top: view.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, height: 0, width: 0.5)
}

private func setupLeftNavItem() {
    let followButton = UIButton(type: .system)
    followButton.setImage(#imageLiteral(resourceName: "follow").withRenderingMode(.alwaysOriginal), for: .normal)
    followButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: followButton)
}

private func setupRightNavItems() {
    let searchButton = UIButton(type: .system)
    searchButton.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
    searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    
    let composeButton = UIButton(type: .system)
    composeButton.setImage(#imageLiteral(resourceName: "compose").withRenderingMode(.alwaysOriginal), for: .normal)
    composeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    
    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: composeButton), UIBarButtonItem(customView: searchButton)]
    }
    
    struct TwitterKey {
        static let count = "count"
        static let query = "q"
        static let tweets = "statuses"
        static let resultType = "result_type"
        static let resultTypeRecent = "recent"
        static let resultTypePopular = "popular"
        static let geocode = "geocode"
        static let searchForTweets = "search/tweets"
        static let maxID = "max_id"
        static let sinceID = "since_id"
        struct SearchMetadata {
            static let maxID = "search_metadata.max_id_str"
            static let nextResults = "search_metadata.next_results"
            static let separator = "&"
        }
    }
}

private extension UIView
{
    func roundedCorners() {
        self.layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
}
