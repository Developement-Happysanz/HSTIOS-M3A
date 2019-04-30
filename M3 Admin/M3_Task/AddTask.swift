//
//  AddTask.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 22/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddTask: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {

    var name : NSMutableArray = NSMutableArray()
    
    var user_id : NSMutableArray = NSMutableArray()
    
    var picker = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var tasktitle: UITextField!
    
    @IBOutlet var taskdate: UITextField!
    
    @IBOutlet var taskDetails: UITextView!
    
    @IBOutlet var assignedto: UITextField!
    
    @IBOutlet var saveOutlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        addVaues ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NavigationBarTitleColor.navbar_TitleColor

        self.title = "Add Task"
        
        tasktitle.delegate = self
        
        taskdate.delegate = self

        taskDetails.delegate = self

        assignedto.delegate = self
        
        saveOutlet.layer.cornerRadius = 4
        
        assignedto.layer.cornerRadius = 4
        assignedto.layer.borderWidth = 1.0
        assignedto.layer.borderColor = UIColor.black.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        webRequest ()
        
       let str = UserDefaults.standard.string(forKey: "Task_View")
        
        if str == "fromList"
        {
            ViewDetails ()
        }
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func  webRequest ()
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
                        var userList = JSON?["userList"] as? [Any]
                        for i in 0..<(userList?.count ?? 0)
                        {
                            var dict = userList?[i] as? [AnyHashable : Any]
                            let mob_name = dict?["name"] as? String
                            let userID = dict?["user_id"] as? String
                            
                            self.name.add(mob_name!)
                            self.user_id.add(userID!)
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
    
    func  ViewDetails ()
    {
        let functionName = "apipia/view_task"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["task_id": GlobalVariables.task_id!]
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
                        var taskDetails = JSON?["taskDetails"] as? [Any]
                        for i in 0..<(taskDetails?.count ?? 0)
                        {
                            var dict = taskDetails?[i] as? [AnyHashable : Any]
                            self.taskdate.text = dict?["task_date"] as? String
                            self.taskDetails.text = dict?["task_description"] as? String
                            self.tasktitle.text = dict?["task_title"] as? String
                            self.assignedto.text = GlobalVariables.mobiliser_name
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

    func pickerformobiliser(_ textField : UITextField)
    {
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(mobiliserpickerdoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(mobiliserpickercancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        assignedto.inputView = picker
        assignedto.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return name.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return (name[row] as! String)

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.assignedto.text = (name[row] as! String)
    }
    
    @objc func mobiliserpickerdoneClick ()
    {
        let selectedIndex = picker.selectedRow(inComponent: 0)
        assignedto.text = (name[selectedIndex] as! String)
        assignedto.resignFirstResponder()

    }
    
    @objc func mobiliserpickercancelClick ()
    {
       assignedto.resignFirstResponder()

    }
    
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        taskdate.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        taskdate.inputAccessoryView = toolbar
        // add datepicker to textField
        taskdate.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        taskdate.text = dateFormatter1.string(from: datePicker.date)
        taskdate.resignFirstResponder()
        taskDetails.becomeFirstResponder()
    }
    
    @objc func cancelClick()
    {
        taskdate.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == tasktitle
        {
          taskdate.becomeFirstResponder()
          self.pickStartDate(taskdate)
        }
        else if textField == taskdate
        {
            taskDetails.becomeFirstResponder()
        }
        else if textField == taskDetails
        {
            assignedto.becomeFirstResponder()
            self.pickerformobiliser(assignedto)
        }
        else if textField == assignedto
        {
            assignedto.resignFirstResponder()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == tasktitle
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 50), animated: true)

        }
        else if textField == taskDetails
        {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        }
        else if textField == taskdate
        {
            self.pickStartDate(taskdate)
        }
        else if textField == assignedto
        {
            self.pickerformobiliser(assignedto)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == tasktitle
        {
             self.taskdate.becomeFirstResponder()
        }
        else if textField == taskDetails
        {
            self.assignedto.becomeFirstResponder()
            self.pickerformobiliser(assignedto)
        }
        else if textField == taskdate
        {
            self.taskDetails.becomeFirstResponder()
        }
        else if textField == assignedto
        {
            self.assignedto.resignFirstResponder()
        }
    }
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func addVaues ()
    {
        if self.tasktitle.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskdate.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskDetails.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.assignedto.text == ""
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
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let value = self.assignedto.text;
            let index = name.index(of: value!)
            let mobId = user_id[index]
            let functionName = "apipia/add_task"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "mob_id": mobId, "task_title": self.tasktitle.text as Any, "task_description": self.taskDetails.text as Any, "task_date": self.taskdate.text as Any]
            
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
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                                self.tasktitle.text = ""
                                self.taskdate.text = ""
                                self.taskDetails.text = ""
                                self.assignedto.text = ""
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                            
                            self.performSegue(withIdentifier: "to_Task", sender: self)
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
    
    func updateVaues ()
    {
        if self.tasktitle.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskdate.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.taskDetails.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.assignedto.text == ""
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
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let value = self.assignedto.text;
            let index = name.index(of: value!)
            let mobId = user_id[index]
            let functionName = "apipia/update_task"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "mob_id": mobId, "task_title": self.tasktitle.text as Any, "task_description": self.taskDetails.text as Any, "task_date": self.taskdate.text as Any]
            
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
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                            
                            self.performSegue(withIdentifier: "to_Task", sender: self)

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
