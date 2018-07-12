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
    let match_home : String!
    let time_start : Date!
}

class HomeController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate, ChildNameDelegate, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var tableviewOutlet: UITableView!
    
    var competitionsStruct = [competitions]()
    
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
                self?.tableviewOutlet.refreshControl?.endRefreshing()
            }
            self?.tableviewOutlet.reloadData()
        })
    }
    
    func dataChanged(email: String, password: String, apikey: String) {
        defaults.set(apikey, forKey: defaultsKeys.key11)
        defaults.synchronize()
        
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
    
    let transition = CircularTransition()
    
    @IBOutlet weak var anneeText: UITextField!
    let button = UIButton(type: UIButtonType.custom)
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookButton.layer.cornerRadius = facebookButton.frame.size.width / 2
        facebookButton.backgroundColor = FACEBOOK_COLOR_BLUE

        self.isPlayer = true
        //callAPI()
        //callAPIComposition()
        
        
        //if the user is already logged in
        if let accessToken = AccessToken.current{
            print("User is logged in Facebook")
        }
        else {
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.isPlayer = true
        tableviewOutlet.separatorColor = UIColor(white: 0.95, alpha: 1)
        //callAPIComposition()
        callAPI()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let facebookVC = segue.destination as! FacebookLoginViewController
        facebookVC.transitioningDelegate = self
        facebookVC.modalPresentationStyle = .custom
        facebookVC.delegate = self
    }
    
    
    @IBAction func FranceClick(_ sender: Any) {
        self.nationality = "France"
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            guard var apikey = defaults.string(forKey: defaultsKeys.key11) else {
                let message = "Access Denied. Invalid Api key"
                alerteMessage(message: message)
                return
            }
            viewController.passapikey = defaults.string(forKey: defaultsKeys.key11)!
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    @IBAction func AllemagneClick(_ sender: Any) {
        self.nationality = "Germany"
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            guard var apikey = defaults.string(forKey: defaultsKeys.key11) else {
                let message = "Access Denied. Invalid Api key"
                alerteMessage(message: message)
                return
            }
            viewController.passapikey = defaults.string(forKey: defaultsKeys.key11)!
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func ItalieClick(_ sender: Any) {
        self.nationality = "Italy"
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            guard var apikey = defaults.string(forKey: defaultsKeys.key11) else {
                let message = "Access Denied. Invalid Api key"
                alerteMessage(message: message)
                return
            }
            viewController.passapikey = defaults.string(forKey: defaultsKeys.key11)!
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

    
    
    @IBAction func deconnecteButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callAPILogin() {
        let urlToRequest = addressUrlStringProd+loginUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = String(format:"email=%@&password=%@","emailTextField.text!","passwordTextField.text!")
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        
        
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
                        if let apiKey = json["apiKey"], let role = json["role"]
                        {
                            //self.passData(role: role as! String, apiKey: apiKey as! String)
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        
                }
                /*
                 DispatchQueue.main.async() {
                 self.dismiss(animated: true, completion: nil)
                 }
                 */
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    
    func callAPIComposition() {
        
        //let config = URLSessionConfiguration.default
        let urlToRequest = addressUrlStringProd+compositionUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        guard var apikey = defaults.string(forKey: defaultsKeys.key11) else {
            let message = "Access Denied. Invalid Api key"
            alerteMessage(message: message)
            return
        }
        request.addValue(defaults.string(forKey: defaultsKeys.key11)!, forHTTPHeaderField: "Authorization")
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
   
                        if let compositions = json["composition"] as? [[String: Any]] {
                            
                            for composition in compositions {
                                if let nation = composition["nation"]{
                                    self.nation.append(nation as! String)
                                    
                                }
                            }
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        
                        for ok in self.nation {
                            if (ok == "France") {
                                self.France.alpha = 1
                                self.btnFrance.isEnabled = false
                            }
                            else if (ok == "Germany") {
                                self.Germany.alpha = 1
                                self.btnGermany.isEnabled = false
                            }
                            else if (ok == "Italy") {
                                self.Italy.alpha = 1
                                self.btnItaly.isEnabled = false
                            }
                            
                        }
                        //self.setupData(_name: self.names, _age: self.ages)
                        
                        //self.isPlayer = false
                }
                
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
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
        
        let urlToRequest = addressUrlStringProd+competitionUrlString
        Alamofire.request(urlToRequest, method: .get).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let newsArray = swiftyJsonVar["competitions"].arrayObject {
                    self.tableviewOutlet.backgroundView?.isHidden = true
                    
                    for i in 0..<newsArray.count {
                        let composition_name = swiftyJsonVar["competitions"][i]["composition_name"].string
                        let groupe = swiftyJsonVar["competitions"][i]["groupe"].string
                        let match_away = swiftyJsonVar["competitions"][i]["match_away"].string
                        let match_home = swiftyJsonVar["competitions"][i]["match_home"].string
                        let time_start = swiftyJsonVar["competitions"][i]["time_start"].string
                        //newsStruct.append(news.init(title: title, content: content, photo: photo, created_at: created_at))
                        let format = "yyyy-MM-dd HH:mm:ss"
                        let date_nsdate = time_start?.toDate(format: format)
                        
                        self.competitionsStruct.append(competitions.init(composition_name: composition_name, groupe: groupe, match_away: match_away, match_home: match_home, time_start: date_nsdate))
                    }
                    
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.competitionsStruct.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeController", for: indexPath)
        cell.selectionStyle = .none
        //Status
        let status_match = cell.viewWithTag(12) as! UIButton
        status_match.isEnabled = false
        
        //Bouton pour jouer
        
        let start_game = cell.viewWithTag(13) as! UIButton
        start_game.backgroundColor = FACEBOOK_COLOR_BLUE
        start_game.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        //start_game.addTarget(self, action: "Print", for: UIControlEvents.touchUpInside)
 
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
        var date = NSDate()
        date = competitionsStruct[indexPath.row].time_start as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr")
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
        let dateString = dateFormatter.string(from:date as Date)
        date_name.text = dateString

        return cell
    }
    
    

    
    @objc func btnAction(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableviewOutlet as UIView)
        let indexPath: IndexPath! = tableviewOutlet.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        print(competitionsStruct[indexPath.row].match_home)
        
        self.nationality = competitionsStruct[indexPath.row].match_home
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            var date = NSDate()
            date = competitionsStruct[indexPath.row].time_start as NSDate
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr")
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE-dd-MMM-yyyy", options: 0, locale: dateFormatter.locale)
            let dateString = dateFormatter.string(from:date as Date)
            viewController.match_date = dateString
            
            guard var apikey = defaults.string(forKey: defaultsKeys.key11) else {
                let message = "Access Denied. Invalid Api key"
                alerteMessage(message: message)
                return
            }
 
            viewController.passapikey = defaults.string(forKey: defaultsKeys.key11)!

            //viewController.passapikey = "9962f17f02c37e0d40758e48b07eb7bb"
 
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





