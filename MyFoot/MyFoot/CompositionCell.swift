//
//  CompositionCell.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 02/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit

class CompositionCell: UITableViewCell {
    
    @IBOutlet weak var numberMaillot: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

