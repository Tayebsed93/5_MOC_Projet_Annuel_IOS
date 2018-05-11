//
//  FacebookLoginViewController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 11/05/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

class FacebookLoginViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        dismissButton.backgroundColor = .white
        dismissButton.setTitleColor(FACEBOOK_COLOR_BLUE, for: .normal)
        
        facebookBtn.layer.cornerRadius = dismissButton.frame.size.width / 2
        facebookBtn.backgroundColor = .white
        facebookBtn.setTitleColor(FACEBOOK_COLOR_BLUE, for: .normal)
        view.backgroundColor = FACEBOOK_COLOR_BLUE
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dimissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func facebookAction(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
