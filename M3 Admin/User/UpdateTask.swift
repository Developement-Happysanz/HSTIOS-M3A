//
//  UpdateTask.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 24/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class UpdateTask: UIViewController,UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descripitionText: UITextView!
    @IBOutlet weak var taskDate: UITextField!
    @IBOutlet weak var uploadPhotoOutlet: UIButton!
    @IBOutlet weak var viewPhotoOutlet: UIButton!
    @IBOutlet weak var updateOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var taskType: UITextField!
    @IBOutlet weak var taskStatus: UITextField!
    
    var titleText = String()
    var descripition = String()
    var date = String()
    var _taskType = String()
    var status = String()
    var taskID = String()
    var attandenceID = String()
    
    var taskTypeArr = [String]()
    var taskTypeId = [String]()
    var taskStatusArr = [String]()
    
    var picker = UIPickerView()
    var datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Update Task"
        self.titleLabel.delegate = self
        self.descripitionText.delegate = self
        self.taskDate.delegate = self
        self.taskType.delegate = self
        self.taskStatus.delegate = self

        self.titleLabel.text = titleText
        self.descripitionText.text = descripition
        self.taskDate.text = date
        self.taskType.text = _taskType
        self.taskStatus.text = status
                
        self.workTypeMaster ()


    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if taskDate.isFirstResponder
        {
            self.pickStartDate(taskDate)
        }
        else if taskType.isFirstResponder
        {
            self.pickerforWork(taskType)
        }
        else if taskStatus.isFirstResponder
        {
            self.pickerforWork(taskStatus)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.titleLabel.isFirstResponder
        {
            self.taskDate.becomeFirstResponder()
        }
        else if self.taskDate.isFirstResponder
        {
            self.descripitionText.becomeFirstResponder()
        }
        else if self.descripitionText.isFirstResponder
        {
            self.taskType.becomeFirstResponder()
        }
        else if self.taskType.isFirstResponder
        {
            self.taskStatus.becomeFirstResponder()
        }
        else if self.taskStatus.isFirstResponder
        {
            self.taskStatus.resignFirstResponder()
        }
        return true
    }
    
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        taskDate.inputView = self.datePicker
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
        taskDate.inputAccessoryView = toolbar
        // Add datepicker to textField
        taskDate.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        taskDate.text = dateFormatter1.string(from: datePicker.date)
        taskDate.resignFirstResponder()
        taskType.becomeFirstResponder()
    }
    
    @objc func cancelClick()
    {
        taskDate.resignFirstResponder()
        taskType.becomeFirstResponder()
    }
    
    func pickerforWork(_ textField : UITextField)
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
        
        taskType.inputView = picker
        taskType.inputAccessoryView = toolBar
        
        taskStatus.inputView = picker
        taskStatus.inputAccessoryView = toolBar

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if taskType.isFirstResponder
        {
            return taskTypeArr.count
        }
        else
        {
            return taskStatusArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if taskType.isFirstResponder
        {
             return taskTypeArr[row]
        }
        else
        {
            return taskStatusArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if taskType.isFirstResponder
        {
            self.taskType.text = taskTypeArr[row]
        }
        else if taskStatus.isFirstResponder
        {
            self.taskStatus.text = taskStatusArr[row]
        }
    }
    
    @objc func genderpickerdoneClick ()
    {
        if taskType.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            taskType.text = taskTypeArr[selectedIndex]
            self.taskID = taskTypeId[selectedIndex]
            taskType.resignFirstResponder()
            descripitionText.becomeFirstResponder()
        }
        else if taskStatus.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            taskStatus.text = taskStatusArr[selectedIndex]
            taskStatus.resignFirstResponder()
        }

    }
    
    @objc func genderpickercancelClick ()
    {
        if taskType.isFirstResponder
        {
            taskType.resignFirstResponder()
            descripitionText.becomeFirstResponder()
        }
        else if taskStatus.isFirstResponder
        {
            taskStatus.resignFirstResponder()
        }
    }
    
    
    @IBAction func updateButton(_ sender: Any)
    {
        if self.titleLabel.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "title cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        if self.taskDate.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "title cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        if self.taskType.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "title cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.descripitionText.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "descripition cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskStatus.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "date cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               // print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.updateButtonIsClicked(title: self.titleLabel.text!, descripition: self.descripitionText.text!, taskDate: self.taskDate.text!, task_id: self.taskID, status: self.status, taskType: self.taskType.text!)
        }
    }
    
    func updateButtonIsClicked (title:String, descripition:String, taskDate:String, task_id:String, status:String, taskType:String)
    {
        let dateformatter4 = DateFormatter()
        dateformatter4.dateFormat = "yyyy-MM-dd hh:mm"
        let now = Date()
        let updated_at = dateformatter4.string(from: now)
        
        let functionName = "apipia/update_attendance_task/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.mobilizer_id!, "work_type":self.taskID, "attendance_date":taskDate, "title":title, "comments":descripition, "status":status, "work_type_id":"", "user_id":GlobalVariables.user_id!, "updated_at":updated_at, "attendance_id":self.attandenceID]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        //let taskDetails = JSON?["taskDetails"] as? [Any]
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
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
    
    func workTypeMaster ()
    {
        let functionName = "apipia/work_type_master/"
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
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        
                        self.taskTypeArr.removeAll()
                        self.taskTypeId.removeAll()
                        self.taskStatusArr.removeAll()
                        
                        let result = JSON?["result"] as? [Any]
                        
                        for i in 0..<(result?.count ?? 0)
                        {
                            let dict = result?[i] as? [AnyHashable : Any]
                            let id = dict?["id"] as? String
                            let status = dict?["status"] as? String
                            let work_type = dict?["work_type"] as? String

                            self.taskTypeArr.append(work_type!)
                            self.taskTypeId.append(id!)
                            self.taskStatusArr.append(status!)

                        }
                        
                        self.picker.reloadAllComponents()
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
