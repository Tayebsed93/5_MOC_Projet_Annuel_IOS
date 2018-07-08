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
    
    
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pscope.addPermission(CameraPermission(), message: "\r相机是通往AR世界的钥匙")
        
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
        
        self.permissions()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



extension InitPhotoController {
    func permissions() {
        pscope.show({ _, _ in
            self.pscope.hide()
            let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch videoAuthStatus {
            case .notDetermined: break//未询问
            case .denied: break//已悲剧
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
    }
}


