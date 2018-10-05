//
//  AddActualityController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 17/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import NVActivityIndicatorView

class AddActualityController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var image: UIButton!
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleTxt: UITextField!
    
    @IBOutlet weak var descriptionTxt: UITextView!
    
    @IBOutlet weak var publish: UIBarButtonItem!
    
    
    var spinner = UIActivityIndicatorView()
    
    let imagePicker = UIImagePickerController()
    var passeapikey = String()
    
    var instanceOfATC = ActualityTableViewController()    // Create an instance of VCA in VCB
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        
        DispatchQueue.main.async()
        {
            self.navigationController?.isNavigationBarHidden = false
            NotificationCenter.default.addObserver(self, selector: #selector(AddActualityController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(AddActualityController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
            self.descriptionTxt.text = "Quoi de neuf ?"
            self.descriptionTxt.textColor = UIColor.lightGray
            self.addAccessory()
            self.titleTxt.becomeFirstResponder()
        }
        
        
    }
    
    let accessory: UIView = {
        let accessoryView = UIView(frame: .zero)
        accessoryView.backgroundColor = .lightGray
        accessoryView.alpha = 0.4
        return accessoryView
    }()
    let cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Photo", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action:
            #selector(photoButtonTapped), for: .touchUpInside)
        cancelButton.showsTouchWhenHighlighted = true
        return cancelButton
    }()
    let charactersLeftLabel: UILabel = {
        let charactersLeftLabel = UILabel()
        //charactersLeftLabel.text = "256 characteres"
        charactersLeftLabel.textColor = UIColor.white
        return charactersLeftLabel
    }()
    /*
    let sendButton: UIButton! = {
        let sendButton = UIButton(type: .custom)
        sendButton.setTitleColor(.red, for: .normal)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .disabled)
        //sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.showsTouchWhenHighlighted = true
        sendButton.isEnabled = true
        return sendButton
    }()
    */
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.length + range.location > descriptionTxt.text.count {
            publish.isEnabled = false
            return false
        }
        
        publish.isEnabled = true
        
        let newlenght = descriptionTxt.text.count + text.count - range.length
        
        let soustract = 100 - newlenght
        charactersLeftLabel.text = soustract.description
        
        if soustract <= 0 {
            charactersLeftLabel.textColor = UIColor.red
        }
        else {
            charactersLeftLabel.textColor = UIColor.white
        }
        return newlenght <= 99
    }
    func addAccessory() {
        accessory.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 45)
        accessory.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        charactersLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        //sendButton.translatesAutoresizingMaskIntoConstraints = false
        titleTxt.inputAccessoryView = accessory
        descriptionTxt.inputAccessoryView = accessory
        accessory.addSubview(cancelButton)
        accessory.addSubview(charactersLeftLabel)
        //accessory.addSubview(sendButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo:
                accessory.leadingAnchor, constant: 20),
            cancelButton.centerYAnchor.constraint(equalTo:
                accessory.centerYAnchor),
            
            
            charactersLeftLabel.trailingAnchor.constraint(equalTo:
                accessory.trailingAnchor, constant: -20),
            charactersLeftLabel.centerYAnchor.constraint(equalTo:
                accessory.centerYAnchor)
            
            ])
    }
    
    @objc func photoButtonTapped() {
    openPhotoLibrary()
    }
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    
    //Fonction qui récupère l'image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageRecu = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.setImage(imageRecu, for: UIControlState.normal)
            
        }
        picker.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        //view.endEditing(true)
        //super.touchesBegan(touches, with: event)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        DispatchQueue.main.async()
        {
                if let userInfo = notification.userInfo {
                    if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        self.bottomHeight.constant = keyboardSize.height
                    }
                }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        DispatchQueue.main.async()
            {
                self.bottomHeight.constant = 0.0
        }
        
    }
    
    @IBAction func QuitButton(_ sender: Any) {
        /*
        DispatchQueue.main.async() {
            //self.instanceOfVCA.viewDidLoad()
        }
        
        self.dismiss(animated: true, completion: nil)
        */
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVc = storyboard.instantiateViewController(withIdentifier: "ActualityTableViewController") as! ActualityTableViewController
        
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async() {
            //tabVc.callAPI()
            self.instanceOfATC.refreshHandler()
            //self.instanceOfVCA.tableviewOutlet.reloadData()
            tabVc.view.removeFromSuperview()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func createBodyWithParameters(namePhoto: String?, parameters: [String: String]?, parametersFile: [String: NSData]?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let mimetype = "image/png"
        
        var fileName = String()
        var nameClubNoSpace = String()
        if parametersFile != nil {
            for (key, value) in parametersFile! {
                if key == ACTUALITY_CONSTANTE {
                    nameClubNoSpace = (namePhoto?.replacingOccurrences(of: " ", with: "_",
                                                                      options: NSString.CompareOptions.literal, range:nil))!
                    fileName = nameClubNoSpace + "-actuality.jpg"
                    
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                    body.append(value as Data)
                    body.appendString(string: "\r\n")
                    body.appendString(string: "--\(boundary)--\r\n")
                }
                
                
        }
        
    }
        return body
}
    
    func myImageUploadRequest()
    {
        let myUrl = NSURL(string: addressUrlStringProd+newsMembreUrlString);
        
        
        loadDataMember()
        if (member?.count)! > 0 {
            passeapikey = (member![0].apikey?.description)!
        }
        else {
            self.alerteMessage(message: "Une erreur technique est survenue. Veuillez nous excuser pour la gêne occasionnée")
            return
        }
        
        let request = NSMutableURLRequest(url:myUrl as! URL);
        request.addValue(passeapikey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST";
        
        let param = [
            "content"  : descriptionTxt.text!,
            "title"    : titleTxt.text!,
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = NSData()
        if image.image(for: UIControlState.normal) != nil
        {
            imageData = UIImagePNGRepresentation(image.image(for: UIControlState.normal)!)! as NSData
            
        }
        
        let paramFile = [
            ACTUALITY_CONSTANTE  : imageData,
        ]
        let texteS = String()
        let texteimage = texteS.randomString(length: 25)
        
        request.httpBody = createBodyWithParameters(namePhoto: texteimage, parameters: param, parametersFile: paramFile, boundary: boundary) as Data
        
        showActivityIndicatory()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("Response = \(response)")
            
            // Print out reponse body
            if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                print("Response data = \(responseString)")
                
            }
            
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                
                if let message = json!["message"]
                {
                    DispatchQueue.main.async()
                    {
                            self.alerteMessage(message: message as! String)
                    }
                }
                
                DispatchQueue.main.async()
                    {
                        //self.spinner.stopAnimating()
                        self.stopAnimating()
                    }
                
                
            }catch
            {
                DispatchQueue.main.async()
                    {
                        
                        //self.spinner.stopAnimating()
                        self.stopAnimating()
                        //self.dismiss(animated: true, completion: nil)
                        
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabVc = storyboard.instantiateViewController(withIdentifier: "ActualityTableViewController") as! ActualityTableViewController
                        
                        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        DispatchQueue.main.async() {
                            //tabVc.callAPI()
                            self.instanceOfATC.refreshHandler()
                            //self.instanceOfVCA.tableviewOutlet.reloadData()
                            tabVc.view.removeFromSuperview()
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                        
                }
                print(error)
            }
            
        }
        
        task.resume()
    }

    
    func showActivityIndicatory() {
        /*
        self.spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(spinner)
        spinner.startAnimating()
        */
        //Loading
        DispatchQueue.main.async() {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 5))
            
        }
        
    }
        
        func alerteMessage(message : String) {
            
            var newMessage = ""
            if (message == "Could not connect to the server." ) {
                newMessage = "Impossible de se connecter au serveur."
                
                let alert = UIAlertController(title: "Erreur", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    @IBAction func sendActuality(_ sender: Any) {
        myImageUploadRequest()
    }
    
}

extension AddActualityController: UITextViewDelegate
{
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if !self.descriptionTxt.text!.isEmpty && self.descriptionTxt.text! == "Quoi de neuf ?"
        {
            self.descriptionTxt.text = ""
            self.descriptionTxt.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        if (self.descriptionTxt.text?.isEmpty)!
        {
            self.descriptionTxt.text = "Quoi de neuf ?"
            self.descriptionTxt.textColor = UIColor.lightGray
        }
    }
 
 
}


