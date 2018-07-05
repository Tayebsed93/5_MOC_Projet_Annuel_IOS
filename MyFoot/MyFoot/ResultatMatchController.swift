//
//  ResultatMatchController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 21/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import XLPagerTabStrip

struct calendrierr {
    let match_hometeam_name : String!
    let match_awayteam_name : String!
    let match_hometeam_score : String!
    let match_awayteam_score : String!
    let date : Date
    let match_time : String!
    let league_name : String!
    let match_id : String!
}

class ResultatMatchController: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableviewOutlet: UITableView!
    
    
    let defaults = UserDefaults.standard
    
    var passlogo = String()
    var league_id = String()
    var urlResult = String()
    var passnameclub = String()
    
    private let image = UIImage(named: "cancel")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "Résultat"
    private let bottomMessage = "L'affichage des matchs n'est pas disponible pour votre club."
    var calendrierStruct = [calendrierr]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        
        //tableviewOutlet.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        //tableviewOutlet.dataSource = self
        //tableviewOutlet.delegate = self
        
        //setupEmptyBackgroundView()
        
        //callAPI()
        let url = self.leagueIdURL(league_id: "127")
        self.callAPITeam127(urlTeam: url)
        /*
        if #available(iOS 10.0, *) {
            tableviewOutlet.refreshControl = UIRefreshControl()
            tableviewOutlet.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
 */
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        //self.title = "Résultat des matchs"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
        //Remove persitante variable save
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
    }
    
    public func initTableView() {
        
        print(tableviewOutlet)
        tableviewOutlet.dataSource = self
        tableviewOutlet.delegate = self
        
        tableviewOutlet.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        setupEmptyBackgroundView()
        
        if #available(iOS 10.0, *) {
            tableviewOutlet.refreshControl = UIRefreshControl()
            tableviewOutlet.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        
        
    }

    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableviewOutlet.refreshControl?.endRefreshing()
            }
            self?.tableviewOutlet.reloadData()
        })
    }
    
    // MARK: - Empty Data
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableviewOutlet.backgroundView = emptyBackgroundView
        self.tableviewOutlet.backgroundView?.isHidden = true
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendrierStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        //Club logo Domicile
        var clubImageDomicile = cell.viewWithTag(10) as! UIImageView
        
        if (calendrierStruct[indexPath.row].match_hometeam_name == self.passnameclub && passlogo != nil) {
            clubImageDomicile.loadImageUsingUrlString(urlString: self.passlogo)
        } else if let clublogo = UIImage(named: (calendrierStruct[indexPath.row].match_hometeam_name)!) {
            clubImageDomicile.image = clublogo
        }
        else {
            clubImageDomicile.image = UIImage(named: EMPTY_LOGO_IMG)
        }
        
        //Club logo Exterieur
        var clubImageExterieur = cell.viewWithTag(4) as! UIImageView
        
        if (calendrierStruct[indexPath.row].match_awayteam_name == self.passnameclub && passlogo != nil) {
            clubImageExterieur.loadImageUsingUrlString(urlString: self.passlogo)
        }  else if let clublogo = UIImage(named: (calendrierStruct[indexPath.row].match_awayteam_name)!) {
            clubImageExterieur.image = clublogo
        }
        else {
            clubImageExterieur.image = UIImage(named: EMPTY_LOGO_IMG)
        }
        
        //Nom club domicile
        let match_hometeam_name = cell.viewWithTag(1) as! UILabel
        match_hometeam_name.text = calendrierStruct[indexPath.row].match_hometeam_name
        
        //Nom club exterieur
        let match_awayteam_name = cell.viewWithTag(5) as! UILabel
        match_awayteam_name.text = calendrierStruct[indexPath.row].match_awayteam_name
        
        
        //Score/Heure du match label
        let home_score = calendrierStruct[indexPath.row].match_hometeam_score+"-"
        let away_score = calendrierStruct[indexPath.row].match_awayteam_score
        let string_score = home_score+away_score!
        
        var match_time = cell.viewWithTag(11) as! UILabel
        if calendrierStruct[indexPath.section].match_hometeam_score != "" {
            match_time.text = string_score } else {
            match_time.text = calendrierStruct[indexPath.section].match_time
        }
        
        
        //Ligue name
        let league_name = cell.viewWithTag(12) as! UILabel
        league_name.text = calendrierStruct[indexPath.row].league_name
        
        //Ligue name
        let date_name = cell.viewWithTag(16) as! UILabel
        var date = NSDate()
        date = calendrierStruct[indexPath.row].date as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr")
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
        let dateString = dateFormatter.string(from:date as Date)
        date_name.text = dateString
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMatchController") as? DetailMatchController {
            let home_score = calendrierStruct[indexPath.row].match_hometeam_score
            let away_score = calendrierStruct[indexPath.row].match_awayteam_score
            let home_name = calendrierStruct[indexPath.row].match_hometeam_name
            let away_name = calendrierStruct[indexPath.row].match_awayteam_name
            let match_id = calendrierStruct[indexPath.row].match_id
            viewController.homeTeam = home_name!
            viewController.awayTeam = away_name!
            viewController.homeScore = home_score!
            viewController.awayScore = away_score!
            viewController.match_id = match_id!
            //LOGO HOME
            if (calendrierStruct[indexPath.row].match_hometeam_name == self.passnameclub && passlogo != nil) {
                viewController.homeLogo = self.passlogo
            } else if let clublogo = UIImage(named: (calendrierStruct[indexPath.row].match_hometeam_name)!) {
                viewController.homeLogo = calendrierStruct[indexPath.row].match_hometeam_name
            }
            else {
                viewController.homeLogo = EMPTY_LOGO_IMG
            }
            //LOGO AWAY
            
            if (calendrierStruct[indexPath.row].match_awayteam_name == self.passnameclub && passlogo != nil) {
                viewController.awayLogo = self.passlogo
            }  else if let clublogo = UIImage(named: (calendrierStruct[indexPath.row].match_awayteam_name)!) {
                viewController.awayLogo = calendrierStruct[indexPath.row].match_awayteam_name
            }
            else {
                viewController.awayLogo = EMPTY_LOGO_IMG
            }
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
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
                                    //self.callAPITeam(urlTeam: url)
                                    
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
    
    func callAPITeam127(urlTeam: String) {
        
        
        let urlToRequest = urlTeam
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
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
            
            var trouver = false
            var trouverleague = false
            //JSONSerialization in Object
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:Any]]
                DispatchQueue.main.async()
                    
                    {
                        if let nb = json?.count {
                            for i in 0..<nb {
                                if let team_name = json![i]["team_name"], let league_name = json![i]["league_name"], let league_id = json![i]["league_id"] {
                                    
                                    let club = String(describing: team_name)
                                    
                                    if club == self.passnameclub {
                                        trouver = true
                                        //self.defaults.set(league_id, forKey: defaultsssKeys.league_id)
                                        //self.defaults.set(team_name, forKey: defaultsssKeys.team_name)
                                        //self.defaults.synchronize()
                                        setupDataClub(_name: league_id as! String, _club: team_name as! String)
                                        let url = self.leagueIdURLToLiveMatch(dateDebut: DATE_DEBUT_SAISON, dateFin: DATE_FIN_SAISON)
                    
                                        self.callAPIResultat(urlResult: url)
                                        break
                                    }
                                    
                                }
                            }
                        }
                        
                        if trouver == false {
                            DispatchQueue.main.async()
                                {
                                    //self.stopAnimating()
                                    //self.tableviewOutlet.backgroundView?.isHidden = false
                                    let url = self.leagueIdURL(league_id: "128")
                                    self.callAPITeam128(urlTeam: url)
                          
                            }
                            
                        }
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    func callAPITeam128(urlTeam: String) {
        
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
                                    
                                    if club == self.passnameclub {
                                        trouver = true
                                        //self.defaults.set(league_id, forKey: defaultsssKeys.league_id)
                                        //self.defaults.set(team_name, forKey: defaultsssKeys.team_name)
                                        //self.defaults.synchronize()
                                        setupDataClub(_name: league_id as! String, _club: team_name as! String)
                                        let url = self.leagueIdURLToLiveMatch(dateDebut: DATE_DEBUT_SAISON, dateFin: DATE_FIN_SAISON)
                                        //self.defaults.set(self.urlResult, forKey: defaultsssKeys.urlResult)
                                        
                                        
                                        
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
                                    self.tableviewOutlet.backgroundView?.isHidden = false
                                    
                                    
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
        print(urlResult)
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
                            self.tableviewOutlet.backgroundView?.isHidden = true
                            
                            for i in 0..<nb {
                                if let match_hometeam_name = json![i]["match_hometeam_name"], let match_awayteam_name = json![i]["match_awayteam_name"], let match_hometeam_score = json![i]["match_hometeam_score"], let match_awayteam_score = json![i]["match_awayteam_score"], let match_date = json![i]["match_date"], let match_time = json![i]["match_time"], let league_name = json![i]["league_name"], let match_id = json![i]["match_id"]{
                                    
                                    let match_hometeam_name = String(describing: match_hometeam_name)
                                    let match_awayteam_name = String(describing: match_awayteam_name)
                                    let match_hometeam_score = String(describing: match_hometeam_score)
                                    let match_awayteam_score = String(describing: match_awayteam_score)
                                    let league_name = String(describing: league_name)
                                    let date = String(describing: match_date)
                                    let match_time = String(describing: match_time)
                                    let match_id = String(describing: match_id)
                                    
                                    if match_hometeam_name == self.passnameclub || match_awayteam_name == self.passnameclub  {
                                        let format = "yyyy-MM-dd"
                                        let date_nsdate = date.toDate(format: format)
                                        
                                        //self.calendrierStruct = []
                                        self.calendrierStruct.append(calendrierr.init(match_hometeam_name: match_hometeam_name, match_awayteam_name: match_awayteam_name, match_hometeam_score: match_hometeam_score, match_awayteam_score: match_awayteam_score, date: date_nsdate!, match_time: match_time, league_name: league_name, match_id: match_id))
                                        
                                        
                                        
                                        
                                    }
                                    
                                    self.tableviewOutlet.reloadData()
                                    
                                    
                                }
                                
                                DispatchQueue.main.async() {
                                    self.stopAnimating()
                                }
                            }
                        }
                        else {
                            //ELSE
                            self.tableviewOutlet.reloadData()
                            self.tableviewOutlet.backgroundView?.isHidden = false
                            
                            
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
        loadDataClub()
        
        // Do any additional setup after loading the view, typically from a nib.
        let leagueid = playerss![0].name?.description

        //let leagueid = defaults.string(forKey: defaultsssKeys.league_id)!
        let s = String(describing: leagueid!)
        url = "https://apifootball.com/api/?action=get_events&from="+dateDebut+"&to="+dateFin+"&league_id="+s+"&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        
        print(url)
        return url
    }
 
    @IBAction func DeconnexionClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DateClick(_ sender: Any) {
        if let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePopUpViewController") as? DatePopUpViewController {
            popup.showTimePicker = true
            popup.delegate = self as! PopupDelegate
            self.present(popup, animated: true)
            
        }
    }
    
}

extension ResultatMatchController: PopupDelegate {
    func popupValueSelected(value: String) {
        let url = self.leagueIdURLToLiveMatch(dateDebut: value, dateFin: value)
        self.calendrierStruct = []
        self.callAPIResultat(urlResult: url)
    }
}

extension ResultatMatchController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RESULTAT")
    }
    
}

