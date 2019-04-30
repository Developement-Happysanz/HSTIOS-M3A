//
//  AddViewController.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 19/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate

{    
    @IBOutlet var dropdwnImg: UIImageView!
    
    var picker = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    var genderArr = [String]()
    
    var roles = [String]()
    
    var statusArr = [String]()
    
    var imagePicker = UIImagePickerController()
    
    var uploadedImage = UIImage()

    var touchesBegan = "0"

    var created_at = ""

    var created_by = ""
    
    var updated_at = ""
    
    var updated_by = ""
    
    var extra_curicullar_id = ""

    var house_id = ""

    var roleType = ""
    
    var status = ""
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var role: UITextField!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var gender: UITextField!
    
    @IBOutlet var dob: UITextField!
    
    @IBOutlet var nationality: UITextField!
    
    @IBOutlet var religion: UITextField!
    
    @IBOutlet var community: UITextField!
    
    @IBOutlet var caste: UITextField!
    
    @IBOutlet var address: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var secemail: UITextField!
    
    @IBOutlet var mobilenumber: UITextField!
    
    @IBOutlet var secMobileNumber: UITextField!
    
    @IBOutlet var qualification: UITextField!
    
    @IBOutlet var saveOutlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        let str = UserDefaults.standard.string(forKey: "user_View")
        
        if str == "fromAdd"
        {
            addUserDetails ()
        }
        else
        {
            editUserDetails ()
        }
    }
    @IBAction func imageButton(_ sender: Any)
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
            self.userImageView.layer.cornerRadius = userImageView.bounds.width/2
            self.userImageView.layer.borderWidth = 1
            self.userImageView.layer.borderColor = UIColor.lightGray.cgColor
            self.userImageView.clipsToBounds = true
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let _str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
        
        if _str == "YES"
        {
            self.title = "TNSRLM STAFF"
            role.attributedPlaceholder = NSAttributedString(string: "Select Status",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
           
            let myColor = UIColor.black
            role.layer.cornerRadius = 4
            role.layer.borderWidth = 1.0
            role.layer.borderColor = myColor.cgColor
        }
        else
        {
            self.title = "ADD MOBILIZER"
            role.attributedPlaceholder = NSAttributedString(string: "Select Role",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
           
            let myColor = UIColor.black
            role.layer.cornerRadius = 4
            role.layer.borderWidth = 1.0
            role.layer.borderColor = myColor.cgColor
        }
        
        saveOutlet.layer.cornerRadius = 4
        
        role.delegate = self
        
        name.delegate = self
        
        gender.delegate = self
        
        dob.delegate = self
        
        nationality.delegate = self
        
        religion.delegate = self
        
        community.delegate = self
        
        caste.delegate = self
        
        address.delegate = self
        
        email.delegate = self
        
        secemail.delegate = self
        
        mobilenumber.delegate = self
        
        secMobileNumber.delegate = self
        
        qualification.delegate = self
        
        genderArr = ["Male", "Female", "Others"]
        
        roles = ["Trainer", "Mobiliser"]
        
        statusArr = ["Active", "InActive"]
        
        let str = UserDefaults.standard.string(forKey: "user_View")
        
        if _str == "YES"
        {
            if str == "fromList"
            {
                let functionName = "apimain/user_details"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_master_id": GlobalVariables.user_master_id!]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let _status = JSON?["status"] as? String
                            if (_status == "success")
                            {
                                var userList = JSON?["userList"] as? [Any]
                                
                                for i in 0..<(userList?.count ?? 0)
                                {
                                    var dict = userList?[i] as? [AnyHashable : Any]
                                    self.address.text = (dict!["address"] as! String)
                                    self.community.text = (dict!["community"] as! String)
                                    self.caste.text = (dict!["community_class"] as! String)
                                    self.created_at = (dict!["created_at"] as! String)
                                    self.created_by = (dict!["created_by"] as! String)
                                    self.dob.text = (dict!["dob"] as! String)
                                    self.email.text = (dict!["email"] as! String)
                                    // GlobalVariables.blood_group = (dict!["extra_curicullar_id"] as! String)
                                    // GlobalVariables.city = (dict!["house_id"] as! String)
                                    GlobalVariables.user_master_id = (dict!["id"] as! String)
                                    self.name.text = (dict!["name"] as! String)
                                    self.nationality.text = (dict!["nationality"] as! String)
                                    self.mobilenumber.text = (dict!["phone"] as! String)
                                    //GlobalVariables.disability = (dict!["pia_id"] as! String)
                                    let profImage = (dict!["profile_pic"] as! String)
                                    self.qualification.text = (dict!["qualification"] as! String)
                                    self.religion.text = (dict!["religion"] as! String)
                                    self.roleType = (dict!["role_type"] as! String)
                                    self.secemail.text = (dict!["sec_email"] as! String)
                                    self.secMobileNumber.text = (dict!["sec_phone"] as! String)
                                    self.gender.text = (dict!["sex"] as! String)
                                    self.role.text = (dict!["status"] as! String)
                                    // GlobalVariables.last_studied = (dict!["status"] as! String)
                                    
                                    if profImage != ""
                                    {
                                        let baseUrl = Baseurl.baseUrl + functionName + profImage
                                        let url = URL(string:baseUrl)
                                        if let data = try? Data(contentsOf: url!)
                                        {
                                            let image: UIImage = UIImage(data: data)!
                                            self.userImageView.image = image
                                            
                                            self.uploadedImage = self.userImageView.image!
                                        }
                                    }
                                    
//                                    if self.roleType == "4"
//                                    {
//                                        self.role.text = "Trainer"
//                                    }
//                                    else
//                                    {
//                                        self.role.text = "Mobiliser"
//                                    }
//
//                                    if self.gender.text == "Male"
//                                    {
//                                        self.gender.text = "Male"
//                                    }
//                                    else if self.gender.text == "FeMale"
//                                    {
//                                        self.gender.text = "FeMale"
//                                    }
//                                    else
//                                    {
//                                        self.gender.text = "Others"
//                                    }
                                    
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
        }
        else
        {
            if str == "fromList"
            {
                let functionName = "apipia/user_details"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "user_master_id": GlobalVariables.user_master_id!]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let _status = JSON?["status"] as? String
                            if (_status == "success")
                            {
                                var userList = JSON?["userList"] as? [Any]
                                
                                for i in 0..<(userList?.count ?? 0)
                                {
                                    var dict = userList?[i] as? [AnyHashable : Any]
                                    self.address.text = (dict!["address"] as! String)
                                    self.community.text = (dict!["community"] as! String)
                                    self.caste.text = (dict!["community_class"] as! String)
                                    self.created_at = (dict!["created_at"] as! String)
                                    self.created_by = (dict!["created_by"] as! String)
                                    self.dob.text = (dict!["dob"] as! String)
                                    self.email.text = (dict!["email"] as! String)
                                    // GlobalVariables.blood_group = (dict!["extra_curicullar_id"] as! String)
                                    // GlobalVariables.city = (dict!["house_id"] as! String)
                                    GlobalVariables.user_master_id = (dict!["id"] as! String)
                                    self.name.text = (dict!["name"] as! String)
                                    self.nationality.text = (dict!["nationality"] as! String)
                                    self.mobilenumber.text = (dict!["phone"] as! String)
                                    //GlobalVariables.disability = (dict!["pia_id"] as! String)
                                    let profImage = (dict!["profile_pic"] as! String)
                                    self.qualification.text = (dict!["qualification"] as! String)
                                    self.religion.text = (dict!["religion"] as! String)
                                    self.roleType = (dict!["role_type"] as! String)
                                    self.secemail.text = (dict!["sec_email"] as! String)
                                    self.secMobileNumber.text = (dict!["sec_phone"] as! String)
                                    self.gender.text = (dict!["sex"] as! String)
                                    self.role.text = (dict!["status"] as! String)

                                    // GlobalVariables.last_studied = (dict!["status"] as! String)
                                    
                                    if profImage != ""
                                    {
                                        let baseUrl = Baseurl.baseUrl + functionName + profImage
                                        let url = URL(string:baseUrl)
                                        if let data = try? Data(contentsOf: url!)
                                        {
                                            let image: UIImage = UIImage(data: data)!
                                            self.userImageView.image = image
                                            
                                            self.uploadedImage = self.userImageView.image!
                                        }
                                    }
                                    
                                    if self.roleType == "4"
                                    {
                                        self.role.text = "Trainer"
                                    }
                                    else
                                    {
                                        self.role.text = "Mobiliser"
                                    }
                                    
                                    if self.gender.text == "Male"
                                    {
                                        self.gender.text = "Male"
                                    }
                                    else if self.gender.text == "FeMale"
                                    {
                                        self.gender.text = "FeMale"
                                    }
                                    else
                                    {
                                        self.gender.text = "Others"
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
        }
    
        
    }
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        touchesBegan = "1"
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == role
        {
            name.becomeFirstResponder()
        }
        else if textField == name
        {
            gender.becomeFirstResponder()
        }
        else if textField == gender
        {
            dob.becomeFirstResponder()
        }
        else if textField == dob
        {

        }
        else if textField == nationality
        {
            religion.becomeFirstResponder()
        }
        else if textField == religion
        {
            community.becomeFirstResponder()
        }
        else if textField == community
        {
            caste.becomeFirstResponder()
        }
        else if textField == caste
        {
            address.becomeFirstResponder()
        }
        else if textField == address
        {
            email.becomeFirstResponder()
        }
        else if textField == email
        {
            secemail.becomeFirstResponder()
        }
        else if textField == secemail
        {
            mobilenumber.becomeFirstResponder()
        }
        else if textField == mobilenumber
        {
            secMobileNumber.becomeFirstResponder()
        }
        else if textField == secMobileNumber
        {
            qualification.becomeFirstResponder()
        }
        else if textField == qualification
        {
            qualification.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == role
        {
            role.tag = 1
            gender.tag = 0
            self.pickerforGender(self.role)
        }
        else if textField == name
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == gender
        {
            role.tag = 0
            gender.tag = 2
            self.pickerforGender(self.dob)
        }
        else if textField == dob
        {
            self.pickStartDate(dob)
        }
        else if textField == nationality
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == religion
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == community
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == caste
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
        }
        else if textField == address
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == email
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == secemail
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == mobilenumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == secMobileNumber
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        else if textField == qualification
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if touchesBegan == "0"
        {
        touchesBegan = "0"
            
        if textField == role
        {
            name.becomeFirstResponder()
        }
        else if textField == name
        {
            gender.tag = 2
            gender.becomeFirstResponder()
        }
        else if textField == dob
        {
            nationality.becomeFirstResponder()
        }
        else if textField == nationality
        {
            religion.becomeFirstResponder()
        }
        else if textField == religion
        {
            community.becomeFirstResponder()
        }
        else if textField == community
        {
            caste.becomeFirstResponder()
        }
        else if textField == caste
        {
            address.becomeFirstResponder()
        }
        else if textField == address
        {
            email.becomeFirstResponder()
        }
        else if textField == email
        {
            secemail.becomeFirstResponder()
        }
        else if textField == secemail
        {
            mobilenumber.becomeFirstResponder()
        }
        else if textField == mobilenumber
        {
            secMobileNumber.becomeFirstResponder()
        }
        else if textField == secMobileNumber
        {
            qualification.becomeFirstResponder()
        }
        else if textField == qualification
        {
            qualification.resignFirstResponder()
        }
      }
        else
        {
            textField.resignFirstResponder()
            
            touchesBegan = "1"
        }
    }
    func pickerforGender(_ textField : UITextField)
    {
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(genderpickerdoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(genderpickercancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        gender.inputView = picker
        gender.inputAccessoryView = toolBar
        
        role.inputView = picker
        role.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if role.tag == 1
        {
            let _str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
            if _str == "YES"
            {
                 return statusArr.count
            }
            else
            {
                return roles.count
            }
           
        }
        else
        {
            return genderArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if role.tag == 1
        {
            let _str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
            if _str == "YES"
            {
                 return statusArr[row]
            }
            else
            {
                return roles[row]
            }
          
        }
        else
        {
            return genderArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if role.tag == 1
        {
            let _str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
            if _str == "YES"
            {
                 self.role.text = statusArr[row]
            }
            else
            {
                self.role.text = roles[row]
            }
            
        }
        else
        {
            self.gender.text = genderArr[row]
        }
    }
    
    @objc func genderpickerdoneClick ()
    {
        if role.tag == 1
        {
            let _str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
            if _str == "YES"
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                role.text = statusArr[selectedIndex]
                role.resignFirstResponder()
                name.becomeFirstResponder()
            }
            else
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                role.text = roles[selectedIndex]
                role.resignFirstResponder()
                name.becomeFirstResponder()
            }
            
        }
        else if gender.tag == 2
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            gender.text = genderArr[selectedIndex]
            gender.resignFirstResponder()
            dob.becomeFirstResponder()
        }
    }
    
    @objc func genderpickercancelClick ()
    {
        if role.tag == 1
        {
            role.resignFirstResponder()
            name.becomeFirstResponder()
        }
        else if gender.tag == 2
        {
            gender.resignFirstResponder()
            dob.becomeFirstResponder()
            self.pickStartDate(self.dob)
        }
    }
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        dob.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        dob.inputAccessoryView = toolbar
        // add datepicker to textField
        dob.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let str  = dateFormatter1.string(from: datePicker.date)
        self.dob.text = str
        dob.resignFirstResponder()
        nationality.becomeFirstResponder()
    }
    
    @objc func cancelClick()
    {
        dob.resignFirstResponder()
    }
    
    func addUserDetails ()
    {
        let str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
        
        let rolestr = self.role.text
        let namestr = self.name.text
        let genderstr = self.gender.text
        let dobstr = self.dob.text
        let nationalitystr = self.nationality.text
        let religionstr = self.religion.text
        let communitystr = self.community.text
        let castestr = self.caste.text
        let addressstr = self.address.text
        let emailstr = self.email.text
        let mobilenumberstr = self.mobilenumber.text
        let qualificationstr = self.qualification.text

        if str == "YES"
        {
            if (rolestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (namestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (genderstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (dobstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (nationalitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (religionstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (communitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (castestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (addressstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (emailstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (mobilenumberstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (qualificationstr!.isEmpty)
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
//                var roleType = self.role.text
//                if roleType == "Trainer"
//                {
//                    roleType = "4"
//                }
//                else
//                {
//                    roleType = "5"
//                }
                
                let functionName = "apimain/create_user"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"name": namestr!, "sex": genderstr!, "dob": dobstr!, "nationality": nationalitystr! , "religion": religionstr!, "community_class": communitystr!, "community": castestr!, "address": addressstr!, "email": emailstr!, "sec_email": self.secemail.text as Any, "phone": mobilenumberstr!, "sec_phone":self.secMobileNumber.text as Any, "qualification": qualificationstr!,"status":rolestr!]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let status = JSON?["status"] as? String
                            if (status == "success")
                            {
                                
                                let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                    
                                    self.role.text = ""
                                    self.name.text = ""
                                    self.gender.text = ""
                                    self.dob.text = ""
                                    self.nationality.text = ""
                                    self.religion.text = ""
                                    self.community.text = ""
                                    self.caste.text = ""
                                    self.address.text = ""
                                    self.email.text = ""
                                    self.secemail.text = ""
                                    self.mobilenumber.text = ""
                                    self.secMobileNumber.text = ""
                                    self.qualification.text = ""
                                    
                                    GlobalVariables.user_master_id = String(format: "%@",JSON?["profile_id"] as! CVarArg)
                                    self.webRequest_Image ()
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
        else
        {
            let rolestr = self.role.text
            let namestr = self.name.text
            let genderstr = self.gender.text
            let dobstr = self.dob.text
            let nationalitystr = self.nationality.text
            let religionstr = self.religion.text
            let communitystr = self.community.text
            let castestr = self.caste.text
            let addressstr = self.address.text
            let emailstr = self.email.text
            let mobilenumberstr = self.mobilenumber.text
            let qualificationstr = self.qualification.text

            if (rolestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "text", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (namestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (genderstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (dobstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (nationalitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (religionstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (communitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (castestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (addressstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (emailstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (mobilenumberstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (qualificationstr!.isEmpty)
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
                var roleType = self.role.text
                if roleType == "Trainer"
                {
                    roleType = "4"
                }
                else
                {
                    roleType = "5"
                }
                
                let functionName = "apipia/create_user"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"name": namestr!, "sex": genderstr!, "dob": dobstr!, "nationality": nationalitystr! , "religion": religionstr!, "community_class": communitystr!, "community": castestr!, "address": addressstr!, "email": emailstr!, "sec_email": self.secemail.text as Any, "phone": mobilenumberstr!, "sec_phone":self.secMobileNumber.text as Any, "qualification": qualificationstr!,"select_role":"5"]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let status = JSON?["status"] as? String
                            if (status == "success")
                            {
                                
                                let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                    
                                    self.role.text = ""
                                    self.name.text = ""
                                    self.gender.text = ""
                                    self.dob.text = ""
                                    self.nationality.text = ""
                                    self.religion.text = ""
                                    self.community.text = ""
                                    self.caste.text = ""
                                    self.address.text = ""
                                    self.email.text = ""
                                    self.secemail.text = ""
                                    self.mobilenumber.text = ""
                                    self.secMobileNumber.text = ""
                                    self.qualification.text = ""
                                    
                                    GlobalVariables.user_master_id = String(format: "%@",JSON?["profile_id"] as! CVarArg)
                                    self.webRequest_Image ()
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
        
    }
    
    func editUserDetails ()
    {
        let str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")

        if str == "YES"
        {
            let rolestr = self.role.text
            let namestr = self.name.text
            let genderstr = self.gender.text
            let dobstr = self.dob.text
            let nationalitystr = self.nationality.text
            let religionstr = self.religion.text
            let communitystr = self.community.text
            let castestr = self.caste.text
            let addressstr = self.address.text
            let emailstr = self.email.text
            let mobilenumberstr = self.mobilenumber.text
            let qualificationstr = self.qualification.text
            
            if (rolestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (namestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (genderstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (dobstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (nationalitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (religionstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (communitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (castestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (addressstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (emailstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (mobilenumberstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (qualificationstr!.isEmpty)
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
                var roleType = self.role.text
                if roleType == "Trainer"
                {
                    roleType = "4"
                }
                else
                {
                    roleType = "5"
                }
                let functionName = "apimain/update_user/"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"user_master_id":GlobalVariables.user_master_id!,"name": namestr!, "sex": genderstr!, "dob": dobstr!, "nationality": nationalitystr! , "religion": religionstr!, "community_class": communitystr!, "community": castestr!, "address": addressstr!, "email": emailstr!, "sec_email": self.secemail.text as Any, "phone": mobilenumberstr!, "sec_phone":self.secMobileNumber.text as Any, "qualification": qualificationstr!,"status":rolestr!]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let status = JSON?["status"] as? String
                            if (status == "success")
                            {
                                let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                    print("You've pressed default");
                                    
                                    self.role.text = ""
                                    self.name.text = ""
                                    self.gender.text = ""
                                    self.dob.text = ""
                                    self.nationality.text = ""
                                    self.religion.text = ""
                                    self.community.text = ""
                                    self.caste.text = ""
                                    self.address.text = ""
                                    self.email.text = ""
                                    self.secemail.text = ""
                                    self.mobilenumber.text = ""
                                    self.secMobileNumber.text = ""
                                    self.qualification.text = ""
                                    
//                                    GlobalVariables.user_master_id = String(format: "%@",JSON?["profile_id"] as! CVarArg)
//                                    self.webRequest_Image ()
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
        else
        {
            let rolestr = self.role.text
            let namestr = self.name.text
            let genderstr = self.gender.text
            let dobstr = self.dob.text
            let nationalitystr = self.nationality.text
            let religionstr = self.religion.text
            let communitystr = self.community.text
            let castestr = self.caste.text
            let addressstr = self.address.text
            let emailstr = self.email.text
            let mobilenumberstr = self.mobilenumber.text
            let qualificationstr = self.qualification.text
            
            
            if (rolestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "text", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (namestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (genderstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (dobstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (nationalitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (religionstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (communitystr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (castestr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (addressstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (emailstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (mobilenumberstr!.isEmpty)
            {
                let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else if (qualificationstr!.isEmpty)
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
                var roleType = self.role.text
                if roleType == "Trainer"
                {
                    roleType = "4"
                }
                else
                {
                    roleType = "5"
                }
                let functionName = "apipia/update_user/"
                let baseUrl = Baseurl.baseUrl + functionName
                let url = URL(string: baseUrl)!
                let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"user_master_id":GlobalVariables.user_master_id!,"name": namestr!, "sex": genderstr!, "dob": dobstr!, "nationality": nationalitystr! , "religion": religionstr!, "community_class": communitystr!, "community": castestr!, "address": addressstr!, "email": emailstr!, "sec_email": self.secemail.text as Any, "phone": mobilenumberstr!, "sec_phone":self.secMobileNumber.text as Any, "qualification": qualificationstr!,"select_role":rolestr!]
                
                Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                            print(response)
                            let JSON = response.result.value as? [String: Any]
                            let msg = JSON?["msg"] as? String
                            let status = JSON?["status"] as? String
                            if (status == "success")
                            {
                                let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                    print("You've pressed default");
                                    
                                    self.role.text = ""
                                    self.name.text = ""
                                    self.gender.text = ""
                                    self.dob.text = ""
                                    self.nationality.text = ""
                                    self.religion.text = ""
                                    self.community.text = ""
                                    self.caste.text = ""
                                    self.address.text = ""
                                    self.email.text = ""
                                    self.secemail.text = ""
                                    self.mobilenumber.text = ""
                                    self.secMobileNumber.text = ""
                                    self.qualification.text = ""
                                    
//                                    GlobalVariables.user_master_id = String(format: "%@",JSON?["profile_id"] as! CVarArg)
//                                    self.webRequest_Image ()
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
        
    }
    func webRequest_Image ()
    {
        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)

        if imgData == nil
        {
            let alertController = UIAlertController(title: "M3", message: "successfully updated", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
                
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        let functionName = "apipia/user_profilepic/"
            let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.user_master_id!
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
                        if (response.result.value as? NSDictionary) != nil{
                            
                            let alertController = UIAlertController(title: "M3", message: "Sucess", preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                                self.dismiss(animated: true, completion: nil)
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
