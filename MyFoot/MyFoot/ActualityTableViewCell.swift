//
//  ActualityTableViewCell.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 11/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

class ActualityTableViewCell: UITableViewCell
{
    
    // takes time to download stuff from the Internet
    //  | MAIN (UI)  | download  | upload  |share
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
}

