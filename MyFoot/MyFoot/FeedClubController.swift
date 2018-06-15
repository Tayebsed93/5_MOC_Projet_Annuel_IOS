//
//  ResultMatch.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 14/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView

struct calendrierrr {
    let match_hometeam_name : String!
    let match_awayteam_name : String!
    let match_hometeam_score : String!
    let match_awayteam_score : String!
    let date : [NSDate]!
    let match_time : String!
    let league_name : String!
    
}

struct defaultsssKeys {
    static let league_id = "league_id"
    static let urlResult = "urlResult"
}

class FeedClubController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable {
    
    let defaults = UserDefaults.standard
    
    var passlogo = String()
    var league_id = String()
    var urlResult = String()
    var passnameclub = String()
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    private let image = UIImage(named: "cancel")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "Résultat"
    private let bottomMessage = "L'affichage des matchs n'est pas disponible pour votre club."
    
    public var adressUrlCountryStringExterne = "https://apifootball.com/api/?action=get_leagues&country_id=173&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
    
    var calendrierStruct = [calendrierrr]()
    
    
    
    
    override func viewDidLoad() {
        
        //Init de vue vide
        setupEmptyBackgroundView()
        
        callAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        //self.title = "Résultat des matchs"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
        //Remove persitante variable save
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
    }
    
    
    // MARK: - Empty Data
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.collectionViewOutlet.backgroundView = emptyBackgroundView
        self.collectionViewOutlet.backgroundView?.isHidden = true
        
    }
    
    //FIN
    @objc func buttonTapped(_ sender: UIButton) {
        let size = CGSize(width: 30, height: 30)
        
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return calendrierStruct.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //Club logo Exterieur
        var clubImageExterieur = cell.viewWithTag(3) as! UIImageView
        clubImageExterieur.image = UIImage(named: "pattern")
        
        
        //Nom club exterieur
        let match_awayteam_name = cell.viewWithTag(1) as! UILabel
        match_awayteam_name.text = "Material"
        
        let t = cell.viewWithTag(2) as! UILabel
        t.text = "Build beautiful Softaware"
        
        
        let d = cell.viewWithTag(4) as! UILabel
        d.text = "Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware Build beautiful Softaware "
        
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func callAPI() {
        
        let urlToRequest = adressUrlCountryStringExterne
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        //Loading
        DispatchQueue.main.async() {
            let size = CGSize(width: 90, height: 90)
            self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 5))
            
        }
        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            //JSONSerialization in Object
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:Any]]
                DispatchQueue.main.async()
                    
                    {
                        
                        if let nb = json?.count {
                            for i in 0..<nb {
                                if let league_id = json![i]["league_id"], let league_name = json![i]["league_name"] {
                                    let url = self.leagueIdURL(league_id: league_id)
                                    self.callAPITeam(urlTeam: url)
                                    
                                }
                                
                            }
                        }
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    func callAPITeam(urlTeam: String) {
        
        
        let urlToRequest = urlTeam
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
                
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            var trouver = false
            //JSONSerialization in Object
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:Any]]
                DispatchQueue.main.async()
                    
                    {
                        if let nb = json?.count {
                            for i in 0..<nb {
                                if let team_name = json![i]["team_name"], let league_name = json![i]["league_name"], let league_id = json![i]["league_id"] {
                                    
                                    let club = String(describing: team_name)
                                    
                                    if club == "Paris FC" {
                                        trouver = true
                                        let url = self.leagueIdURLToLiveMatch(dateDebut: DATE_DEBUT_SAISON, dateFin: DATE_FIN_SAISON)
                                        self.defaults.set(self.league_id, forKey: defaultsssKeys.league_id)
                                        self.defaults.set(self.urlResult, forKey: defaultsssKeys.urlResult)
                                        self.defaults.synchronize()
                                        
                                        
                                        self.callAPIResultat(urlResult: url)
                                        break
                                    }
                                    
                                }
                            }
                        }
                        
                        if trouver == false {
                            DispatchQueue.main.async()
                                {
                                    self.stopAnimating()
                                    self.collectionViewOutlet.backgroundView?.isHidden = false
                                    
                            }
                            
                        }
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    func callAPIResultat(urlResult: String) {
        
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
                
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            //JSONSerialization in Object
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:Any]]
                DispatchQueue.main.async()
                    
                    {
                        
                        if let nb = json?.count {
                            self.collectionViewOutlet.backgroundView?.isHidden = true
                            
                            for i in 0..<nb {
                                if let match_hometeam_name = json![i]["match_hometeam_name"], let match_awayteam_name = json![i]["match_awayteam_name"], let match_hometeam_score = json![i]["match_hometeam_score"], let match_awayteam_score = json![i]["match_awayteam_score"], let match_date = json![i]["match_date"], let match_time = json![i]["match_time"], let league_name = json![i]["league_name"] {
                                    
                                    let match_hometeam_name = String(describing: match_hometeam_name)
                                    let match_awayteam_name = String(describing: match_awayteam_name)
                                    let match_hometeam_score = String(describing: match_hometeam_score)
                                    let match_awayteam_score = String(describing: match_awayteam_score)
                                    let league_name = String(describing: league_name)
                                    let date = String(describing: match_date)
                                    let match_time = String(describing: match_time)
                                    
                                    if match_hometeam_name == "Paris FC" || match_awayteam_name == "Paris FC"  {
                                        let format = "yyyy-MM-dd"
                                        let date_nsdate = date.toDate(format: format)
                                        
                                        var date_array = [NSDate]()
                                        date_array.append(date_nsdate as! NSDate)
                                        
                                        //self.calendrierStruct = []
                                        self.calendrierStruct.append(calendrierrr.init(match_hometeam_name: match_hometeam_name, match_awayteam_name: match_awayteam_name, match_hometeam_score: match_hometeam_score, match_awayteam_score: match_awayteam_score, date: date_array, match_time: match_time, league_name: league_name))
                                        
                                        
                                    }
                                    
                                    self.collectionViewOutlet.reloadData()
                                    
                                    
                                }
                                
                                DispatchQueue.main.async() {
                                    self.stopAnimating()
                                }
                                
                                
                            }
                            
                            
                        }
                            
                        else {
                            //ELSE
                            self.collectionViewOutlet.reloadData()
                            self.collectionViewOutlet.backgroundView?.isHidden = false
                            
                            
                        }
                        
                        
                        
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                
            }
            
        }
        ;task.resume()
    }
    
    func leagueIdURL(league_id: Any) -> String {
        var url = String()
        let s = String(describing: league_id)
        url = "https://apifootball.com/api/?action=get_standings&league_id="+s+"&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        return url
    }
    
    func leagueIdURLToLiveMatch(dateDebut: String, dateFin: String) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        
        
        var url = String()
        let s = String(describing: self.league_id)
        url = "https://apifootball.com/api/?action=get_events&from="+dateDebut+"&to="+dateFin+"&league_id="+s+"&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        return url
    }
    

    
}



