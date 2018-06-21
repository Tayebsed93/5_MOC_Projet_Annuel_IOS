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
                    guard let imageToCache = UIImage(data: data!) else {
                        return
                    }
                    if imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    do {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    }
                    catch {
                        
                    }
                    
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

extension NSData
{
    func toString() -> String
    {
        return String(data: self as Data, encoding: .utf8)!
    }
}

extension NSDate {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "fr_FR")
        //print(dateFormatter.string(from: date)) // 2 janv. 2001
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "MMM"
        let strMonth = dateFormatter.string(from: self as Date)
        return strMonth
    }
    
    func getDateName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        //print(dateFormatter.string(from: date)) // 2 janv. 2001
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strMonth = dateFormatter.string(from: self as Date)
        return strMonth
    }
    
    
}


extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
        
    }
    
}

extension UIImageView {
    
    func setRounded() {
        
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}


