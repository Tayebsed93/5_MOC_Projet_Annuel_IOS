//
//  DatePopUpViewController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 01/05/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

class DatePopUpViewController: UIViewController {

    var delegate: MyProtocol?
    
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
        delegate?.sendData(date: "25 Janvier")
        self.dismiss(animated: true) 
            //
        

        //dismiss(animated: true, completion: nil)
    }
    
    
}
