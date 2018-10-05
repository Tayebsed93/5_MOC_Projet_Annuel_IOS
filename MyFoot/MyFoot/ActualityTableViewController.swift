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
    let id : Int!
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
    
    var passeapikey = String()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initTableView()
        self.tableView.reloadData()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        
        callAPI()
        
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
        
        let date_string = newsMembreStruct[indexPath.row].created_at
        let format = "yyyy-MM-dd HH:mm:ss"
        let date_nsdate = date_string?.toDate(format: format)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr")
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
        let dateString = dateFormatter.string(from: date_nsdate!)
        
        let date = "Administrateur | " + dateString
        name_date.text = date
        
        
        return cell
    }
    
    func callAPI() {
        newsMembreStruct = []
        
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
        
        let urlToRequest = addressUrlStringProd+newsUrlString+user_id
        
        Alamofire.request(urlToRequest, method: .get).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let newsArray = swiftyJsonVar["news"].arrayObject {
                    self.tableView.backgroundView?.isHidden = true
                    for i in 0..<newsArray.count {
                        let id = swiftyJsonVar["news"][i]["id"].int
                        let title = swiftyJsonVar["news"][i]["title"].string
                        let content = swiftyJsonVar["news"][i]["content"].string
                        let photo = swiftyJsonVar["news"][i]["photo"].string
                        let created_at = swiftyJsonVar["news"][i]["created_at"].string
                        
                        newsMembreStruct.append(newsMembre.init(id: id, title: title, content: content, photo: photo, created_at: created_at))
                        
                    }
                    
                }
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
    
    
    func callAPIDelete(user_id: Int) {
        
        //Loading
        DispatchQueue.main.async() {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 5))
            
        }
        
        let x:String = String(describing: user_id)
        let urlToRequest = addressUrlStringProd+newsUrlString+x
        
        var urlRequest = URLRequest(url: URL(string: addressUrlStringProd+newsUrlString+x)!)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        urlRequest = try! URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.setValue(passeapikey, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = newsMembreStruct[indexPath.row].id
            
            // create the alert
            let alert = UIAlertController(title: "Confirmation", message: "Voulez-vous supprimer l'actualité ?", preferredStyle: UIAlertControllerStyle.alert)
            
            print("Deleted")
            // add the actions (buttons)
            
            alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.destructive, handler: { action in
                
            }))
            
            alert.addAction(UIAlertAction(title: "Oui", style: UIAlertActionStyle.default, handler: { action in
                self.callAPIDelete(user_id: id!)
                newsMembreStruct.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
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
                
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
    }
    
    @IBAction func AddActuality(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddActualityController") as? AddActualityController {
            //viewController.name = namePresident.text!
            viewController.passeapikey = passeapikey
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
}


extension ActualityTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "NEWS")
    }
}



















