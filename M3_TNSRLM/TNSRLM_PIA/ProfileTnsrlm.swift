//
//  ProfileTnsrlm.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 18/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SDWebImage
import SwiftyJSON

class ProfileTnsrlm: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    var uploadedImage = UIImage()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Profile"
        NavigationBarTitleColor.navbar_TitleColor
        self.mail.delegate = self
        self.website.delegate = self
        self.contactNumber.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        imgView.sd_setImage(with: URL(string: GlobalVariables.user_pic ?? ""), placeholderImage: UIImage(named: "profile photo-01.png"))
        
        self.webRequestUserProfile ()
    }
    
    func webRequestUserProfile ()
    {
        let functionName = "apimain/user_profile"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_master_id": GlobalVariables.user_id!, "role_type": "1"]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
          {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let jSON = JSON(response.result.value as Any)
                    let msg = jSON["msg"].string
                    let status = jSON["status"]
                    if (status == "success")
                    {
                       for userList in jSON["userList"].arrayValue
                        {
                            if  let email = userList["email"].string,
                                let address = userList["name"].string,
                                let contactNumber = userList["phone"].string{
                                self.mail.text = email
                                self.website.text = address
                                self.contactNumber.text = contactNumber
                            }
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
    
    func webRequestUserProfileUpdate ()
    {
        let functionName = "apimain/user_profile"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_master_id": GlobalVariables.user_id!, "role_type": "1"]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
          {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let jSON = JSON(response.result.value as Any)
                    let msg = jSON["msg"].string
                    let status = jSON["status"]
                    if (status == "success")
                    {
                       for userList in jSON["userList"].arrayValue
                        {
                            if  let email = userList["email"].string,
                                let address = userList["name"].string,
                                let contactNumber = userList["phone"].string{
                                self.mail.text = email
                                self.website.text = address
                                self.contactNumber.text = contactNumber
                            }
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
            
             self.imageUpload()
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
          let functionName = "apimain/user_profilepic/"
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

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == mail
        {
            website.becomeFirstResponder()
        }
        else if textField == website
        {
            contactNumber.becomeFirstResponder()
        }
        else
        {
          contactNumber.resignFirstResponder()
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func updateAction(_ sender: Any)
    {
        
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
