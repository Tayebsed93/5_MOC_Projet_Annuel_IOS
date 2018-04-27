//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation


class PresidentHomeController: UIViewController, UINavigationControllerDelegate {

    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    public var clubUrlString = "/club"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



