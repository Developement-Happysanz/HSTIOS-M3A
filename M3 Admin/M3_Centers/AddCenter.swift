//
//  AddCenter.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddCenter: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    var activeField: UITextField?

    var imagePicker = UIImagePickerController()
    
    var uploadedImage = UIImage()
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var details: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var ImgaecontentView: UIView!
    
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var saveOtlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        if (name.text?.isEmpty)! || (details.text?.isEmpty)! || (address.text?.isEmpty)!
        {
            let alertController = UIAlertController(title: "M3", message: "Enter all required Fields", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let functionName = "apipia/create_center/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "center_name": name.text!, "center_info": details.text!, "center_address": address.text!]
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
                             let center_id = JSON?["center_id"] as! CVarArg
                             GlobalVariables.center_id = String(format: "%@", center_id )
                             self.webRequest_Image ()
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
    
    func webRequest_Image ()
    {
            let imgData = uploadedImage.jpegData(compressionQuality: 0.75)

            if imgData == nil
            {
                self.performSegue(withIdentifier: "addcenterdetail_center", sender: self)

            }
            else
            {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let functionName = "apipia/update_center_banner/"
                let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.center_id! + "/"
                let url = URL(string: baseUrl)!
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData!, withName: "center_banner",fileName: "file.jpg", mimeType: "image/jpg")
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
                            if (response.result.value as? NSDictionary) != nil{
                                
                                self.performSegue(withIdentifier: "addcenterdetail_center", sender: self)
                            }
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
        }
    }
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var uploadimageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func imageViewButton(_ sender: Any)
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
    
    //MARK: - Open the camera
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
        if   let editedImage = info[.originalImage] as? UIImage
        {
            self.uploadimageView.isHidden = true
            self.textLabel.isHidden = true
            self.selectedImageView.isHidden = false
            self.ImgaecontentView.layer.borderWidth = 0
            self.selectedImageView.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func photoViewButton(_ sender: Any)
    {
        
    }
    @IBAction func videoViewButton(_ sender: Any)
    {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.title = "Add Center Detail"
        
        name.delegate = self
        
        details.delegate = self
        
        address.delegate = self

        self.ImgaecontentView.layer.borderWidth = 1
        self.ImgaecontentView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
        self.ImgaecontentView.layer.cornerRadius = 5
        
//        self.photoView.layer.borderWidth = 1
//        self.photoView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
//        self.photoView.layer.cornerRadius = 3
//
//        self.videoView.layer.borderWidth = 1
//        self.videoView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
//        self.videoView.layer.cornerRadius = 3
        
        self.saveOtlet.layer.cornerRadius = 3
        self.saveOtlet.clipsToBounds = true
        
        self.selectedImageView.isHidden = true

        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        

    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        self.selectedImageView.layer.cornerRadius = selectedImageView.bounds.width/2
        self.selectedImageView.layer.borderWidth = 1
        self.selectedImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.selectedImageView.clipsToBounds = true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if textField == name
        {
            details.becomeFirstResponder()
        }
        else if textField == details
        {
            address.becomeFirstResponder()
        }
        else
        {
            address.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            self.view.endEditing(true);
        }
        
    }
}
