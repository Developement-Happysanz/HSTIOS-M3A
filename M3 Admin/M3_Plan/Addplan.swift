//
//  Addplan.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 24/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import Foundation
import MobileCoreServices
import MBProgressHUD

class Addplan: UIViewController,UIDocumentPickerDelegate,UINavigationControllerDelegate,UITextFieldDelegate
{
    
    var myData = ""
    
    var myURL: URL!
    
    var datePicker = UIDatePicker()
    
    @IBOutlet var titleName: UITextField!
    
    @IBOutlet var dateTextfiled: UITextField!
    
    @IBOutlet var documentOutlet: UIButton!
    
    @IBOutlet var saveOutlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
     
      //  self.webrequest(fileName: strFilename, lastcomp: lastComponent!, fileUrl:erfl)
        
        let title = titleName.text
        let date = dateTextfiled.text
        if (title == "")
        {
            let alertController = UIAlertController(title: "M3", message: "title is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if (date == "")
        {
            let alertController = UIAlertController(title: "M3", message: "date is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if (myURL == nil)
        {
            let alertController = UIAlertController(title: "M3", message: "select any file", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            let lastWord = myURL.lastPathComponent
            print(lastWord)
            
            print(myURL)
            let pathString = myURL.path
            let lastComponent = pathString.components(separatedBy: ".").last
            print(lastComponent!)
            
            let strFilename = String(format: "%@%@","file.",lastComponent!)
            print(strFilename)
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            do {
                let imageData = try Data(contentsOf: myURL as URL)
                let functionName = "apipia/mobilization_plan/"
                let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.user_id! + "/" + title! + "/" + date! + "/"
                let base = baseUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let url = URL(string: base)!
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData, withName: "doc_file",fileName: strFilename, mimeType: lastComponent!)
                    
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
                                let JSON = response.result.value as? [String: Any]
                                let msg = JSON?["msg"] as? String
                                
                                if (msg == "Plan Added")
                                {
                                    let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                    let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                       
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
                            }
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
                // profileImageView.image = UIImage(data: imageData)
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    @IBAction func document(_ sender: Any)
    {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Add Plan"
        
        NavigationBarTitleColor.navbar_TitleColor
        
        documentOutlet.layer.cornerRadius = 4
        
        saveOutlet.layer.cornerRadius = 4
        
        titleName.delegate = self
        
        dateTextfiled.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        myURL = url as URL
        print("import result : \(String(describing: myURL))")

//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-100, width: 180, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
//        toastLabel.text = "File is ready to upload"
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // Set the text mode to show only text.
        //hud.mode = MBProgressHUDModeText
        hud.label.text = "File is ready to upload"
        // Move to bottm center.
        hud.offset = CGPoint(x: 0.0, y: CGFloat(MBProgressMaxOffset))
        
        hud.hide(animated: true, afterDelay: 2.0)
        
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
         print("view was cancelled")
         self.navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == titleName
        {
            titleName.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == dateTextfiled
        {
            self.pickStartDate(self.dateTextfiled)
        }
    }
    
    func pickStartDate(_ textField : UITextField)
    {
        //Formate Date
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
//        let now = Date();
//        datePicker.minimumDate = now
        dateTextfiled.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        dateTextfiled.inputAccessoryView = toolbar
        // add datepicker to textField
        dateTextfiled.inputView = datePicker
        
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateTextfiled.text = dateFormatter1.string(from: datePicker.date)
        print(dateTextfiled.text as Any)
        dateTextfiled.resignFirstResponder()
    }
    
    @objc func cancelClick()
    {
        dateTextfiled.resignFirstResponder()
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
