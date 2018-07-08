//
//  EpisodesTableViewController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 07/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

struct news {
    let title : String!
    let content : String!
    let photo : String!
    let created_at : String!
}

var newsStruct = [news]()

class EpisodesTableViewController: UITableViewController, NVActivityIndicatorViewable
{
    private let image = UIImage(named: "cancel")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "News"
    private let bottomMessage = "Aucune news n'est pas disponible pour le moment."
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initTableView()
        self.tableView.reloadData()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        
        callAPI()
        //callAPIClassement()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    public func initTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setupEmptyBackgroundView()
        self.tableView.backgroundView?.isHidden = true
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = UIRefreshControl()
            self.tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        
        
    }
    
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.callAPI()
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
    // MARK: - Empty Data
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
        self.tableView.backgroundView?.isHidden = true
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return newsStruct.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Episode Cell", for: indexPath) as! EpisodeTableViewCell
        
        //Photo
        var logo = cell.viewWithTag(10) as! UIImageView
        if let photo = newsStruct[indexPath.row].photo {
            logo.loadImageUsingUrlString(urlString: photo)
        }
        else {
            logo.image = UIImage(named: EMPTY_LOGO_IMG)
        }
 
        
        //Tile
        let title = cell.viewWithTag(1) as! UILabel
        title.text = newsStruct[indexPath.row].title
        
        //Content
        let content = cell.viewWithTag(2) as! UILabel
        content.text = newsStruct[indexPath.row].content
        
        //Name  + heure
        let name_date = cell.viewWithTag(4) as! UILabel
        name_date.text = "Administrateur | March 28, 2016"
        
        
        return cell
    }
    
    func callAPI() {
        
        newsStruct = []
        
        /*
         loadDataClub()
         //CLASSEMENT ENDPOINT
         guard let leagueid = playerss![0].name?.description else {
         DispatchQueue.main.async() {
         //self.spinner.stopAnimating()
         self.tableView.reloadData()
         self.tableView.backgroundView?.isHidden = false
         }
         return
         }
         */
        
        //Loading
        DispatchQueue.main.async() {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 5))
            
        }
        
        let user_id = "42"
        let urlToRequest = addressUrlStringProd+newsUrlString+user_id
        
        Alamofire.request(urlToRequest, method: .get).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let newsArray = swiftyJsonVar["news"].arrayObject {
                    print(newsArray)
                        self.tableView.backgroundView?.isHidden = true
                        
                        for i in 0..<newsArray.count {
                            let title = swiftyJsonVar["news"][i]["title"].string
                            let content = swiftyJsonVar["news"][i]["content"].string
                            let photo = swiftyJsonVar["news"][i]["photo"].string
                            let created_at = swiftyJsonVar["news"][i]["created_at"].string
                            
                            newsStruct.append(news.init(title: title, content: content, photo: photo, created_at: created_at))

                        }
                    
                }
                print(newsStruct.count)
                if newsStruct.count > 0 {
                    DispatchQueue.main.async() {
                        self.stopAnimating()
                        self.tableView.reloadData()
                        self.tableView.backgroundView?.isHidden = true
                    }
                }
                else {
                    DispatchQueue.main.async() {
                        self.stopAnimating()
                        self.tableView.reloadData()
                        self.tableView.backgroundView?.isHidden = false
                    }
                }
            }
        }
    }
    
    func callAPIClassement() {

        
        var adressUrlClassementStringExterne = "https://apifootball.com/api/?action=get_standings&league_id=127&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        
        let user_id = "42"
        let urlToRequest = addressUrlStringProd+newsUrlString+user_id
        print(urlToRequest)
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                DispatchQueue.main.async() {
     
                    self.tableView.reloadData()
                    self.tableView.backgroundView?.isHidden = false
                }
                
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            //JSONSerialization in Object
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:Any]]
                DispatchQueue.main.async()
                    
                    {
                        if let nb = json?.count {
                            print(json)
                            self.tableView.backgroundView?.isHidden = true
                            
                            for i in 0..<nb {
                                if let team_name = json![i]["team_name"], let position_overall_league_position = json![i]["overall_league_position"], let points_overall_league_PTS = json![i]["overall_league_PTS"], let journee_overall_league_payed = json![i]["overall_league_payed"], let overall_league_V = json![i]["overall_league_W"], let overall_league_N = json![i]["overall_league_D"], let overall_league_D = json![i]["overall_league_L"], let overall_league_BM = json![i]["overall_league_GF"], let overall_league_BE = json![i]["overall_league_GA"]{
                                    
                                    let team_name = String(describing: team_name)
                                    let position_overall_league_position = String(describing: position_overall_league_position)
                                    let points_overall_league_PTS = String(describing: points_overall_league_PTS)
                                    let journee_overall_league_payed = String(describing: journee_overall_league_payed)
                                    let overall_league_V = String(describing: overall_league_V)
                                    let overall_league_N = String(describing: overall_league_N)
                                    let overall_league_D = String(describing: overall_league_D)
                                    let overall_league_BM = String(describing: overall_league_BM)
                                    let overall_league_BE = String(describing: overall_league_BE)
                                    
                                    
                                
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                }
                                
                         
                            }
                        }
                        else {
                            //ELSE
                            DispatchQueue.main.async() {
                                
                                self.tableView.reloadData()
                                self.tableView.backgroundView?.isHidden = false
                            }
                            
                            
                            
                        }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                
                self.tableView.reloadData()
                self.tableView.backgroundView?.isHidden = false
                
            }
        }
        ;task.resume()
    }
    
}


extension EpisodesTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "NEWS")
    }
}


















