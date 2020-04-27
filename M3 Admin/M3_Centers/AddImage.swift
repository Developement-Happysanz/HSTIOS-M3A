//
//  AddImage.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 08/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddImage: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var imagePicker = UIImagePickerController()

    var uploadedImage = UIImage()

    
    @IBOutlet weak var ImgaecontentView: UIView!

    @IBOutlet weak var defaultImage: UIImageView!
    
    @IBOutlet weak var uploadTitleLabel: UILabel!
    
    @IBAction func imageViewButon(_ sender: Any)
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
        
        if  let editedImage = info[.originalImage] as? UIImage
        {
            self.defaultImage.isHidden = true
            self.uploadTitleLabel.isHidden = true
            self.selectedImage.isHidden = false
            self.ImgaecontentView.layer.borderWidth = 0
            self.selectedImage.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBAction func saveButton(_ sender: Any)
    {
        self.webRequest_Image ()
    }
   
    func webRequest_Image ()
    {
        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
        if imgData == nil
        {
            self.performSegue(withIdentifier: "addImage_GalleryList", sender: self)
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let functionName = "apipia/add_center_photos/"
            let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.center_id! + "/" + GlobalVariables.user_id! + "/"
            let url = URL(string: baseUrl)!
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData!, withName: "center_photo",fileName: "file.jpg", mimeType: "image/jpg")
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
                            self.performSegue(withIdentifier: "addImage_GalleryList", sender: self)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
    @IBOutlet weak var saveOtlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Add Image"
        
        self.ImgaecontentView.layer.borderWidth = 1
        self.ImgaecontentView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
        self.ImgaecontentView.layer.cornerRadius = 5
        
        self.saveOtlet.layer.cornerRadius = 4
        self.saveOtlet.clipsToBounds = true
        
        self.selectedImage.isHidden = true
        
        imagePicker.delegate = self
        
        navigationLeftButton ()

    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        self.selectedImage.layer.cornerRadius = selectedImage.bounds.width/2
        self.selectedImage.layer.borderWidth = 1
        self.selectedImage.layer.borderColor = UIColor.lightGray.cgColor
        self.selectedImage.clipsToBounds = true
        
    }
    
    func navigationLeftButton ()
    {
        let navigationLeftButton = UIButton(type: .custom)
        navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLeftButton.addTarget(self, action: #selector(backButtonclick), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func backButtonclick()
    {
        self.performSegue(withIdentifier: "addImage_GalleryList", sender: self)
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
