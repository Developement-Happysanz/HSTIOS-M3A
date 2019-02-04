//
//  AddCenter.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class AddCenter: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{

    @IBOutlet weak var uploadImgaeView: UIView!
    
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var saveOtlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        
    }
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var uploadimageLabel: UIView!
    
    @IBOutlet weak var uploadimageView: UIImageView!
    
    @IBAction func imageViewButton(_ sender: Any)
    {
        
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
        
        self.uploadImgaeView.layer.borderWidth = 1
        self.uploadImgaeView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
        self.uploadImgaeView.layer.cornerRadius = 5
        
        self.photoView.layer.borderWidth = 1
        self.photoView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
        self.photoView.layer.cornerRadius = 3

        self.videoView.layer.borderWidth = 1
        self.videoView.layer.borderColor = UIColor(red:60/255, green:46/255, blue:125/255, alpha: 1).cgColor
        self.videoView.layer.cornerRadius = 3
        
        self.saveOtlet.layer.cornerRadius = 3
        self.saveOtlet.clipsToBounds = true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        print(newImage.size)
        
        dismiss(animated: true)
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
