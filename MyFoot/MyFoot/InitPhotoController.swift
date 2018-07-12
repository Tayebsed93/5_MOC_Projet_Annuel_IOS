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
        
        
        
        //visiterButton.backgroundColor = FACEBOOK_COLOR_BLUE
        
        pscope.addPermission(CameraPermission(), message: "\rAccès à la caméra")
        
        let manager = RescouceManager.share
        /*
        if manager.boxImages.count == 0 {
            manager.addBoxImage(image: UIImage(named: "B_Image_0")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_1")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_2")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_3")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_4")!)
        }
 */
        if manager.boxImages.count == 0 {
            manager.addBoxImage(image: UIImage(named: "B_Image_PSG")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_PSG")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_PSG")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_PSG")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_PSG")!)
        }
        /*
        if manager.verticalImages.count == 0 {
            manager.addVerticalImage(image: UIImage(named: "V_Image_0")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_1")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_2")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_3")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_4")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_5")!)
        }
         */
        /*
        if manager.verticalImages.count == 0 {
            manager.addVerticalImage(image: UIImage(named: "V_Neymar")!)
            manager.addVerticalImage(image: UIImage(named: "V_Gustavo")!)
            manager.addVerticalImage(image: UIImage(named: "V_Ballotelli")!)
            manager.addVerticalImage(image: UIImage(named: "V_Fekir")!)
            manager.addVerticalImage(image: UIImage(named: "V_Falcao")!)
            manager.addVerticalImage(image: UIImage(named: "V_Khazri")!)
        }
 */
        /*
        if manager.horizontalImages.count == 0 {
            manager.addHorizontalImage(image: UIImage(named: "H_Image_0")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_1")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_2")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_3")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_4")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_5")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_6")!)
        }
         */
        
        if manager.horizontalImages.count == 0 {
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
            manager.addHorizontalImage(image: UIImage(named: "H_PSG")!)
        }
        if manager.text == nil {
            if  manager.text?.count == 0 {
                manager.text = "嗨,你好呀!"
                manager.textColor = "textColor_0"
            }
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func visiterButtonClick(_ sender: Any) {
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


