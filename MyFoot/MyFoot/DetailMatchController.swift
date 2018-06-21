//
//  DetailMatchController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 20/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit

class DetailMatchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerContenair: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var containerVC : ContainerMatch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if #available(iOS 10.0, *) {
            
            self.tableViewOutlet.refreshControl = UIRefreshControl()
            self.tableViewOutlet.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = GREY_THEME
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableViewOutlet.refreshControl?.endRefreshing()
            }
            self?.tableViewOutlet.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segueContainer")
        {
            containerVC = segue.destination as! ContainerMatch
            containerVC.testtay = "LOL"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }
    
    
    
}

