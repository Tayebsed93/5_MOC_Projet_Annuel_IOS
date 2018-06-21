//
//  FeedActualityController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 17/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import FoldingCell
import Alamofire
import SwiftyJSON
import UIKit

class FeedActualityController: UITableViewController {
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    var feedsStruct = [feed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        getTweetsArray(searchPhrase: "PSG"){status,tweetsArray,error in
            if status{
                
                for tweet in tweetsArray!{
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension FeedActualityController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as CellFeed = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        if feedsStruct.count > indexPath.row + 1 {
            cell.number = indexPath.row
            cell.test = "LOOOL"
            print(indexPath.row)
            
            if let profileImage = feedsStruct[indexPath.row].imageDesc {
                cell.imagePost = profileImage
            }
        }

 
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
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
}
