//
//  Profile.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage

class Profile: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var prn: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    
    var uploadedImage = UIImage()
    var imagePicker = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor
        /*Setting Delegate */
        name.delegate = self
        prn.delegate = self
        address.delegate = self
        mail.delegate = self
        phone.delegate = self
        /*Setting toolbar for number textfields*/
        self.addToolBar(textField: prn)
        self.addToolBar(textField: phone)
        
        if GlobalVariables.user_type == "TNSRLM"
        {
            
        }
        else
        {
            self.webRequestForPIA()
        }
        /*Rounded Corners for ImageView */
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.masksToBounds = true;
        self.tapToDismissKeypad()

    }
    
    func tapToDismissKeypad ()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
           //Causes the view (or one of its embedded text fields) to resign the first responder status.
           view.endEditing(true)
       }
    
    func webRequestForPIA ()
    {
        let functionName = "apipia/user_profile"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
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
                    if (msg == "User profile")
                    {
                        // Mark : Parseing userData
                        let userprofile = JSON?["userprofile"] as? NSDictionary
                        let name = (userprofile!["pia_name"] as! String)
//                        let prn = (userprofile!["pia_id"] as! String)
                        let address = (userprofile!["pia_address"] as! String)
                        let email = (userprofile!["pia_email"] as! String)
                        let phone = (userprofile!["pia_phone"] as! String)
                        let profile_Pic = (userprofile!["pia_profile_pic"] as! String)

                        self.loadUserDetails(name:name,prn:GlobalVariables.pia_unique_number!,address:address,mail:email,phone:phone,profile_Pic:profile_Pic)

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
    
    func loadUserDetails (name:String,prn:String,address:String,mail:String,phone:String,profile_Pic:String)
    {
        self.name.text = name
        self.prn.text = prn
        self.address.text = address
        self.mail.text = mail
        self.phone.text = phone
        
        self.userImageView.sd_setImage(with: URL(string: profile_Pic), placeholderImage: UIImage(named: "profile photo-01.png"))
    }
    
    /*Textfield Delegate Methods */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == name
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
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            phone.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == name
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == address
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == mail
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == phone
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 120), animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
      if textField == prn
      {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
           return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 13
      }
      else if textField == phone
      {
         let currentCharacterCount = textField.text?.count ?? 0
         if range.length + range.location > currentCharacterCount {
             return false
         }
         let newLength = currentCharacterCount + string.count - range.length
         return newLength <= 10
      }
      else
      {
         let currentCharacterCount = textField.text?.count ?? 0
         if range.length + range.location > currentCharacterCount {
             return false
         }
         let newLength = currentCharacterCount + string.count - range.length
         return newLength <= 30
      }
        
    }
    
    @IBAction func imageSelectingButton(_ sender: Any)
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
     
     func openGallary(){
         imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
         //If you dont want to edit the photo then you can set allowsEditing to false
         imagePicker.allowsEditing = true
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
     }
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
         uploadedImage = (info[.originalImage] as? UIImage)!
         
         if  let editedImage = info[.originalImage] as? UIImage
         {
             self.userImageView.image = editedImage
             self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
             self.userImageView.layer.borderWidth = 1
             self.userImageView.layer.borderColor = UIColor.lightGray.cgColor
             self.userImageView.clipsToBounds = true
             self.userImageView.layer.masksToBounds = true;

            
             self.imageUpload()
         }
         
         //Dismiss the UIImagePicker after selection
         picker.dismiss(animated: true, completion: nil)
     }
    
    @IBAction func save(_ sender: Any)
    {
        if self.name.text == ""
        {
             let alertController = UIAlertController(title: "M3", message: "name cannot be empty", preferredStyle: .alert)
              let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                  print("You've pressed default");
              }
              alertController.addAction(action1)
              self.present(alertController, animated: true, completion: nil)

        }
        else if self.address.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "address cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mail.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "mail cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.phone.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "phone cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.updateUserDetails(name: self.name.text!, address: self.address.text!, email: self.mail.text!, phone: self.phone.text!,pia_id:self.prn.text!)
        }
    }
    
    func updateUserDetails (name:String,address:String,email:String,phone:String,pia_id:String)
    {
       let functionName = "apipia/user_profile_update/"
       let baseUrl = Baseurl.baseUrl + functionName
       let url = URL(string: baseUrl)!
       let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"pia_id":pia_id,"pia_name":name,"pia_address":address,"pia_email":email,"pia_phone":phone]
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
                   if (msg == "User profile updated successfully")
                   {
                       // Mark : Parseing userData
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
        
        func imageUpload ()
        {
            let imgData = uploadedImage.jpegData(compressionQuality: 0.5)

            if imgData != nil
            {
               MBProgressHUD.showAdded(to: self.view, animated: true)
               let functionName = "apipia/user_profile/"
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
                                 self.showToast(message: "Image Uploaded.")
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
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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

