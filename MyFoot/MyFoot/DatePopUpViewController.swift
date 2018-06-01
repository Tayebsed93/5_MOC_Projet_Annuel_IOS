//
//  DatePopUpViewController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 01/05/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

class DatePopUpViewController: UIViewController {

    var delegate: PopupDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    var showTimePicker: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.backgroundColor = GREENBlACK_THEME
        saveButton.backgroundColor = GREENBlACK_THEME
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveDate_TouchAction(_ sender: UIButton) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate = dateFormatter.string(from: datePicker.date)
        delegate?.popupValueSelected(value: strDate)
        
        self.dismiss(animated: true)
        
    }
    
    
    
}
