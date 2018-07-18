//
//  InitPhotoController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 04/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation

class InitPhotoController: UIViewController {
    
    @IBOutlet weak var visiterButton: UIButton!
    
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pscope.addPermission(CameraPermission(), message: "\rAccès à la caméra")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        guard let team_name = playerss![0].club?.description else {
            return
        }
        
        print(team_name)
        let manager = RescouceManager.share
        
        manager.boxImages = []
        if manager.boxImages.count == 0 {
            manager.addBoxImage(image: UIImage(named: team_name)!)
            manager.addBoxImage(image: UIImage(named: team_name)!)
            manager.addBoxImage(image: UIImage(named: team_name)!)
            manager.addBoxImage(image: UIImage(named: team_name)!)
            manager.addBoxImage(image: UIImage(named: team_name)!)
        }
        
        manager.horizontalImages = []
        let stade = team_name + "_stade"
        if manager.horizontalImages.count == 0 {
            manager.addHorizontalImage(image: UIImage(named: stade)!)
            manager.addHorizontalImage(image: UIImage(named: stade)!)
            manager.addHorizontalImage(image: UIImage(named: stade)!)
            manager.addHorizontalImage(image: UIImage(named: stade)!)
            manager.addHorizontalImage(image: UIImage(named: stade)!)
            manager.addHorizontalImage(image: UIImage(named: stade)!)
            manager.addHorizontalImage(image: UIImage(named: stade)!)
        }
        if manager.text == nil {
            if  manager.text?.count == 0 {
                manager.text = "Football"
                manager.textColor = "textColor_0"
            }
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func visiterButtonClick(_ sender: Any) {
        self.permissions()
        
        /*
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                alerteMessage(message: "Cette fonctionnalité n'est pour le moment pas disponible sur cet appareil")
                print("iPhone 5 or 5S or 5C")
            case 1334:
                alerteMessage(message: "Cette fonctionnalité n'est pour le moment pas disponible sur cet appareil")
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                alerteMessage(message: "Cette fonctionnalité n'est pour le moment pas disponible sur cet appareil")
            case 2436:
                self.permissions()
                print("iPhone X")
            default:
                alerteMessage(message: "Cette fonctionnalité n'est pour le moment pas disponible sur cet appareil")
            }
        }
 */
        
    }
    
    func alerteMessage(message : String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}



extension InitPhotoController {
    func permissions() {
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HKMemoirsViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        /*
        
        pscope.show({ _, _ in
            self.pscope.hide()
            let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch videoAuthStatus {
            case .notDetermined: break
            case .denied: break
            default:
                let sb = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "HKMemoirsViewController")
                self.navigationController?.pushViewController(vc, animated: true)
                print("PUSH")
            }
        },
                    cancelled: { _ in
                        print("thing was cancelled")
                        self.pscope.hide()
        }
        )
 */
    }
 
}


