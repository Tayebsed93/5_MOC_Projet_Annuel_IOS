//
//  HomeController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 13/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import FacebookCore
import FBSDKCoreKit
import NVActivityIndicatorView
import SwiftyJSON


struct competitions {
    let composition_name : String!
    let groupe : String!
    let match_away : String!
    var match_home : String!
    let time_start : String!
    let competitions_id : Int!
    var user_id : Int!
}

struct checkcompetitions {
    let groupe : String!
    let match_away : String!
    let match_home : String!
    let competitions_id : Int!

}


struct userid {
    let user_id : Int!
    let competitions_id : Int!
    
}

class HomeController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate, ChildNameDelegate, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var tableviewOutlet: UITableView!
    
    
    var competitionsStruct = [competitions]()
    var checkCompetitionsStruct = [checkcompetitions]()
    var useridStruct = [userid]()
    
    
    var u_id = Int()
    var c_id = Int()
    
    var apikey = String()
    public func initTableView() {
        
        tableviewOutlet.dataSource = self
        tableviewOutlet.delegate = self
        
        //tableviewOutlet.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        
        if #available(iOS 10.0, *) {
            tableviewOutlet.refreshControl = UIRefreshControl()
            tableviewOutlet.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
   
    }
    
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.callAPI()
                self?.tableviewOutlet.refreshControl?.endRefreshing()
            }
            self?.tableviewOutlet.reloadData()
        })
    }
    
    func dataChanged(email: String, password: String, apikey: String) {
        setupDataFacebookUser(_apikey: apikey)
        //defaults.set(apikey, forKey: defaultsKeys.key11)
        //defaults.synchronize()
        
    }
    
    @IBOutlet weak var France: UIImageView!
    @IBOutlet weak var Germany: UIImageView!
    @IBOutlet weak var Italy: UIImageView!
    
    @IBOutlet weak var btnFrance: UIButton!
    @IBOutlet weak var btnGermany: UIButton!
    @IBOutlet weak var btnItaly: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    

    
    var nationality = String()
    var match_date = String()
    
    var passapikey = String()

    var isPlayer = Bool()
    
    var nation = [String]()
    var loginFB = String()
    var passwordFB = String()
    struct defaultsKeys {
        static let key11 = "11"
        
    }
    
    var change = [Bool]()
    
    let transition = CircularTransition()
    
    @IBOutlet weak var anneeText: UITextField!
    let button = UIButton(type: UIButtonType.custom)
    @IBOutlet weak var containerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        tableviewOutlet.separatorColor = UIColor(white: 0.95, alpha: 1)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        facebookButton.layer.cornerRadius = facebookButton.frame.size.width / 2
        facebookButton.backgroundColor = FACEBOOK_COLOR_BLUE
        
        self.isPlayer = true
        initTableView()
        callAPI()
        
        //if the user is already logged in
        if let accessToken = AccessToken.current{
            print("User is logged in Facebook")
        }
        else {
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            clearDataFacebookUser()
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let facebookVC = segue.destination as! FacebookLoginViewController
        facebookVC.transitioningDelegate = self
        facebookVC.modalPresentationStyle = .custom
        facebookVC.instanceOfVCA = self
        facebookVC.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alerteMessage(message : String) {
        
        var newMessage = ""
        if (message == "Could not connect to the server." ) {
            newMessage = "Impossible de se connecter au serveur."
            
            let alert = UIAlertController(title: "Erreur", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (message == "Access Denied. Invalid Api key" ) {
            newMessage = "Pour pouvoir jouer à ce jeu, veuillez vous authentifier avec Facebook."
            
            let alert = UIAlertController(title: "Informations", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func callAPI() {
        
        self.competitionsStruct = []
        self.useridStruct = []
        self.change = []
        //Loading
        DispatchQueue.main.async() {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 5))
            
        }
        
        
        loadDataFacebookUser()
        if (fbuser?.count)! > 0 {
            apikey = (fbuser![0].apikey?.description)!
        }
        else {
           apikey = "0"
        }

        
        let urlToRequest = addressUrlStringProd+competitionUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.addValue(apikey, forHTTPHeaderField: "Authorization")
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
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        
                        if let competitions_array = json["competitions"] as? [[String: Any]] {
                            self.tableviewOutlet.backgroundView?.isHidden = true
                            
                            
                            for competitionjson in competitions_array {
                                let composition_name = competitionjson["competition_name"]
                                let groupe = competitionjson["groupe"]
                                let match_away = competitionjson["match_away"]
                                let match_home = competitionjson["match_home"]
                                let time_start = competitionjson["time_start"]
                                let competition_id = competitionjson["id"]
                                let user_id = competitionjson["user_id"] as! Int
                                
                                if user_id > 0 {
                                    self.useridStruct.append(userid.init(user_id: user_id, competitions_id: competition_id as! Int))
                                    
                                }
                                else {
                                    self.competitionsStruct.append(competitions.init(composition_name: composition_name as! String, groupe: groupe as! String, match_away: match_away as! String, match_home: match_home as! String, time_start: time_start as! String, competitions_id: competition_id as! Int, user_id: user_id as! Int))
                                    
                                    self.change.append(false)
                                }
                                
                                self.tableviewOutlet.reloadData()
                            }
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            if self.competitionsStruct.count > 0 {
                DispatchQueue.main.async() {
                    self.stopAnimating()
                    self.tableviewOutlet.reloadData()
                    self.tableviewOutlet.backgroundView?.isHidden = true
                }
            }
            else {
                DispatchQueue.main.async() {
                    self.stopAnimating()
                    self.tableviewOutlet.reloadData()
                    self.tableviewOutlet.backgroundView?.isHidden = false
                }
            }
            
        }
        ;task.resume()
    }
    
    
    func callCheckCompoAPI() {
        
        var apikey = String()
        loadDataClub()
        
        // Do any additional setup after loading the view, typically from a nib.
        if apikey != fbuser![0].apikey?.description {
            apikey = "0"
        }
        
        let urlToRequest = addressUrlStringProd+checkcompetitionUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.addValue(apikey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                
                //self.alerteMessage(message: (error?.localizedDescription)!)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            //JSONSerialization in Object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        
                        if let clubs = json["competitions"] as? [[String: Any]] {
                            
                            for playerjson in clubs {
                                if let groupe = playerjson["groupe"], let match_away = playerjson["match_away"], let match_home = playerjson["match_home"], let time_start = playerjson["time_start"], let competition_id = playerjson["id"]{
                                    
                                    self.checkCompetitionsStruct.append(checkcompetitions.init(groupe: groupe as! String, match_away: match_away as! String, match_home: match_home as! String, competitions_id: competition_id as! Int))
                                    
                                }
                                
                                self.tableviewOutlet.reloadData()
                            }
                            
                            if let messageError = json["message"]
                            {
                                //self.alerteMessage(message: messageError as! String)
                            }
                            
                            
                            
                        }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.competitionsStruct.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeController", for: indexPath)
        cell.selectionStyle = .none
        if useridStruct.count > 0 {
            for ok in useridStruct {
                
                //Status
                let status_match = cell.viewWithTag(12) as! UIButton
                status_match.isEnabled = false
                
                if competitionsStruct[indexPath.row].competitions_id == ok.competitions_id {
                    //Bouton pour jouer
                    let start_game = cell.viewWithTag(13) as! UIButton
                    start_game.backgroundColor = FACEBOOK_COLOR_BLUE
                    start_game.isEnabled = false
                    change[indexPath.row] = true
                    
                }
                else if competitionsStruct[indexPath.row].competitions_id != ok.competitions_id && change[indexPath.row] == false {
                    //Bouton pour jouer
                    let start_game = cell.viewWithTag(13) as! UIButton
                    start_game.backgroundColor = FACEBOOK_COLOR_BLUE
                    start_game.isEnabled = true
                    start_game.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
                }
                
                
                //Nom pays domicile
                let match_hometeam_name = cell.viewWithTag(1) as! UILabel
                match_hometeam_name.text = competitionsStruct[indexPath.row].match_home
                
                //Competition name
                let composition_name = cell.viewWithTag(2) as! UILabel
                composition_name.text = competitionsStruct[indexPath.row].composition_name
                
                //Club logo Domicile
                var paysImageDomicile = cell.viewWithTag(3) as! UIImageView
                if let payslogo = UIImage(named: (competitionsStruct[indexPath.row].match_home)!) {
                    paysImageDomicile.image = payslogo
                }
                
                //Date
                let date_name = cell.viewWithTag(5) as! UILabel
                /*
                 var date = NSDate()
                 date = competitionsStruct[indexPath.row].time_start as NSDate
                 let dateFormatter = DateFormatter()
                 dateFormatter.locale = Locale(identifier: "fr")
                 dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
                 let dateString = dateFormatter.string(from:date as Date)
                 
                 let format = "yyyy-MM-dd HH:mm:ss"
                 let date_nsdate = time_start?.toDate(format: format)
                 let date_nsdate = competitionsStruct[indexPath.row].time_start.toDate(format: format)
                 
                 date_name.text = dateString
                 */
                date_name.text = competitionsStruct[indexPath.row].time_start
            }
        }
        else {
                
                //Status
                let status_match = cell.viewWithTag(12) as! UIButton
                status_match.isEnabled = false

                //Bouton pour jouer
                let start_game = cell.viewWithTag(13) as! UIButton
                start_game.backgroundColor = FACEBOOK_COLOR_BLUE
                start_game.isEnabled = true
                start_game.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
                
                //Nom pays domicile
                let match_hometeam_name = cell.viewWithTag(1) as! UILabel
                match_hometeam_name.text = competitionsStruct[indexPath.row].match_home
                
                //Competition name
                let composition_name = cell.viewWithTag(2) as! UILabel
                composition_name.text = competitionsStruct[indexPath.row].composition_name
                
                //Club logo Domicile
                var paysImageDomicile = cell.viewWithTag(3) as! UIImageView
                if let payslogo = UIImage(named: (competitionsStruct[indexPath.row].match_home)!) {
                    paysImageDomicile.image = payslogo
                }
                
                //Date
                let date_name = cell.viewWithTag(5) as! UILabel
            
                let date_string = competitionsStruct[indexPath.row].time_start
                let format = "yyyy-MM-dd HH:mm:ss"
                let date_nsdate = date_string?.toDate(format: format)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "fr")
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
                let dateString = dateFormatter.string(from: date_nsdate!)

                date_name.text = dateString
        }
        

        return cell
    }
    
    

    
    @objc func btnAction(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableviewOutlet as UIView)
        let indexPath: IndexPath! = tableviewOutlet.indexPathForRow(at: point)
        
        self.nationality = competitionsStruct[indexPath.row].match_home
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            /*
            var date = NSDate()
            date = competitionsStruct[indexPath.row].time_start as NSDate
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr")
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
            let dateString = dateFormatter.string(from:date as Date)
            */
            let competitions_id = competitionsStruct[indexPath.row].competitions_id

            viewController.competition_id = competitions_id!
            
            
            loadDataFacebookUser()
            if (fbuser?.count)! > 0 {
                apikey = (fbuser![0].apikey?.description)!
            }
            else {
                let message = "Access Denied. Invalid Api key"
                alerteMessage(message: message)
                return
            }
            
 
            viewController.passapikey = apikey

 
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = facebookButton.center
        transition.circleColor = facebookButton.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = facebookButton.center
        transition.circleColor = facebookButton.backgroundColor!
        
        return transition
    }
    
    
}





