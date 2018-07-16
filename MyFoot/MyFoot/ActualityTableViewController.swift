//
//  ActualityTableViewController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 11/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

struct newsMembre {
    let title : String!
    let content : String!
    let photo : String!
    let created_at : String!
}

var newsMembreStruct = [newsMembre]()

class ActualityTableViewController: UITableViewController, NVActivityIndicatorViewable
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
        return newsMembreStruct.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Episode Cell", for: indexPath) as! EpisodeTableViewCell
        
        //Photo
        var logo = cell.viewWithTag(10) as! UIImageView
        if let photo = newsMembreStruct[indexPath.row].photo {
            logo.loadImageUsingUrlString(urlString: photo)
        }
        else {
            logo.image = UIImage(named: EMPTY_LOGO_IMG)
        }
        
        
        //Tile
        let title = cell.viewWithTag(1) as! UILabel
        title.text = newsMembreStruct[indexPath.row].title
        
        //Content
        let content = cell.viewWithTag(2) as! UILabel
        content.text = newsMembreStruct[indexPath.row].content
        
        //Name  + heure
        let name_date = cell.viewWithTag(4) as! UILabel
        name_date.text = "Administrateur | March 28, 2016"
        
        
        return cell
    }
    
    func callAPI() {
        
        newsMembreStruct = []
        
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
        
        loadDataUser()
        guard let user_id = score![0].name?.description else {
            DispatchQueue.main.async() {
                self.stopAnimating()
                self.tableView.reloadData()
                self.tableView.backgroundView?.isHidden = false
            }
            return
        }
        
        print(user_id)
        
        let urlToRequest = addressUrlStringProd+newsUrlString+user_id
        
        Alamofire.request(urlToRequest, method: .get).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let newsArray = swiftyJsonVar["news"].arrayObject {
                    self.tableView.backgroundView?.isHidden = true
                    
                    for i in 0..<newsArray.count {
                        let title = swiftyJsonVar["news"][i]["title"].string
                        let content = swiftyJsonVar["news"][i]["content"].string
                        let photo = swiftyJsonVar["news"][i]["photo"].string
                        let created_at = swiftyJsonVar["news"][i]["created_at"].string
                        
                        newsMembreStruct.append(newsMembre.init(title: title, content: content, photo: photo, created_at: created_at))
                        
                    }
                    
                }
                print(newsMembreStruct.count)
                if newsMembreStruct.count > 0 {
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
}


extension ActualityTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "NEWS")
    }
}



















