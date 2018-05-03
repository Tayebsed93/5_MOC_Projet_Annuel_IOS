//
//  Extensions.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 27/04/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(displayP3Red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}

extension UITextField {
    
    func setBottomBorder(backGroundColor: UIColor, borderColor: UIColor) {
        self.layer.backgroundColor = backGroundColor.cgColor
        
        // defines the layers shadow
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = borderColor.cgColor
    }
}

extension UIView {
    func anchors(top: NSLayoutYAxisAnchor?, topPad: CGFloat, bottom: NSLayoutYAxisAnchor?, bottomPad: CGFloat,
                 left: NSLayoutXAxisAnchor?, leftPad: CGFloat, right: NSLayoutXAxisAnchor?, rightPad: CGFloat,
                 height: CGFloat, width: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPad).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPad).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftPad).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightPad).isActive = true
        }
        
        if height > 0 { self.heightAnchor.constraint(equalToConstant: height).isActive = true }
        if width > 0 { self.widthAnchor.constraint(equalToConstant: width).isActive = true }
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        var imageUrlString: String?
        
        imageUrlString = urlString
        let url = NSURL(string: urlString)
        
        image = nil
        
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        let task = URLSession.shared.dataTask(with: url! as URL, completionHandler: { data,response,error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async()
                {
                    let imageToCache = UIImage(data: data!)
                    if imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                }
            
            
        })
        task.resume()
        
    }
}


extension UITableViewCell {
    
    var isSeparatorHidden: Bool {
        get {
            return self.separatorInset.right != 0
        }
        set {
            if newValue {
                self.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)
            } else {
                self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
    }
    
}



