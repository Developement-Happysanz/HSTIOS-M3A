//
//  ProjectPeriod.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 11/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class ProjectPeriod: UIViewController,UITextFieldDelegate
{

    var datePicker = UIDatePicker()
    
    var start_Date = ""
    var end_Date = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Project Duration"
        startDateTextfield.delegate = self
        endDateTextfeild.delegate = self
        startdateView.layer.borderWidth = 1
        startdateView.layer.cornerRadius = 3
        startdateView.clipsToBounds = true
        enddateView.layer.borderWidth = 1
        enddateView.layer.cornerRadius = 3
        enddateView.clipsToBounds = true
        updateOutlet.layer.cornerRadius = 4
        updateOutlet.clipsToBounds = true
        navigationLeftButton ()
        
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
        self.performSegue(withIdentifier: "projectDurationList", sender: self)
    }
    
    @IBOutlet weak var updateOutlet: UIButton!
    
    @IBAction func updateButton(_ sender: Any)
    {
        let starDate = startDate.text
        let endngDate = endDate.text
        
        if starDate == "Select your Date" || endngDate == "Select Your Date"
        {
            let alertController = UIAlertController(title: "M3", message: "Please select your EndDate", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (starDate == endngDate)
        {
            let alertController = UIAlertController(title: "M3", message: "StartDate and EndDate cannot be the same date", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (starDate == "Select Your Date")
        {
            let alertController = UIAlertController(title: "M3", message: "Please select your StartDate", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)

        }
        else if(endngDate == "Select Your Date")
        {
            let alertController = UIAlertController(title: "M3", message: "Please select your EndDate", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            
            let dateString = starDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let sd = dateFormatter.date(from: dateString!)
            print(sd as Any)
            
            let dateString2 = endngDate
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            let ed = dateFormatter2.date(from: dateString2!)
            print(ed as Any)
            
            let order = Calendar.current.compare(sd!, to: ed!, toGranularity: .day)
            
            switch order {
            case .orderedAscending:
                print("greater")
                let s_date = sd
                let s_formatter = DateFormatter()
                s_formatter.dateFormat = "yyyy-MM-dd"
                start_Date = s_formatter.string(from: s_date!)
                
                let e_date = ed
                let e_formatter = DateFormatter()
                e_formatter.dateFormat = "yyyy-MM-dd"
                end_Date = e_formatter.string(from: e_date!)
                
                callWebserivce ()
            case .orderedDescending:
                
                let alertController = UIAlertController(title: "M3", message: "StartDate and EndDate is not correct", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                
            default: break
                
            }
            
            
        }
    }
    
    func callWebserivce ()
    {
        let functionName = "apipia/project_period"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "start_date": start_Date, "end_date": end_Date]
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
                        // Mark : Parseing userData
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           
                            self.startDate.text = "Select Your Date"
                            self.endDate.text =  "Select Your Date"
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
    
    @IBOutlet weak var enddateView: UIView!
    
    @IBOutlet weak var startdateView: UIView!
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var startDateTextfield: UITextField!
    
    @IBOutlet weak var endDateTextfeild: UITextField!
    

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.startDateTextfield
        {
            self.pickStartDate(self.startDateTextfield)
        }
        else if textField == self.endDateTextfeild
        {
            self.pickEndDate(self.endDateTextfeild)

        }
    }

    func pickStartDate(_ textField : UITextField)
    {
        //Formate Date
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        let now = Date();
        datePicker.minimumDate = now
        startDateTextfield.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        startDateTextfield.inputAccessoryView = toolbar
        // add datepicker to textField
        startDateTextfield.inputView = datePicker
    
    }
    
    func pickEndDate(_ textField : UITextField)
    {
        //Formate Date
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        let now = Date();
        datePicker.minimumDate = now
        endDateTextfeild.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDateClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(endDateCancelClick))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        endDateTextfeild.inputAccessoryView = toolbar
        // add datepicker to textField
        endDateTextfeild.inputView = datePicker
    }

    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        startDate.text = dateFormatter1.string(from: datePicker.date)
        print(startDate.text as Any)
        startDateTextfield.resignFirstResponder()
    }
    
    @objc func cancelClick()
    {
        startDateTextfield.resignFirstResponder()
    }
    
    @objc func endDateClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let enddate = dateFormatter1.string(from: datePicker.date)
        endDate.text = enddate
        print(endDate.text as Any)
        
        endDateTextfeild.resignFirstResponder()
    }
    
    @objc func endDateCancelClick()
    {
        endDateTextfeild.resignFirstResponder()
    }
}
