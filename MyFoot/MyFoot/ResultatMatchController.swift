//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView


struct calendrier {
    let match_hometeam_name : String!
    let match_awayteam_name : String!
    let match_hometeam_score : String!
    let match_awayteam_score : String!
    let date : [NSDate]!
    let match_time : String!
    let league_name : String!
    
}

protocol MyProtocol: class {
    func sendData(date: String)
}



class ResultatMatchController: UITableViewController, MyProtocol, NVActivityIndicatorViewable {



    var passnameclub = String()
    var passlogo = String()
    var spinner = UIActivityIndicatorView()
    
public var adressUrlCountryStringExterne = "https://apifootball.com/api/?action=get_leagues&country_id=173&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"

    var date: String?
    func sendData(date: String) {
        self.date = date
        print(date)
    }

    var calendrierStruct = [calendrier]()
    
    
    @IBOutlet var outlet_table: UITableView!
    
    private let image = UIImage(named: "cancel")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "Résultat"
    private let bottomMessage = "L'affichage des matchs n'est pas disponible pour votre club."
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = .none
        
        //Init de vue vide
        setupEmptyBackgroundView()
        //Recuperer Donnée de la BDD
        if (calendrierStruct.count <= 0) {
            callAPI()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        //self.title = "Résultat des matchs"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
    }

    // MARK: - Empty Data
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        tableView.backgroundView = emptyBackgroundView
        self.tableView.backgroundView?.isHidden = true
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        //Club logo Domicile
        var clubImageDomicile = cell?.viewWithTag(10) as! UIImageView

        if (calendrierStruct[indexPath.section].match_hometeam_name == self.passnameclub && passlogo != nil) {
            clubImageDomicile.loadImageUsingUrlString(urlString: self.passlogo)
        } else {
        clubImageDomicile.image = UIImage(named: EMPTY_LOGO_IMG)
        }
        
        //Club logo Exterieur
        var clubImageExterieur = cell?.viewWithTag(4) as! UIImageView
        
        if (calendrierStruct[indexPath.section].match_awayteam_name == self.passnameclub && passlogo != nil) {
            clubImageExterieur.loadImageUsingUrlString(urlString: self.passlogo)
        } else {
            clubImageExterieur.image = UIImage(named: EMPTY_LOGO_IMG)
        }
 
        //Nom club domicile
        let match_hometeam_name = cell?.viewWithTag(1) as! UILabel
        match_hometeam_name.text = calendrierStruct[indexPath.section].match_hometeam_name
        
        //Nom club exterieur
        let match_awayteam_name = cell?.viewWithTag(5) as! UILabel
        match_awayteam_name.text = calendrierStruct[indexPath.section].match_awayteam_name
        
        
        //Score/Heure du match label
        let home_score = calendrierStruct[indexPath.section].match_hometeam_score+"-"
        let away_score = calendrierStruct[indexPath.section].match_awayteam_score
        let string_score = home_score+away_score!
        var match_time = cell?.viewWithTag(11) as! UILabel
        if calendrierStruct[indexPath.section].match_hometeam_score != "" {
            match_time.text = string_score } else {
            match_time.text = calendrierStruct[indexPath.section].match_time
        }

        //Ligue name
        let league_name = cell?.viewWithTag(12) as! UILabel
        league_name.text = calendrierStruct[indexPath.section].league_name
        
        //Date match
        let date_match = cell?.viewWithTag(13) as! UILabel
        for date_m in calendrierStruct[indexPath.section].date {
            date_match.text = date_m.getDateName()
        }

        
        return cell!
  
    }
    
    
    //HEADER
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return calendrierStruct.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return calendrierStruct[section].date.count
        
        
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let ok = calendrierStruct[section].date
        
        for number in ok! {
            
            return number.getMonthName()
        }
        
        return "Match"

    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    //FIN HEADER

    
    
    
    @IBAction func DeconnexionClick(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateClubController") as? CreateClubController {
            /*
             viewController.nationality = self.nationality
             viewController.isPlayer = false
             viewController.curentName = self.curentName
             viewController.curentTag = self.curentTag
             */
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
                
                self.alerteMessage(message: (error?.localizedDescription)!)
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
                
                self.alerteMessage(message: (error?.localizedDescription)!)
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
                                    print(team_name)
                                    let club = String(describing: team_name)
                                    
                                    if club == self.passnameclub {
                                        print("OK")
                                        trouver = true
                                        let url = self.leagueIdURLToLiveMatch(league_id: league_id)
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
                                self.tableView.backgroundView?.isHidden = false
   
                            }
                            print("FIN")
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
                
                self.alerteMessage(message: (error?.localizedDescription)!)
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
                                if let match_hometeam_name = json![i]["match_hometeam_name"], let match_awayteam_name = json![i]["match_awayteam_name"], let match_hometeam_score = json![i]["match_hometeam_score"], let match_awayteam_score = json![i]["match_awayteam_score"], let match_date = json![i]["match_date"], let match_time = json![i]["match_time"], let league_name = json![i]["league_name"] {

                                    let match_hometeam_name = String(describing: match_hometeam_name)
                                    let match_awayteam_name = String(describing: match_awayteam_name)
                                    let match_hometeam_score = String(describing: match_hometeam_score)
                                    let match_awayteam_score = String(describing: match_awayteam_score)
                                    let league_name = String(describing: league_name)
                                    let date = String(describing: match_date)
                                    let match_time = String(describing: match_time)
                                    if match_hometeam_name == self.passnameclub || match_awayteam_name == self.passnameclub  {
                                        let format = "yyyy-MM-dd"
                                        let date_nsdate = date.toDate(format: format)
                                        
                                        var date_array = [NSDate]()
                                        date_array.append(date_nsdate as! NSDate)
                                        
                       
                                        
                                        self.calendrierStruct.append(calendrier.init(match_hometeam_name: match_hometeam_name, match_awayteam_name: match_awayteam_name, match_hometeam_score: match_hometeam_score, match_awayteam_score: match_awayteam_score, date: date_array, match_time: match_time, league_name: league_name))
                                        
                                        
                                        
                                
                                        
                                    }
                                    self.tableView.reloadData()
                                }
                                
                                DispatchQueue.main.async() {
                                    self.stopAnimating()
                                }
                            }
                        }
                        
                       
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                DispatchQueue.main.async()
                    {
                        self.stopAnimating()
                    }
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
    
    func leagueIdURLToLiveMatch(league_id: Any) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)

        
        
        var url = String()
        let s = String(describing: league_id)
        url = "https://apifootball.com/api/?action=get_events&from="+DATE_DEBUT_SAISON+"&to="+DATE_FIN_SAISON+"&league_id="+s+"&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        return url
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
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        let name = classementStruct[(indexPath?.row)!].name
        
        let alertController = UIAlertController(title: name, message: "Selectionner votre rôle", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Supporter", style: .default) { (action) in
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVc = storyboard.instantiateViewController(withIdentifier: "tbController") as! UITabBarController
            
            ///////// 1er controller
            //Convertie la tabViewController en UINavigationController
            let navigation = tabVc.viewControllers?[0] as! UINavigationController
            
            //Convertie la UINavigationController en UIViewController (Home)
            let homeController = navigation.topViewController as? HomeController
            
            //Change la page vers Home
            self.present(tabVc, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Acteur interne", style: .default) { (action) in
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? LoginController {
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        }
        let action3 = UIAlertAction(title: "Annuler", style: .cancel) { (action) in
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
 */
    
    @IBAction func DeconnexionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
