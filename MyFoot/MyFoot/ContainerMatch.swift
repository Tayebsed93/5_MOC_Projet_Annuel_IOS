//
//  ContainerMatch.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 20/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit

class ContainerMatch: UIViewController {
    
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    
    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    
    
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    var testtay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeName.text = testtay
        homeLogo.setRounded()
        awayLogo.setRounded()
        
        homeScore.text = "2"
        awayScore.text = "0"
        
        // Do any additional setup after loading the view.
    }
}
