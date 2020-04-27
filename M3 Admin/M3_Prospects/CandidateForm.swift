//
//  CandidateForm.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 12/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import MBProgressHUD

class CandidateForm: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate
{
        
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var locationisUpdate = "YES"
    var hour = ""
    var minutes = ""
    var admission_date = ""
    var latitudeCurrentLocation: CLLocationDegrees = 0.0
    var longitudeCurrentLocation: CLLocationDegrees = 0.0
    var uploadedImage = UIImage()
    var student_id = ""
    var touchesBegan = "0"
    var bloodgroupArr : NSMutableArray = NSMutableArray()
    var bloodgroup_id : NSMutableArray = NSMutableArray()
    var streetName = ""
    var _id = [String]()
    var tradename = [String]()
    var trade_id = ""
    var studentPic = String()
    var statusArr = [String]()
    
    var imagePicker = UIImagePickerController()
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    var genderPicker = [String]()
    var bloodgroup = [String]()
    var is_disablity = true
    var is_tc = true
    var is_adharcard = true
    var disablity = ""
    var is_transfercert = ""
    var is_adhar = ""
    var qualifieedPromoArray = [String]()
    var qualificatioArray = [String]()
    var jobCardArray = [String]()
    var years = [String]()


    @IBOutlet var submitOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var nationality: UITextField!
    @IBOutlet weak var religion: UITextField!
    @IBOutlet weak var caste: UITextField!
    @IBOutlet weak var casteName: UITextField!
    @IBOutlet weak var bloodGroup: UITextField!
    @IBOutlet weak var fatherName: UITextField!
    @IBOutlet weak var motherName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var mobilenumberSecondary: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var disabilityImageView: UIImageView!
    
    @IBOutlet weak var degree: UITextField!
    @IBOutlet weak var yearOfEducation: UITextField!
    @IBOutlet weak var yearOfPassing: UITextField!
    @IBOutlet weak var identificationMarksOne: UITextField!
    @IBOutlet weak var identificationMarksTwo: UITextField!
    @IBOutlet weak var headOfFamily: UITextField!
    @IBOutlet weak var highestEducationQualification: UITextField!
    @IBOutlet weak var fatherMobileNumber: UITextField!
    @IBOutlet weak var motherMobileNumber: UITextField!
    @IBOutlet weak var yearlyIncome: UITextField!
    @IBOutlet weak var languageKnown: UITextField!
    @IBOutlet weak var numberOfMembersInFamily: UITextField!
    @IBOutlet weak var tcImageView: UIImageView!
    @IBOutlet weak var adharImageview: UIImageView!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var graduation: UITextField!
    @IBOutlet weak var adharNumber: UITextField!
    @IBOutlet weak var jobCard: UITextField!
    @IBOutlet weak var motherTonque: UITextField!
    @IBOutlet weak var qualifiedPromotion: UITextField!
    @IBOutlet weak var lastStudied: UITextField!
    
    override func viewDidLoad() {
           super.viewDidLoad()

           // Do any additional setup after loading the view.
           self.title = "Add candidate"
           tradeValues()
           if (CLLocationManager.locationServicesEnabled())
           {
               locationManager = CLLocationManager()
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestAlwaysAuthorization()
               locationManager.startUpdatingLocation()
           }
        
           self.qualifieedPromoArray = ["Pass","Fail","DropOut"]

           let date = Date()
           let calendar = Calendar.current
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-mm-dd"
           hour = String(Int(calendar.component(.hour, from: date)))
           minutes = String(Int(calendar.component(.minute, from: date)))
           admission_date = formatter.string(from: date)
           
           qualifiedPromotion.delegate = self
           lastStudied.delegate = self
           fullName.delegate = self
           gender.delegate = self
           dob.delegate = self
           age.delegate = self
           religion.delegate = self
           nationality.delegate = self
           caste.delegate = self
           casteName.delegate = self
           bloodGroup.delegate = self
           fatherName.delegate = self
           motherName.delegate = self
           mobileNumber.delegate = self
           mobilenumberSecondary.delegate = self
           emailId.delegate = self
           state.delegate = self
           city.delegate = self
           addressLine1.delegate = self
           addressLine2.delegate = self
           motherTonque.delegate = self
           department.delegate = self
           graduation.delegate = self
           adharNumber.delegate = self
           degree.delegate = self
           yearOfEducation.delegate = self
           yearOfPassing.delegate = self
           identificationMarksOne.delegate = self
           identificationMarksTwo.delegate = self
           headOfFamily.delegate = self
           highestEducationQualification.delegate = self
           fatherMobileNumber.delegate = self
           motherMobileNumber.delegate = self
           yearlyIncome.delegate = self
           languageKnown.delegate = self
           numberOfMembersInFamily.delegate = self
           jobCard.delegate = self

           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tap)
           navigationLetfButton ()
           let _View =  UserDefaults.standard.string(forKey: "View")
           if _View == "fromadharView"
           {
               
               if GlobalVariables.studentname != ""
               {
                   fullName.text = GlobalVariables.studentname
               }
               if GlobalVariables.sex != ""
               {
                   if GlobalVariables.sex == "M"
                   {
                       gender.text = "Male"
                   }
                   else if  GlobalVariables.sex == "F"
                   {
                       gender.text = "FeMale"
                   }
                   else
                   {
                       gender.text = "Other"
                   }
               }
               if GlobalVariables.dob != ""
               {
                   dob.text = GlobalVariables.dob
               }
               if GlobalVariables.aadhaar_card_number != ""
               {
                   adharNumber.text = GlobalVariables.aadhaar_card_number
               }
               if GlobalVariables.father_name != ""
               {
                   fatherName.text = GlobalVariables.father_name
               }
               if GlobalVariables.address != ""
               {
                   addressLine1.text = GlobalVariables.address
               }
               if GlobalVariables.state != ""
               {
                   state.text = GlobalVariables.state
               }
               if GlobalVariables.city != ""
               {
                   city.text = GlobalVariables.city
                   addressLine2.text = GlobalVariables.city
               }
               if GlobalVariables.pincode != ""
               {
//                   addressLine3.text = GlobalVariables.pincode
               }
           }
//           else if _View == "fromaddprospectView"
//           {
//
//           }
//           else
//           {
//           tradeValues ()
//           viewStudentsDetails ()
//           }
           
           genderPicker = ["Male", "Female", "Others"]
           bloodgroup = ["A+", "B+", "AB+"]
           statusArr = ["Confirmed","Rejected"]
           is_disablity = false
           submitOutlet.layer.cornerRadius = 4
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           
           //done button & cancel button
           let doneButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ageDoneClick))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(agecancelClick))
           toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
           
           // add toolbar to textField
           age.inputAccessoryView = toolbar
           let toolbarAdhar = UIToolbar();
           toolbarAdhar.sizeToFit()
           
           //done button & cancel button
           let doneadharButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(adharDoneClick))
           let spaceadharButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let canceladharButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(adharcancelClick))
           toolbarAdhar.setItems([canceladharButton,spaceadharButton,doneadharButton], animated: false)
           adharNumber.inputAccessoryView = toolbarAdhar
        
            self.yearsForPickerView()
            self.qualificatioArray = ["School","UG","PG","Diploma","Others"]
            self.jobCardArray = ["MGNRGEA","BPL/PIP Card"]
        }
        
        func yearsForPickerView()
        {
            var formattedDate: String? = ""
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy"
            formattedDate = format.string(from: date)
            
            for i in (Int(formattedDate!)!-70..<Int(formattedDate!)!+1).reversed() {
                    years.append("\(i)")
                }

            print(years)
        }
    
        func pickStartDate(_ textField : UITextField)
        {
            self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.datePicker.backgroundColor = UIColor.white
            self.datePicker.datePickerMode = .date
            dob.inputView = self.datePicker
            datePicker.setValue(UIColor.black, forKeyPath: "textColor")
            // ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            
            // Done button & cancel button
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
            // Add toolbar to textField
            dob.inputAccessoryView = toolbar
            // Add datepicker to textField
            dob.inputView = datePicker
        }
        
        @objc func startDateDoneClick()
        {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            dob.text = dateFormatter1.string(from: datePicker.date)
            let dobToAge = getAgeFromDOF(date: dob.text!)
            self.age.text = String(dobToAge)
            dob.resignFirstResponder()
            religion.becomeFirstResponder()
        }
        
        @objc func cancelClick()
        {
            dob.resignFirstResponder()
            religion.becomeFirstResponder()
        }
        
        func pickerforGender(_ textField : UITextField)
        {
            picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            picker.backgroundColor = .white
            picker.setValue(UIColor.black, forKeyPath: "textColor")
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
            
            bloodGroup.inputView = picker
            bloodGroup.inputAccessoryView = toolBar
            
            department.inputView = picker
            department.inputAccessoryView = toolBar
            
            yearOfPassing.inputView = picker
            yearOfPassing.inputAccessoryView = toolBar
            
            yearOfEducation.inputView = picker
            yearOfEducation.inputAccessoryView = toolBar
            
            graduation.inputView = picker
            graduation.inputAccessoryView = toolBar
            
            jobCard.inputView = picker
            jobCard.inputAccessoryView = toolBar
            
            qualifiedPromotion.inputView = picker
            qualifiedPromotion.inputAccessoryView = toolBar


        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            if gender.isFirstResponder
            {
                return genderPicker.count
            }
            else if bloodGroup.isFirstResponder
            {
                return bloodgroupArr.count
            }
            else if department.isFirstResponder
            {
                return tradename.count
            }
            else if qualifiedPromotion.isFirstResponder
            {
                return qualifieedPromoArray.count
            }
            else if yearOfPassing.isFirstResponder
            {
                return years.count
            }
            else if yearOfEducation.isFirstResponder
            {
                return years.count
            }
            else if graduation.isFirstResponder
            {
                return qualificatioArray.count
            }
            else
            {
                return jobCardArray.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
        {
            if gender.isFirstResponder
            {
                 return genderPicker[row]
            }
            else if bloodGroup.isFirstResponder
            {
                return (bloodgroupArr[row] as! String)
            }
            else if department.isFirstResponder
            {
                return tradename[row]
            }
            else if qualifiedPromotion.isFirstResponder
            {
                return qualifieedPromoArray [row]
            }
            else if yearOfPassing.isFirstResponder
            {
                return years[row]
            }
            else if yearOfEducation.isFirstResponder
            {
                return years[row]
            }
            else if graduation.isFirstResponder
            {
                return qualificatioArray[row]
            }
            else
            {
                return jobCardArray[row]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {
            if gender.isFirstResponder
            {
                self.gender.text = genderPicker[row]
            }
            else if bloodGroup.isFirstResponder
            {
                self.bloodGroup.text = (bloodgroupArr[row] as! String)
            }
            else if department.isFirstResponder
            {
                self.department.text = tradename[row]
                trade_id = _id[row]
                print(_id)
                print(trade_id)
            }
            else if qualifiedPromotion.isFirstResponder
            {
                self.qualifiedPromotion.text = qualifieedPromoArray[row]
            }
            else if yearOfPassing.isFirstResponder
            {
                self.yearOfPassing.text = years[row]
            }
            else if yearOfEducation.isFirstResponder
            {
                self.yearOfEducation.text = years[row]
            }
            else if graduation.isFirstResponder
            {
                self.graduation.text = qualificatioArray[row]
            }
            else
            {
                self.jobCard.text = jobCardArray[row]
            }
        }
        
        @objc func genderpickerdoneClick ()
        {
            if gender.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                gender.text = genderPicker[selectedIndex]
                gender.resignFirstResponder()
                dob.becomeFirstResponder()
            }
            else if bloodGroup.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                bloodGroup.text = (bloodgroupArr[selectedIndex] as! String)
                bloodGroup.resignFirstResponder()
                motherName.becomeFirstResponder()
            }
            else if department.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                department.text = tradename[selectedIndex]
                trade_id = _id[selectedIndex]
                print(trade_id)
                department.resignFirstResponder()
    //            graduation.becomeFirstResponder()
            }
            else if qualifiedPromotion.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                qualifiedPromotion.text = qualifieedPromoArray [selectedIndex]
                qualifiedPromotion.resignFirstResponder()
                lastStudied.becomeFirstResponder()
            }
            else if yearOfEducation.isFirstResponder
            {
                 let selectedIndex = picker.selectedRow(inComponent: 0)
                 yearOfEducation.text = years[selectedIndex]
                 yearOfEducation.resignFirstResponder()
                 yearOfPassing.becomeFirstResponder()
            }
            else if yearOfPassing.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                yearOfPassing.text = years[selectedIndex]
                yearOfPassing.resignFirstResponder()
                identificationMarksOne.becomeFirstResponder()
            }
            else if graduation.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                graduation.text = qualificatioArray[selectedIndex]
                graduation.resignFirstResponder()
                degree.becomeFirstResponder()
            }
            else
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                jobCard.text = jobCardArray[selectedIndex]
                jobCard.resignFirstResponder()
            }
        }
        
        @objc func genderpickercancelClick ()
        {
            if gender.isFirstResponder
            {
                gender.resignFirstResponder()
                dob.becomeFirstResponder()
            }
            else if bloodGroup.isFirstResponder
            {
                bloodGroup.resignFirstResponder()
                motherName.becomeFirstResponder()
            }
            else if department.isFirstResponder
            {
                department.resignFirstResponder()
            }
            else if qualifiedPromotion.isFirstResponder
            {
                lastStudied.becomeFirstResponder()
            }
            else if yearOfEducation.isFirstResponder
            {
                 yearOfPassing.becomeFirstResponder()
            }
            else if yearOfPassing.isFirstResponder
            {
                identificationMarksOne.becomeFirstResponder()
            }
            else if graduation.isFirstResponder
            {
                degree.becomeFirstResponder()
            }
            else
            {
                jobCard.resignFirstResponder()
                self.view.endEditing(true);
            }
        }
        
        @objc func ageDoneClick ()
        {
            religion.becomeFirstResponder()
        }
        
        @objc func agecancelClick ()
        {
            age.resignFirstResponder()
        }
        
        @objc func adharDoneClick ()
        {
            adharNumber.resignFirstResponder()
        }
        
        @objc func adharcancelClick ()
        {
            adharNumber.resignFirstResponder()
        }
                
    
    func _bloodGroup ()
    {
        let function = "apimobilizer/select_bloodgroup/"
        let baseUrl = Baseurl.baseUrl + function
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
        
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
                    self.bloodgroupArr.removeAllObjects()
                    self.bloodgroup_id.removeAllObjects()
                    if (status == "success")
                    {
                        let bloodgroup = JSON?["Bloodgroup"] as? [Any]
                        
                        for i in 0..<(bloodgroup?.count ?? 0)
                        {
                            let dict = bloodgroup?[i] as? [AnyHashable : Any]
                            let blood_group_name = dict?["blood_group_name"] as? String
                            let blood_group_id = dict?["id"] as? String
                            
                            self.bloodgroupArr.add(blood_group_name!)
                            self.bloodgroup_id.add(blood_group_id!)
                        }
                        
                        let _View =  UserDefaults.standard.string(forKey: "View")
                        if _View == "fromstudentView"
                        {
                            self.viewStudentsDetails ()
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
    
    func tradeValues ()
    {
       let functionName = "apipia/list_trade/"
       let baseUrl = Baseurl.baseUrl + functionName
       let url = URL(string: baseUrl)!
       let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
    
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
            let tradeList = JSON?["tradeList"] as? [Any]
        for i in 0..<(tradeList?.count ?? 0)
        {
            let dict = tradeList?[i] as? [AnyHashable : Any]
            let trade_name = dict?["trade_name"] as? String
            let trade_id = dict?["id"] as? String
            
            self.tradename.append(trade_name!)
            self._id.append(trade_id!)
        }
            
            self._bloodGroup ()
            
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
       
       override func viewDidLayoutSubviews()
       {
          super.viewDidLayoutSubviews()
       }
    
    @IBAction func submitButton(_ sender: Any)
    {
         GlobalVariables.studentname = fullName.text
                    GlobalVariables.sex = gender.text
                    let _age = age.text
                    let _religion = religion.text
                    let _community = casteName.text
                    let _dob = dob.text
                    let _nationality = nationality.text
                    let _caste = caste.text
                    let _bloodgroup = bloodGroup.text
                    GlobalVariables.father_name = fatherName.text
                    let _motherName = motherName.text
                    let _mobileNumber = mobileNumber.text
                    let _seccondarymobNum = mobilenumberSecondary.text
                    let _mailId = emailId.text
                    let _qualification = graduation.text

                    let _degree = degree.text
                    let _QulaifiedPromo = qualifiedPromotion.text
                    let _lastStudied = lastStudied.text
                    let _yearOfEducation = yearOfEducation.text
                    let _yearofPassing = yearOfPassing.text
                    let _identificationMarksOne = identificationMarksOne.text
                    let _identificationMarksTwo = identificationMarksTwo.text

                    let _headOfFamily = headOfFamily.text
                    let _highestEducation = highestEducationQualification.text
                    let _fatherMobile = fatherMobileNumber.text
                    let _motherMobile = motherMobileNumber.text
                    let _yearlyIncome = yearlyIncome.text
                    let _languagesKnown = languageKnown.text
                    let _numberOfMembers = numberOfMembersInFamily.text

                    let _state = state.text
                    let _city = city.text
                    GlobalVariables.address = addressLine1.text
                    let _address2 = addressLine2.text
                    let _motherTonque = motherTonque.text
                    let _adharNumber = adharNumber.text
                    let _jobCard = jobCard.text

        //          let dateFormatter : DateFormatter = DateFormatter()
        //          dateFormatter.dateFormat = "HH:mm:ss"
        //          let date = Date()
        //          let preferred_timing = dateFormatter.string(from: date)
                    let dateformatter4 = DateFormatter()
                    dateformatter4.dateFormat = "yyyy-MM-dd hh:mm"
                    let now = Date()
                    let admisiondate = dateformatter4.string(from: now)
                    print(_address2!,self.trade_id)
                    let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
                    if imgData == nil
                    {
                        let alertController = UIAlertController(title: "M3", message: "Image is mandatory", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (GlobalVariables.studentname!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (GlobalVariables.sex!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_age!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (Int(_age!)! < 15)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_dob!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_religion!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_community!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_caste!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_bloodgroup!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (GlobalVariables.father_name!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_motherName!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_mobileNumber!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_mailId!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_qualification!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_degree!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_QulaifiedPromo!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_lastStudied!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_yearOfEducation!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_yearofPassing!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_yearOfEducation! > _yearofPassing!)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_identificationMarksOne!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_identificationMarksTwo!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_headOfFamily!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_highestEducation!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_fatherMobile!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_motherMobile!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_yearlyIncome!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_languagesKnown!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_numberOfMembers!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_state!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_city!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (GlobalVariables.address!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (self.department.text!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if (_adharNumber!.isEmpty)
                    {
                        let alertController = UIAlertController(title: "M3", message: "empty", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else
                    {
                        let _View =  UserDefaults.standard.string(forKey: "View")
                        if _View == "fromaddprospectView"
                        {
                            let baseUrl = Baseurl.baseUrl + "apipia/add_student"
                            let url = URL(string: baseUrl)!
                            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "pia_id": GlobalVariables.pia_id!, "name": GlobalVariables.studentname!, "sex": GlobalVariables.sex!, "dob":_dob!, "age": _age!, "nationality": _nationality!, "religion": _religion!, "community_class": _community!, "community": _caste!, "blood_group": _bloodgroup!,  "father_name": GlobalVariables.father_name!, "mother_name": _motherName!, "mobile": _mobileNumber!, "sec_mobile": _seccondarymobNum!, "email": _mailId!, "qualification": _qualification!, "qualification_details": _degree!,"qualified_promotion": _QulaifiedPromo!, "last_studied": _lastStudied!, "year_of_edu": _yearOfEducation!, "year_of_pass": _yearofPassing!, "identification_mark_1": _identificationMarksOne!, "identification_mark_2": _identificationMarksTwo!, "head_family_name": _headOfFamily!, "head_family_edu": _highestEducation!, "no_family": _numberOfMembers!, "mother_tongue": _motherTonque!, "lang_known": _languagesKnown!, "yearly_income": _yearlyIncome!, "father_mobile": _fatherMobile!, "mother_mobile": _motherMobile!, "jobcard_type": _jobCard!, "state": _state!, "city": _city!, "address": GlobalVariables.address!, "disability": disablity, "aadhaar_card_number": _adharNumber!, "admission_date": admisiondate, "admission_location": self.streetName, "preferred_trade": self.trade_id, "admission_latitude": latitudeCurrentLocation, "admission_longitude": longitudeCurrentLocation, "status": "Pending", "created_at": admisiondate,"created_by": GlobalVariables.user_id!]

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
                                            GlobalVariables.studentid = String(format: "%@",JSON?["admission_id"] as! CVarArg)
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
                        else
                        {
                            let baseUrl = Baseurl.baseUrl + "apipia/update_student"
                            let url = URL(string: baseUrl)!
                            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "pia_id": GlobalVariables.pia_id!, "admission_id": GlobalVariables.studentid!, "name": GlobalVariables.studentname!, "sex": GlobalVariables.sex!, "dob":_dob!, "age": _age!, "nationality": _nationality!, "religion": _religion!, "community_class": _community!, "community": _caste!, "blood_group": _bloodgroup!,  "father_name": GlobalVariables.father_name!, "mother_name": _motherName!, "mobile": _mobileNumber!, "sec_mobile": _seccondarymobNum!, "email": _mailId!, "qualification": _qualification!, "qualification_details": _degree!, "qualified_promotion": _QulaifiedPromo!, "last_studied": _lastStudied!, "year_of_edu": _yearOfEducation!, "year_of_pass": _yearofPassing!, "identification_mark_1": _identificationMarksOne!, "identification_mark_2": _identificationMarksTwo!, "head_family_name": _headOfFamily!, "head_family_edu": _highestEducation!, "no_family": _numberOfMembers!, "mother_tongue": _motherTonque!, "lang_known": _languagesKnown!, "yearly_income": _yearlyIncome!, "father_mobile": _fatherMobile!, "mother_mobile": _motherMobile!, "jobcard_type": _jobCard!, "state": _state!, "city": _city!, "address": GlobalVariables.address!, "disability": disablity, "aadhaar_card_number": _adharNumber!, "admission_date": admisiondate, "admission_location": self.streetName, "preferred_trade": self.trade_id, "admission_latitude": latitudeCurrentLocation, "admission_longitude": longitudeCurrentLocation, "status": "Pending", "created_at": admisiondate,"created_by": GlobalVariables.user_id!]

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
                                               self.performSegue(withIdentifier: "documentListPage", sender: self)
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
//        let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
//        if imgData != nil
//        {
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//            let functionName = "apipia/student_picupload/"
//            let baseUrl = Baseurl.baseUrl + functionName + student_id
//            let url = URL(string: baseUrl)!
//
//            Alamofire.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(imgData!, withName: "student_pic",fileName: "file.jpg", mimeType: "image/jpg")
//            },
//                             to:url)
//            { (result) in
//                switch result {
//                case .success(let upload, _, _):
//
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    })
//
//                    upload.responseJSON { response in
//                        print(response.result.value as Any)
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                        if (response.result.value as? NSDictionary) != nil
//                        {
//
//                            self.performSegue(withIdentifier: "form_List", sender: self)
//                        }
//                    }
//                            case .failure(let encodingError):
//                                print(encodingError)
//                            }
//                        }
//                    }
//        else
//        {
//            //self.navigationController?.popViewController(animated: true)
//             self.performSegue(withIdentifier: "form_List", sender: self)
//        }
        
           MBProgressHUD.showAdded(to: self.view, animated: true)
           let imgData = uploadedImage.jpegData(compressionQuality: 0.75)
           let functionName = "apipia/student_picupload/"
           let baseUrl = Baseurl.baseUrl + functionName + GlobalVariables.studentid!
           let url = URL(string: baseUrl)!
           Alamofire.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData!, withName: "student_pic",fileName: "file.jpg", mimeType: "image/jpg")
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
                      //    ActivityIndicator().hideActivityIndicator(uiView: self.view)
                       MBProgressHUD.hide(for: self.view, animated: true)
                       if (response.result.value as? NSDictionary) != nil
                       {
                           self.performSegue(withIdentifier: "to_Documentation", sender: self)
                       }
                   }
               case .failure(let encodingError):
                   print(encodingError)
               }
           }
    }
    
    @IBAction func disabilityButton(_ sender: Any)
    {
        if is_disablity == false
        {
            disabilityImageView.image = UIImage(named: "rec-01.png")
            is_disablity = true
            disablity = "1"
        }
        else
        {
            disabilityImageView.image = UIImage(named: "rec1.png")
            is_disablity = false
            disablity = "0"
        }
    }
        
    @IBAction func adharButton(_ sender: Any)
    {
        if is_adharcard == false
        {
            adharImageview.image = UIImage(named: "rec-01.png")
            is_adharcard = true
            is_adhar = "1"
        }
        else
        {
            adharImageview.image = UIImage(named: "rec1.png")
            is_adharcard = false
            is_adhar = "0"
        }
    }
    
    @IBAction func tcButton(_ sender: Any)
    {
        if is_tc == false
        {
            tcImageView.image = UIImage(named: "rec-01.png")
            is_tc = true
            is_transfercert = "1"
        }
        else
        {
            tcImageView.image = UIImage(named: "rec1.png")
            is_tc = false
            is_transfercert = "0"
        }
    }
    
    @IBAction func profilrImageButton(_ sender: Any)
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
            self.studentImage.image = editedImage
            self.studentImage.layer.cornerRadius = studentImage.bounds.width/2
            self.studentImage.layer.borderWidth = 1
            self.studentImage.layer.borderColor = UIColor.lightGray.cgColor
            self.studentImage.clipsToBounds = true
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locationisUpdate == "YES"
        {
            locationManager.stopUpdatingLocation()
            let location = locations.last! as CLLocation
            
            /* you can use these values*/
            latitudeCurrentLocation = location.coordinate.latitude
            longitudeCurrentLocation = location.coordinate.longitude
            locationisUpdate = "NO"
            locationName ()
        }
    }
    
    func locationName ()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude:latitudeCurrentLocation, longitude:longitudeCurrentLocation)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                if let locationName = placeMark.locality {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.subLocality
                {
                    print(street)
                    self.streetName = String(format: "%@",street)
                }
                //   City
                if let city = placeMark.subAdministrativeArea {
                    print(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print(zip)
                }
                // Country
                if let country = placeMark.country {
                    print(country)
                }
        })
    }
    
    func navigationLetfButton ()
    {
        let navigationLetfButton = UIButton(type: .custom)
        navigationLetfButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLetfButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLetfButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLetfButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func clickButton()
    {
        
        let _View =  UserDefaults.standard.string(forKey: "View")

        if _View == "fromstudentView"
        {
            self.performSegue(withIdentifier: "form_List", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "back_selectPage", sender: self)
        }
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        touchesBegan = "1"
        view.endEditing(true)
    }

    func viewStudentsDetails ()
    {
        let functionName = "apipia/view_student"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["student_id": GlobalVariables.studentid!]
        
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
                        let studentDetails = JSON?["studentDetails"] as? [Any]
                        
                        for i in 0..<(studentDetails?.count ?? 0)
                        {
                            let dict = studentDetails?[i] as? [AnyHashable : Any]
                            GlobalVariables.aadhaar_card_number = (dict!["aadhaar_card_number"] as! String)
                            GlobalVariables.address = (dict!["address"] as! String)
                            GlobalVariables.admission_date = (dict!["admission_date"] as! String)
                            GlobalVariables.admission_latitude = (dict!["admission_latitude"] as! String)
                            GlobalVariables.admission_location = (dict!["admission_location"] as! String)
                            GlobalVariables.admission_longitude = (dict!["admission_longitude"] as! String)
                            GlobalVariables.aadhaar_card_number = (dict!["aadhaar_card_number"] as! String)
                            GlobalVariables.age = (dict!["age"] as! String)
                            GlobalVariables.blood_group = (dict!["blood_group"] as! String)
                            GlobalVariables.city = (dict!["city"] as! String)
                            GlobalVariables.community = (dict!["community"] as! String)
                            GlobalVariables.community_class = (dict!["community_class"] as! String)
                            GlobalVariables.created_at = (dict!["created_at"] as! String)
                            GlobalVariables.created_by = (dict!["created_by"] as! String)
                            GlobalVariables.disability = (dict!["disability"] as! String)
                            GlobalVariables.dob = (dict!["dob"] as! String)
                            GlobalVariables.email = (dict!["email"] as! String)
                            GlobalVariables.enrollment = (dict!["enrollment"] as! String)
                            GlobalVariables.father_name = (dict!["father_name"] as! String)
                            GlobalVariables.have_aadhaar_card = (dict!["have_aadhaar_card"] as! String)
                            GlobalVariables.studentid = (dict!["id"] as! String)
                            GlobalVariables.last_institute = (dict!["last_institute"] as! String)
                            GlobalVariables.last_studied = (dict!["last_studied"] as! String)
                            GlobalVariables.mobile = (dict!["mobile"] as! String)
                            GlobalVariables.mother_name = (dict!["mother_name"] as! String)
                            GlobalVariables.mother_tongue = (dict!["mother_tongue"] as! String)
                            GlobalVariables.studentname = (dict!["name"] as! String)
                            GlobalVariables.nationality = (dict!["nationality"] as! String)
                            GlobalVariables.pia_id = (dict!["pia_id"] as! String)
                            GlobalVariables.preferred_timing = (dict!["preferred_timing"] as! String)
                            GlobalVariables.preferred_trade = (dict!["preferred_trade"] as! String)
                            self.trade_id = (dict!["preferred_trade"] as! String)
                            GlobalVariables.qualified_promotion = (dict!["qualified_promotion"] as! String)
                            GlobalVariables.religion = (dict!["religion"] as! String)
                            GlobalVariables.sec_mobile = (dict!["sec_mobile"] as! String)
                            GlobalVariables.sex = (dict!["sex"] as! String)
                            GlobalVariables.state = (dict!["state"] as! String)
                            GlobalVariables.status = (dict!["status"] as! String)
                            GlobalVariables.student_pic = (dict!["student_pic"] as! String)
//                            GlobalVariables.transfer_certificate = (dict!["transfer_certificate"] as! String)
                            GlobalVariables.updated_at = (dict!["updated_at"] as! String)
                            GlobalVariables.updated_by = (dict!["updated_by"] as! String)
//                            self.statusTxtFiled.text = (dict!["status"] as! String)
                            
                            GlobalVariables.degree = (dict!["qualification_details"] as! String)
                            GlobalVariables.yearOfEducation = (dict!["year_of_edu"] as! String)
                            GlobalVariables.yearofPassing = (dict!["year_of_pass"] as! String)
                            GlobalVariables.identificationMarksOne = (dict!["identification_mark_1"] as! String)
                            GlobalVariables.identificationMarksTwo = (dict!["identification_mark_2"] as! String)
                            GlobalVariables.headOfFamily = (dict!["head_family_name"] as! String)
                            GlobalVariables.highestEducation = (dict!["head_family_edu"] as! String)
                            GlobalVariables.fatherMobile = (dict!["father_mobile"] as! String)
                            GlobalVariables.motherMobile = (dict!["mother_mobile"] as! String)
                            GlobalVariables.yearlyIncome = (dict!["yearly_income"] as! String)
                            GlobalVariables.languagesKnown = (dict!["lang_known"] as! String)
                            GlobalVariables.numberOfMembers = (dict!["no_family"] as! String)
                            GlobalVariables.jobCard = (dict!["jobcard_type"] as! String)
                            GlobalVariables.qualification = (dict!["qualification"] as! String)

                        }
                        
                            self.updateValues ()
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
    
    func updateValues ()
    {
        print(self.studentPic)
        if self.studentPic != ""
        {
          if let url = NSURL(string: self.studentPic) {
              if let data = NSData(contentsOf: url as URL) {
                  self.studentImage.image = UIImage(data: data as Data)
                  self.studentImage.layer.cornerRadius = self.studentImage.frame.size.height / 2
                  self.studentImage.clipsToBounds = true
              }
          }
        }
        
        if GlobalVariables.aadhaar_card_number != ""
        {
            self.adharNumber.text = GlobalVariables.aadhaar_card_number
        }
            
        if GlobalVariables.sex != ""
        {
            if  GlobalVariables.sex == "Male"
            {
                self.gender.text = "Male"
            }
            else if  GlobalVariables.sex == "Female"
            {
                self.gender.text = "FeMale"
            }
            else
            {
                self.gender.text = "Other"
            }
        }
            
        if GlobalVariables.age !=  ""
        {
            self.age.text = GlobalVariables.age!
        }
            
        if GlobalVariables.blood_group != ""
        {
            self.bloodGroup.text = GlobalVariables.blood_group
            let b_group = GlobalVariables.blood_group
            if b_group == "1"
            {
               self.bloodGroup.text = "A+"
            }
            else if b_group == "2"
            {
              self.bloodGroup.text = "O+"
            }
            else if b_group == "3"
            {
               self.bloodGroup.text = "B+"
            }
            else if b_group == "4"
            {
              self.bloodGroup.text = "AB+"
            }
            else if b_group == "5"
            {
               self.bloodGroup.text = "A-"
            }
            else if b_group == "6"
            {
               self.bloodGroup.text = "O-"
            }
            else if b_group == "7"
            {
              self.bloodGroup.text = "B-"
            }
            else if b_group == "8"
            {
               self.bloodGroup.text = "AB-"
            }
        }
            
                if GlobalVariables.aadhaar_card_number != ""
                {
                    self.adharNumber.text = GlobalVariables.aadhaar_card_number
                }
                    
                if GlobalVariables.sex != ""
                {
                    if  GlobalVariables.sex == "Male"
                    {
                        self.gender.text = "Male"
                    }
                    else if  GlobalVariables.sex == "Female"
                    {
                        self.gender.text = "FeMale"
                    }
                    else
                    {
                        self.gender.text = "Other"
                    }
                }
                    
                if GlobalVariables.age !=  ""
                {
                    self.age.text = GlobalVariables.age!
                }
                    
//                if GlobalVariables.blood_group != ""
//                {
//                    self.bloodGroup.text = GlobalVariables.blood_group
//                }
                    
                if GlobalVariables.city != ""
                {
                    self.city.text = GlobalVariables.city
                }
                if GlobalVariables.community != ""
                {
                    self.caste.text = GlobalVariables.community
                }
                if GlobalVariables.community_class != ""
                {
                    self.casteName.text = GlobalVariables.community_class
                }
                if GlobalVariables.dob != ""
                {
                    self.dob.text = GlobalVariables.dob
                }
                if GlobalVariables.email != ""
                {
                    self.emailId.text = GlobalVariables.email
                }
                if GlobalVariables.father_name != ""
                {
                    self.fatherName.text = GlobalVariables.father_name
                }
                if GlobalVariables.mobile != ""
                {
                    self.mobileNumber.text = GlobalVariables.mobile
                }
                if GlobalVariables.mother_name != ""
                {
                    self.motherName.text = GlobalVariables.mother_name
                }
                if GlobalVariables.mother_tongue != ""
                {
                    self.motherTonque.text = GlobalVariables.mother_tongue
                }
                if GlobalVariables.studentname != ""
                {
                    self.fullName.text = GlobalVariables.studentname
                }
                if GlobalVariables.nationality != ""
                {
                    self.nationality.text = GlobalVariables.nationality
                }
                if GlobalVariables.religion != ""
                {
                    self.religion.text = GlobalVariables.religion
                }
                if GlobalVariables.sec_mobile != ""
                {
                    self.mobilenumberSecondary.text = GlobalVariables.sec_mobile
                }
                if GlobalVariables.state != ""
                {
                    self.state.text = GlobalVariables.state
                }
                if GlobalVariables.address != ""
                {
                    self.addressLine1.text = GlobalVariables.address
                }
                if GlobalVariables.qualified_promotion != ""
                {
                    self.qualifiedPromotion.text = GlobalVariables.qualified_promotion
                }
                if GlobalVariables.last_studied != ""
                {
                   self.lastStudied.text = GlobalVariables.last_studied
                }
                if GlobalVariables.qualification != ""
                {
                   self.graduation.text = GlobalVariables.qualification
                }
                if GlobalVariables.disability == "1"
                {
                    disabilityImageView.image = UIImage(named: "rec1.png")
                    is_disablity = false
                    disablity = "0"
                }
                if GlobalVariables.transfer_certificate == "1"
                {
                    tcImageView.image = UIImage(named: "rec1.png")
                    is_tc = false
                    is_transfercert = "0"
                }
                if GlobalVariables.degree != ""
                {
                    self.degree.text = GlobalVariables.degree
                }
                if GlobalVariables.yearOfEducation != ""
                {
                    self.yearOfEducation.text = GlobalVariables.yearOfEducation
                }
                if GlobalVariables.yearofPassing != ""
                {
                    self.yearOfPassing.text = GlobalVariables.yearofPassing
                }
                if GlobalVariables.identificationMarksOne != ""
                {
                    self.identificationMarksOne.text = GlobalVariables.identificationMarksOne
                }
                if GlobalVariables.identificationMarksTwo != ""
                {
                    self.identificationMarksTwo.text = GlobalVariables.identificationMarksTwo
                }
                if GlobalVariables.headOfFamily != ""
                {
                    self.headOfFamily.text = GlobalVariables.headOfFamily
                }
                if GlobalVariables.highestEducation != ""
                {
                    self.highestEducationQualification.text = GlobalVariables.highestEducation
                }
                if GlobalVariables.fatherMobile != ""
                {
                    self.fatherMobileNumber.text = GlobalVariables.fatherMobile
                }
                if GlobalVariables.motherMobile != ""
                {
                    self.motherMobileNumber.text = GlobalVariables.motherMobile
                }
                if GlobalVariables.yearlyIncome != ""
                {
                    self.yearlyIncome.text = GlobalVariables.yearlyIncome
                }
                if GlobalVariables.languagesKnown != ""
                {
                    self.languageKnown.text = GlobalVariables.languagesKnown
                }
                if GlobalVariables.numberOfMembers != ""
                {
                    self.numberOfMembersInFamily.text = GlobalVariables.numberOfMembers
                }
                if GlobalVariables.jobCard != ""
                {
                    self.jobCard.text = GlobalVariables.jobCard
                }
                
        //        if GlobalVariables.preferred_trade != ""
        //        {
        //            self.department.text = GlobalVariables.preferred_trade
        //        }
                
        //        let indexPostion  = [_id.index(of: GlobalVariables.preferred_trade!)]
                
                for i in 0..<(_id.count)
                {
                    let tradenameObj = _id[i]
                    if tradenameObj == GlobalVariables.preferred_trade!
                    {
                        self.department.text = tradename[i]
                        print(self.department.text!)
                    }
                }
                
                if GlobalVariables.student_pic != ""
                {
                    let imgurlAppend  = Baseurl.baseUrl + Baseurl.imageProfile + GlobalVariables.student_pic!
                    studentImage.sd_setImage(with: URL(string: imgurlAppend), placeholderImage: UIImage(named: "profile photo.png"))
                    let url = URL(string:imgurlAppend)
                    if let data = try? Data(contentsOf: url!)
                    {
                        uploadedImage = UIImage(data: data)!
                    }
                    self.studentImage.layer.cornerRadius = studentImage.bounds.width/2
                    self.studentImage.layer.borderWidth = 1
                    self.studentImage.layer.borderColor = UIColor.lightGray.cgColor
                    self.studentImage.clipsToBounds = true
                }
    }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            if textField == fullName
            {
                gender.becomeFirstResponder()
                self.pickerforGender(self.gender)
            }
            else if textField == age
            {
                //religion.becomeFirstResponder()
            }
            else if textField == religion
            {
                casteName.becomeFirstResponder()
            }
            else if textField == casteName
            {
                fatherName.becomeFirstResponder()
            }
            else if textField == fatherName
            {
                nationality.becomeFirstResponder()
                //self.pickStartDate(self.dob)
            }
            else if textField == nationality
            {
                caste.becomeFirstResponder()
            }
            else if textField == caste
            {
                bloodGroup.becomeFirstResponder()
                self.pickerforGender(self.bloodGroup)
            }
            else if textField == motherName
            {
                mobileNumber.becomeFirstResponder()
            }
            else if textField == mobileNumber
            {
                mobilenumberSecondary.becomeFirstResponder()
            }
            else if textField == mobilenumberSecondary
            {
                emailId.becomeFirstResponder()
            }
            else if textField == emailId
            {
                graduation.becomeFirstResponder()
                self.pickerforGender(self.graduation)
            }
            else if textField == graduation
            {
                degree.becomeFirstResponder()
            }
            else if textField == degree
            {
                qualifiedPromotion.becomeFirstResponder()
            }
            else if textField == qualifiedPromotion
            {
                lastStudied.becomeFirstResponder()
            }
            else if textField == lastStudied
            {
                yearOfEducation.becomeFirstResponder()
                self.pickerforGender(self.yearOfEducation)
            }
            else if textField == yearOfEducation
            {
                self.pickerforGender(self.yearOfEducation)
                yearOfPassing.becomeFirstResponder()
            }
            else if textField == yearOfPassing
            {
                self.pickerforGender(self.yearOfPassing)
                identificationMarksOne.becomeFirstResponder()
            }
            else if textField == identificationMarksOne
            {
                identificationMarksTwo.becomeFirstResponder()
            }
            else if textField == identificationMarksTwo
            {
                headOfFamily.becomeFirstResponder()
            }
            else if textField == headOfFamily
            {
                highestEducationQualification.becomeFirstResponder()
            }
            else if textField == highestEducationQualification
            {
                fatherMobileNumber.becomeFirstResponder()
            }
            else if textField == fatherMobileNumber
            {
                motherMobileNumber.becomeFirstResponder()
            }
            else if textField == motherMobileNumber
            {
                yearlyIncome.becomeFirstResponder()
            }
            else if textField == yearlyIncome
            {
                motherTonque.becomeFirstResponder()
            }
            else if textField == motherTonque
            {
                languageKnown.becomeFirstResponder()
            }
            else if textField == languageKnown
            {
                numberOfMembersInFamily.becomeFirstResponder()
            }
            else if textField == numberOfMembersInFamily
            {
                state.becomeFirstResponder()
            }
            else if textField == state
            {
                city.becomeFirstResponder()
            }
            else if textField == city
            {
                addressLine1.becomeFirstResponder()
            }
            else if textField == addressLine1
            {
                addressLine2.becomeFirstResponder()
            }
            else if textField == addressLine2
            {
                department.becomeFirstResponder()
                self.pickerforGender(self.department)
            }
            else if textField == department
            {
                adharNumber.becomeFirstResponder()
            }
            else if textField == adharNumber
            {
                jobCard.becomeFirstResponder()
                self.pickerforGender(self.jobCard)

            }
            else if textField == jobCard
            {
                jobCard.resignFirstResponder()
                self.view.endEditing(true);
            }
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField)
        {
            if textField == fullName
            {

                self.pickerforGender(self.gender)
            }
            else if textField == gender
            {
                self.pickerforGender(self.gender)
            }
            else if textField == bloodGroup
            {
                self.pickerforGender(self.bloodGroup)
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
            }
            else if textField == age
            {
                //self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
            }
            else if textField == religion
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
            }
            else if textField == casteName
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
            }
            else if textField == fatherName
            {
                self.pickStartDate(self.dob)
            }
            else if textField == dob
            {
                self.pickStartDate(self.dob)
            }
            else if textField == nationality
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
            }
            else if textField == caste
            {
                self.pickerforGender(self.bloodGroup)
            }
            else if textField == motherName
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
            }
            else if textField == mobileNumber
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
            }
            else if textField == mobilenumberSecondary
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
            }
            else if textField == emailId
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
            }
            else if textField == graduation
            {
                self.pickerforGender(self.graduation)
    //          self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
            }
            else if textField == degree
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
            }
            else if textField == qualifiedPromotion
            {
                self.pickerforGender(self.qualifiedPromotion)
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 500), animated: true)
            }
            else if textField == lastStudied
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 500), animated: true)
            }
            else if textField == yearOfEducation
            {
                self.pickerforGender(self.yearOfEducation)
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
            }
            else if textField == yearOfPassing
            {
                self.pickerforGender(self.yearOfPassing)
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 600), animated: true)
            }
            else if textField == identificationMarksOne
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
            }
            else if textField == identificationMarksTwo
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
            }
            else if textField == headOfFamily
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 800), animated: true)
            }
            else if textField == highestEducationQualification
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
            }
            else if textField == fatherMobileNumber
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
            }
            else if textField == motherMobileNumber
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
            }
            else if textField == yearlyIncome
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1000), animated: true)
            }
            else if textField == motherTonque
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1200), animated: true)
            }
            else if textField == languageKnown
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1200), animated: true)
            }
            else if textField == numberOfMembersInFamily
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1200), animated: true)
            }
            else if textField == numberOfMembersInFamily
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
            }
            else if textField == state
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
            }
            else if textField == city
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
            }
            else if textField == addressLine1
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)

            }
            else if textField == addressLine2
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)

            }
    //        else if textField == motherTonque
    //        {
    //            self.pickerforGender(self.department)
    //            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1400), animated: true)
    //
    //        }
            else if textField == department
            {
                self.pickerforGender(self.department)
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1600), animated: true)
            }
            else if textField == adharNumber
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1600), animated: true)
            }
            else if textField == jobCard
            {
                self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 1600), animated: true)
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField)
        {
            if touchesBegan == "0"
            {
                touchesBegan = "0"

                if textField == fullName
                {
                    gender.becomeFirstResponder()
                    self.pickerforGender(self.gender)
                }
                else if textField == gender
                {
                    //age.becomeFirstResponder()
                }
                else if textField == bloodGroup
                {
                    motherName.becomeFirstResponder()
                }
                else if textField == age
                {
                    religion.becomeFirstResponder()
                }
                else if textField == religion
                {
                    casteName.becomeFirstResponder()
                }
                else if textField == casteName
                {
                    fatherName.becomeFirstResponder()
                }
                else if textField == fatherName
                {
                    nationality.becomeFirstResponder()
                    //self.pickStartDate(self.dob)
                }
                else if textField == nationality
                {
                    caste.becomeFirstResponder()
                }
                else if textField == caste
                {
                    bloodGroup.becomeFirstResponder()
                    self.pickerforGender(self.bloodGroup)
                }
                else if textField == motherName
                {
                    mobileNumber.becomeFirstResponder()
                }
                else if textField == mobileNumber
                {
                    mobilenumberSecondary.becomeFirstResponder()
                }
                else if textField == mobilenumberSecondary
                {
                    emailId.becomeFirstResponder()
                }
                else if textField == emailId
                {
                    graduation.becomeFirstResponder()
                    self.pickerforGender(self.graduation)
                }
                else if textField == graduation
                {
                    degree.becomeFirstResponder()
                }
                else if textField == degree
                {
                    qualifiedPromotion.becomeFirstResponder()
                }
                else if textField == qualifiedPromotion
                {
                    lastStudied.becomeFirstResponder()
                }
                else if textField == lastStudied
                {
                    yearOfEducation.becomeFirstResponder()
                }
                else if textField == yearOfEducation
                {
                    yearOfPassing.becomeFirstResponder()
                }
                else if textField == yearOfPassing
                {
                   identificationMarksOne.becomeFirstResponder()
                }
                else if textField == identificationMarksOne
                {
                    identificationMarksTwo.becomeFirstResponder()
                }
                
                else if textField == identificationMarksTwo
                {
                    headOfFamily.becomeFirstResponder()
                }
                else if textField == headOfFamily
                {
                    highestEducationQualification.becomeFirstResponder()
                }
                else if textField == highestEducationQualification
                {
                    fatherMobileNumber.becomeFirstResponder()
                }
                else if textField == fatherMobileNumber
                {
                    motherMobileNumber.becomeFirstResponder()
                }
                else if textField == motherMobileNumber
                {
                    yearlyIncome.becomeFirstResponder()
                }
                else if textField == yearlyIncome
                {
                   motherTonque.becomeFirstResponder()
                }
                else if textField == motherTonque
                {
                    languageKnown.becomeFirstResponder()
                }
                else if textField == languageKnown
                {
                    numberOfMembersInFamily.becomeFirstResponder()
                }
                else if textField == numberOfMembersInFamily
                {
                    state.becomeFirstResponder()
                }
                else if textField == state
                {
                    city.becomeFirstResponder()
                }
                else if textField == city
                {
                    addressLine1.becomeFirstResponder()
                }
                else if textField == addressLine1
                {
                    addressLine2.becomeFirstResponder()
                }
                else if textField == addressLine2
                {
                    department.becomeFirstResponder()
                    self.pickerforGender(self.department)
                }
    //            else if textField == motherTonque
    //            {
    //                department.becomeFirstResponder()
    //                self.pickerforGender(self.department)
    //            }
                else if textField == department
                {
                    adharNumber.becomeFirstResponder()
                }
                else if textField == adharNumber
                {
                    jobCard.becomeFirstResponder()
                    self.pickerforGender(self.jobCard)

                }
                else if textField == jobCard
                {
                    jobCard.resignFirstResponder()
                    self.view.endEditing(true);
                }
            }
            else
            {
                textField.resignFirstResponder()
                
                touchesBegan = "1"
            }
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
      {
       if textField == mobileNumber
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
           {
               return false
           }
           let newLength = currentCharacterCount + string.count - range.length
           return newLength <= 10
       }
       else if textField == mobilenumberSecondary
       {
           let currentCharacterCount = textField.text?.count ?? 0
           if range.length + range.location > currentCharacterCount
           {
              return false
           }
           let newLength = currentCharacterCount + string.count - range.length
           return newLength <= 10
       }
        else if textField == fatherMobileNumber
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
        else if textField == motherMobileNumber
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
       else if textField == adharNumber
       {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 12
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
    
    func getAgeFromDOF(date: String) -> (Int) {

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let dateOfBirth = dateFormater.date(from: date)

        let calender = Calendar.current

        let dateComponent = calender.dateComponents([.year, .month, .day], from:
        dateOfBirth!, to: Date())

        return (dateComponent.year!)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "to_Documentation")
        {
            let vc = segue.destination as! Documentation
            vc.prospect_id = GlobalVariables.studentid!
        }
        else if (segue.identifier == "documentListPage")
        {
            let _ = segue.destination as! ViewDocument
        }
    }
          
}
