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
    
    
    var passhomeTeam = String()
    var passawayTeam = String()
    var passhomeScore = String()
    var passawayScore = String()
    var passhomeLogo = String()
    var passawayLogo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        homeName.text = passhomeTeam
        awayName.text = passawayTeam
        homeScore.text = passhomeScore
        awayScore.text = passawayScore
        homeLogo.setRounded()
        awayLogo.setRounded()
        
        if self.passhomeLogo == EMPTY_LOGO_IMG {
            homeLogo.image = UIImage(named: EMPTY_LOGO_IMG)
        } else if let logo = UIImage(named: passhomeLogo) {
            homeLogo.image = logo
        } else {
            homeLogo.loadImageUsingUrlString(urlString: self.passhomeLogo)
        }
        
        if self.passawayLogo == EMPTY_LOGO_IMG {
            awayLogo.image = UIImage(named: EMPTY_LOGO_IMG)
        } else if let logo = UIImage(named: passawayLogo) {
            awayLogo.image = logo
        } else {
            awayLogo.loadImageUsingUrlString(urlString: self.passawayLogo)
        }
        
        // Do any additional setup after loading the view.
    }
}
