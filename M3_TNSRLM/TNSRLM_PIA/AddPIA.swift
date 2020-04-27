//
//  AddPIA.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddPIA: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var uploadedImage = UIImage()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var sacrollView: UIScrollView!
    @IBOutlet var uniqueID: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var mail: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var saveOutlet: UIButton!
    @IBAction func saveButton(_ sender: Any)
    {
        let str = UserDefaults.standard.string(forKey: "pia_Creation")
        if str == "FromList"
        {
            updateDetails()
        }
        else
        {
            adddetails ()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uniqueID.delegate = self
        name.delegate = self
        address.delegate = self
        mail.delegate = self
        phone.delegate = self
        saveOutlet.layer.cornerRadius = 4
        let str = UserDefaults.standard.string(forKey: "pia_Creation")
        if str == "FromList"
        {
            showDetails ()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.addToolBar(textField: uniqueID)
        self.addToolBar(textField: phone)
    }
    
    @objc func doneButtonAction()
    {
        if uniqueID.isFirstResponder
        {
            
        }
        else if phone.isFirstResponder
        {
            
        }
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == uniqueID
        {
            name.becomeFirstResponder()
        }
        else if textField == name
        {
            address.becomeFirstResponder()
        }
        else if textField == address
        {
            mail.becomeFirstResponder()
        }
        else if textField == mail
        {
            phone.becomeFirstResponder()
        }
        else if textField == phone
        {
            phone.resignFirstResponder()
        }
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == uniqueID
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 50), animated: true)
        }
        else if textField == name
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == address
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == mail
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == phone
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 150), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == uniqueID
        {
            name.becomeFirstResponder()
        }
        else if textField == name
        {
            address.becomeFirstResponder()
        }
        else if textField == address
        {
            mail.becomeFirstResponder()
        }
        else if textField == mail
        {
            phone.becomeFirstResponder()
        }
        else if textField == phone
        {
            phone.resignFirstResponder()
        }
    }
    
    func adddetails ()
    {
        let email = self.mail.text
        if self.uniqueID.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.name.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.address.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mail.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if email!.isValidEmail() == false
       {
           let alertController = UIAlertController(title: "M3", message: "email is incorrect", preferredStyle: .alert)
           let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
           }
           alertController.addAction(action1)
           self.present(alertController, animated: true, completion: nil)
        }
        else if self.phone.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apimain/create_pia"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "unique_number": self.uniqueID.text as Any, "name": self.name.text as Any, "address": self.address.text as Any, "phone": self.phone.text as Any, "email": self.mail.text as Any]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
              {
                    response in
                    switch response.result
                    {
                    case .success:
                        print(response)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let JSON = response.result.value as? [String: Any]
                        let msg = JSON?["msg"] as? String
                        let status = JSON?["status"] as? String
                        if (status == "success")
                        {
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        break
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func updateDetails ()
    {
        let email = self.mail.text
        if self.uniqueID.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.name.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.address.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mail.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if email!.isValidEmail() == false
        {
            let alertController = UIAlertController(title: "M3", message: "email is incorrect", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.phone.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apimain/create_pia"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "unique_number": self.uniqueID.text as Any, "name": self.name.text as Any, "address": self.address.text as Any, "phone": self.phone.text as Any, "email": self.mail.text as Any]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print(response)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let JSON = response.result.value as? [String: Any]
                        let msg = JSON?["msg"] as? String
                        let status = JSON?["status"] as? String
                        if (status == "success")
                        {
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                self.dismiss(animated: true, completion: nil)
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        break
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func showDetails ()
    {
        let functionName = "apimain/pia_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["pia_id": GlobalVariables.user_master_id!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
        {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let userList = JSON?["userList"] as? [Any]
                        
                        for i in 0..<(userList?.count ?? 0)
                        {
                            let dict = userList?[i] as? [AnyHashable : Any]
                            self.address.text = (dict!["pia_address"] as! String)
                            self.mail.text = (dict!["pia_email"] as! String)
                            self.name.text = (dict!["pia_name"] as! String)
                            self.phone.text = (dict!["pia_phone"] as! String)
                            self.uniqueID.text = (dict!["pia_unique_number"] as! String)
                        }
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
       if textField == uniqueID
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
           {
               return false
           }
           let newLength = currentCharacterCount + string.count - range.length
           return newLength <= 13
       }
       else if textField == phone
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
            {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
       }
       else
       {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 30
       }
    }
    
    @IBAction func imgAction(_ sender: Any)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
         if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
             imagePicker.sourceType = UIImagePickerController.SourceType.camera
             //If you dont want to edit the photo then you can set allowsEditing to false
             imagePicker.allowsEditing = true
             imagePicker.delegate = self
             self.present(imagePicker, animated: true, completion: nil)
         }
         else{
             let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
     
     //MARK: - Choose image from camera roll
     func openGallary()
     {
         imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
         //If you dont want to edit the photo then you can set allowsEditing to false
         imagePicker.allowsEditing = true
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
     }
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
     {
         uploadedImage = (info[.originalImage] as? UIImage)!
         if  let editedImage = info[.originalImage] as? UIImage
         {
             self.imgView.image = editedImage
             self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2
             self.imgView.layer.borderWidth = 1
             self.imgView.layer.borderColor = UIColor.lightGray.cgColor
             self.imgView.clipsToBounds = true
             self.imgView.layer.masksToBounds = true;
            
             
         }
         //Dismiss the UIImagePicker after selection
         picker.dismiss(animated: true, completion: nil)
     }
    
        func imageUpload ()
        {
           let imgData = uploadedImage.jpegData(compressionQuality: 0.5)
           if imgData != nil
           {
              MBProgressHUD.showAdded(to: self.view, animated: true)
              let functionName = "apipia/user_profilepic/"
              let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.user_id! + "/"
              let url = URL(string: baseUrl)!
              
              Alamofire.upload(multipartFormData: { multipartFormData in
                      multipartFormData.append(imgData!, withName: "user_pic",fileName: "file.jpg", mimeType: "image/jpg")
                  },
                to:url)
                  { (result) in
                      switch result {
                      case .success(let upload, _, _):
                          
                          upload.uploadProgress(closure: { (progress) in
                              print("Upload Progress: \(progress.fractionCompleted)")
                          })
                          
                          upload.responseJSON { response in
                              print(response.result.value as Any)
                              MBProgressHUD.hide(for: self.view, animated: true)
                              if (response.result.value as? NSDictionary) != nil
                              {
                                let dict = response.result.value as? NSDictionary
                                let msg = dict!["msg"]
    //                            let status = dict!["success"]
                                
                                let alertController = UIAlertController(title: "M3", message: (msg as! String), preferredStyle: .alert)
                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                    print("You've pressed default");
                                }
                                alertController.addAction(action1)
                                self.present(alertController, animated: true, completion: nil)
                              }
                          }
                          
                      case .failure(let encodingError):
                          print(encodingError)
                      }
                  }
              }
              else
              {
                self.navigationController?.popViewController(animated: true)
              }
         }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension UIViewController
{
    func addToolBar(textField: UITextField)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed(_:)))
        let cancelButton = UIBarButtonItem(title:"cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        //textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(_ textField: UITextField)
    {
        view.endEditing(true)
    }
    
    @objc func cancelPressed(textField: UITextField)
    {
        view.endEditing(true)// or do something
    }
}
