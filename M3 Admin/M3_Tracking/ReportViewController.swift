//
//  ReportViewController.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 19/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ReportViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var userTextfield: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextFiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var datePicker = UIDatePicker()
    var picker = UIPickerView()
    var user = [String]()
    var userid = [String]()
    
    var created_at = [String]()
    var km = [String]()
    
    var user_master_id = [String]()
    var mobilizerId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Report"
        NavigationBarTitleColor.navbar_TitleColor
        self.userTextfield.delegate = self
        self.startDateTextField.delegate = self
        self.endDateTextFiled.delegate = self
        self.tableView.isHidden = true
        self.webRequest()
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.backgroundColor = UIColor.clear

    }
    
    func webRequest ()
    {
        let functionName = "apimain/pia_mob_list"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["pia_id": GlobalVariables.user_id!]
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
                        let userList = JSON?["userList"] as? [Any]
                        for i in 0..<(userList?.count ?? 0)
                        {
                            let dict = userList?[i] as? [AnyHashable : Any]
                            let user = dict?["name"] as? String
                            let user_id = dict?["user_id"] as? String
                            let usermasterid = dict?["user_master_id"] as? String

                            self.user.append(user ?? "")
                            self.userid.append(user_id ?? "")
                            self.user_master_id.append(usermasterid ?? "")

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
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == userTextfield
        {
            self.pickerforUser(userTextfield)
        }
        else if textField == startDateTextField
        {
            self.pickerDate(startDateTextField)
        }
        else
        {
            self.pickerDate(startDateTextField)
        }
    }
    
    func pickerDate(_ textField : UITextField)
     {
         self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
         self.datePicker.backgroundColor = UIColor.white
         self.datePicker.datePickerMode = .date
         self.datePicker.setValue(UIColor.black, forKey: "textColor")
         startDateTextField.inputView = self.datePicker
         endDateTextFiled.inputView = self.datePicker

         //ToolBar
         let toolbar = UIToolbar();
         toolbar.sizeToFit()
         
         //done button & cancel button
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
         let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(startDatecancel))
         toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
         
         // add toolbar to textField
         startDateTextField.inputAccessoryView = toolbar
         endDateTextFiled.inputAccessoryView = toolbar
         // add datepicker to textField
         startDateTextField.inputView = datePicker
         endDateTextFiled.inputView = datePicker

     }
     
     @objc func startDateDoneClick()
     {
        if startDateTextField.isFirstResponder
        {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            dateFormatter1.timeStyle = .none
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            startDateTextField.text = dateFormatter1.string(from: datePicker.date)
            startDateTextField.resignFirstResponder()
        }
        else
        {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            dateFormatter1.timeStyle = .none
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            endDateTextFiled.text = dateFormatter1.string(from: datePicker.date)
            endDateTextFiled.resignFirstResponder()
        }

     }
     
     @objc func startDatecancel()
     {
        if startDateTextField.isFirstResponder
        {
            startDateTextField.resignFirstResponder()
        }
        else
        {
            endDateTextFiled.resignFirstResponder()
        }
     }
    
    func pickerforUser(_ textField : UITextField)
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        self.picker.setValue(UIColor.black, forKey: "textColor")

        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(userDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(userCancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        userTextfield.inputView = picker
        userTextfield.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return user.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return user[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.userTextfield.text = user[row]
    }
    
    @objc func userDoneClick ()
    {
        let selectedIndex = picker.selectedRow(inComponent: 0)
        userTextfield.text = user[selectedIndex]
        self.mobilizerId = userid[selectedIndex]
        userTextfield.resignFirstResponder()
    }
    
    @objc func userCancelClick ()
    {
        userTextfield.resignFirstResponder()
    }
     
    
    @IBAction func genrateAction(_ sender: Any)
    {
        if self.userTextfield.text?.isEmpty == true
        {
            
        }
        else if self.startDateTextField?.text?.isEmpty == true
        {
            
        }
        else if self.endDateTextFiled?.text?.isEmpty == true
        {
            
        }
        else
        {
            self.generateReport(mobilizerID: self.mobilizerId, fromDate: self.startDateTextField.text!, toDate: self.endDateTextFiled.text!)
        }
    }
    
    func generateReport (mobilizerID:String, fromDate:String, toDate:String)
    {
        let functionName = "apipia/mobilizier_tracking_report"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": mobilizerID,"from_date": fromDate,"to_date": toDate]
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
                        let trackingReport = JSON?["tracking_report"] as? [Any]
                        for i in 0..<(trackingReport?.count ?? 0)
                        {
                            let dict = trackingReport?[i] as? [AnyHashable : Any]
                            let createdAt = dict?["created_at"] as? String
                            let _km = dict?["km"] as? String

                            self.created_at.append(createdAt ?? "")
                            self.km.append(_km ?? "")
                        }
                        
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return created_at.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ReportTableViewCell
        cell.date.text = created_at[indexPath.row]
        cell.kmLabel.text = km[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
