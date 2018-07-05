//
//  ClassementController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

struct classement {
    var team_name : String!
    var position_overall_league_position : String!
    let points_overall_league_PTS : String!
    let journee_overall_league_payed : String!
    let overall_league_V: String!
    let overall_league_N: String!
    let overall_league_D: String!
    let overall_league_BM: String!
    let overall_league_BE: String!
}

class ClassementController: UITableViewController {
    
    
    var spinner = UIActivityIndicatorView()
    
    var classementsStruct = [classement]()
    
    var passlogo = String()
    var league_id = String()
    var urlResult = String()
    var passnameclub = String()
    
    private let image = UIImage(named: "cancel")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "Classement"
    private let bottomMessage = "L'affichage du classement n'est pas disponible pour votre club."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupEmptyBackgroundView()
        showActivityIndicatory()
        self.callAPIClassement()
        
        let headerNib = UINib.init(nibName: "ClassementHeaderView", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ClassementHeaderView")
    }
    
    
    // MARK: - Empty Data
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
        self.tableView.backgroundView?.isHidden = true
        
    }
    
    func showActivityIndicatory() {
        //self.spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinner.color = GREEN_THEME
        view.addSubview(spinner)
        spinner.startAnimating()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classementsStruct.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClassementHeaderView") as! ClassementHeaderView
        
 
        
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (indexPath.item % 2 == 0) {
            cell.backgroundColor = .white
  
        }
        else {
            cell.backgroundColor = GREY_CLASSEMENT
        }
        

        //Position
        let position = cell.viewWithTag(1) as! UILabel
        position.text = classementsStruct[indexPath.row].position_overall_league_position
        
        //Logo
        var logo = cell.viewWithTag(2) as! UIImageView
        if (classementsStruct[indexPath.row].team_name == self.passnameclub && passlogo != nil) {
            logo.loadImageUsingUrlString(urlString: self.passlogo)
        } else if let clublogo = UIImage(named: classementsStruct[indexPath.row].team_name) {
            logo.image = clublogo
        }
        else {
            logo.image = UIImage(named: EMPTY_LOGO_IMG)
        }
        
        //Nom Club
        let team_name = cell.viewWithTag(3) as! UILabel
        team_name.text = classementsStruct[indexPath.row].team_name
        
        //NB PTS
        let points_overall_league_PTS = cell.viewWithTag(4) as! UILabel
        points_overall_league_PTS.text = classementsStruct[indexPath.row].points_overall_league_PTS
        
        //JOURNEE
        let journee_overall_league_payed = cell.viewWithTag(5) as! UILabel
        journee_overall_league_payed.text = classementsStruct[indexPath.row].journee_overall_league_payed
        
        //Victoire
        let overall_league_V = cell.viewWithTag(6) as! UILabel
        overall_league_V.text = classementsStruct[indexPath.row].overall_league_V
        
        //NUL
        let overall_league_N = cell.viewWithTag(7) as! UILabel
        overall_league_N.text = classementsStruct[indexPath.row].overall_league_N
        
        //Defaite
        let overall_league_D = cell.viewWithTag(8) as! UILabel
        overall_league_D.text = classementsStruct[indexPath.row].overall_league_D
        
        //Difference
        let difference = cell.viewWithTag(9) as! UILabel
        let bm = Int(classementsStruct[indexPath.row].overall_league_BM)
        let be = Int(classementsStruct[indexPath.row].overall_league_BE)
        
        let diff = bm! - be!
        difference.text = String(diff)

        if (classementsStruct[indexPath.row].team_name == self.passnameclub) {
            cell.backgroundColor = GREEN_THEME
            position.textColor = .white
            position.font = UIFont.boldSystemFont(ofSize: 16.0)
            team_name.textColor = .white
            team_name.font = UIFont.boldSystemFont(ofSize: 16.0)
            points_overall_league_PTS.textColor = .white
            points_overall_league_PTS.font = UIFont.boldSystemFont(ofSize: 16.0)
            journee_overall_league_payed.textColor = .white
            journee_overall_league_payed.font = UIFont.boldSystemFont(ofSize: 16.0)
            overall_league_V.textColor = .white
            overall_league_V.font = UIFont.boldSystemFont(ofSize: 16.0)
            overall_league_N.textColor = .white
            overall_league_N.font = UIFont.boldSystemFont(ofSize: 16.0)
            overall_league_D.textColor = .white
            overall_league_D.font = UIFont.boldSystemFont(ofSize: 16.0)
            difference.textColor = .white
            difference.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        
        return cell
    }
    
    
    
    func callAPIClassement() {
        
        loadDataClub()
        //CLASSEMENT ENDPOINT
        guard let leagueid = playerss![0].name?.description else {
            DispatchQueue.main.async() {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                self.tableView.backgroundView?.isHidden = false
            }
            return
        }
        
        var adressUrlClassementStringExterne = "https://apifootball.com/api/?action=get_standings&league_id="+leagueid+"&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        
        let urlResult = adressUrlClassementStringExterne
        let urlToRequest = urlResult
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
                    self.spinner.stopAnimating()
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
                                    
                                    
                                    self.classementsStruct.append(classement.init(team_name: team_name,position_overall_league_position: position_overall_league_position, points_overall_league_PTS: points_overall_league_PTS, journee_overall_league_payed: journee_overall_league_payed, overall_league_V: overall_league_V, overall_league_N: overall_league_N, overall_league_D: overall_league_D, overall_league_BM: overall_league_BM, overall_league_BE: overall_league_BE))
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                }
                                
                                DispatchQueue.main.async() {
                                    self.spinner.stopAnimating()
                                }
                            }
                        }
                        else {
                            //ELSE
                            DispatchQueue.main.async() {
                                self.spinner.stopAnimating()
                                self.tableView.reloadData()
                                self.tableView.backgroundView?.isHidden = false
                            }
                            
                            
                            
                        }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                self.tableView.backgroundView?.isHidden = false
                
            }
        }
        ;task.resume()
    }
    
}

extension ClassementController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "CLASSEMENT")
    }
    
}

