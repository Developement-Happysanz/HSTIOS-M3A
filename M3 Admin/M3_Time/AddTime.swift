//
//  AddTime.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 11/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class AddTime: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    var timePicker = UIDatePicker()
    
    var statusPicker = [String]()

    @IBOutlet weak var sessionName: UITextField!
    
    @IBOutlet weak var startTimeView: UIView!
    
    @IBOutlet weak var toTimeview: UIView!
    
    @IBOutlet weak var statusTxtField: UITextField!
    
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBAction func okButton(_ sender: Any)
    {
        let fromTime = fromTimeLabel.text
        let toTime = toTimeLabel.text
        let session_name = sessionName.text
        let status = statusLabel.text

        if (fromTime == "From Time")
        {
            let alertController = UIAlertController(title: "M3", message: "fromTime is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if(fromTime == "To Time")
        {
            let alertController = UIAlertController(title: "M3", message: "toTime is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(status == "Status")
        {
            let alertController = UIAlertController(title: "M3", message: "Status is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apimain/create_session/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "session_name": session_name!, "from_time": fromTime!, "to_time": toTime!]
            Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print(response)
                        let JSON = response.result.value as? [String: Any]
                        let msg = JSON?["msg"] as? String
                        if (msg == "User loggedIn successfully")
                        {
                          
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
    
    @IBOutlet weak var fromTime: UITextField!
    
    @IBOutlet weak var toTime: UITextField!
    
    @IBOutlet weak var fromTimeLabel: UILabel!
    
    @IBOutlet weak var toTimeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Add Session Timeing"
        
        sessionName.delegate = self

        fromTime.delegate = self
        
        toTime.delegate = self
        
        statusTxtField.delegate = self
        
        startTimeView.layer.borderWidth = 1
        startTimeView.layer.cornerRadius = 3
        startTimeView.clipsToBounds = true
        
        toTimeview.layer.borderWidth = 1
        toTimeview.layer.cornerRadius = 3
        toTimeview.clipsToBounds = true
        
        statusTxtField.layer.borderWidth = 1
        statusTxtField.layer.cornerRadius = 3
        statusTxtField.clipsToBounds = true
        
        
        okOutlet.layer.cornerRadius = 4
        okOutlet.clipsToBounds = true
        
        statusPicker = ["Active","DeActive"]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)

    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.fromTime
        {
            self.pickerfromTime(self.fromTime)
        }
        else if textField == self.toTime
        {
            self.pickertoTime(self.toTime)
        }
        else
        {
            self.pickUp(statusTxtField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        sessionName.resignFirstResponder()
        
        return true
    }
    

    func pickerfromTime(_ textField : UITextField)
    {
        //Formate Date
        self.timePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.timePicker.backgroundColor = UIColor.white
        self.timePicker.datePickerMode = .time
        let now = Date();
        timePicker.minimumDate = now
        fromTime.inputView = self.timePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startTimeDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        fromTime.inputAccessoryView = toolbar
        // add datepicker to textField
        fromTime.inputView = timePicker
        
    }
    
    func pickertoTime(_ textField : UITextField)
    {
        //Formate Date
        self.timePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.timePicker.backgroundColor = UIColor.white
        self.timePicker.datePickerMode = .time
        let now = Date();
        timePicker.minimumDate = now
        toTime.inputView = self.timePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endtimeClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(endtimeCancelClick))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        toTime.inputAccessoryView = toolbar
        // add datepicker to textField
        toTime.inputView = timePicker
    }
    
    @objc func startTimeDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.setLocalizedDateFormatFromTemplate("hh:mm")
        fromTimeLabel.text = dateFormatter1.string(from: timePicker.date)
        fromTime.resignFirstResponder()
    }
    
    @objc func cancelClick()
    {
        fromTime.resignFirstResponder()
    }
    
    @objc func endtimeClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.setLocalizedDateFormatFromTemplate("hh:mm")
        toTimeLabel.text = dateFormatter1.string(from: timePicker.date)
        toTime.resignFirstResponder()
    }
    
    @objc func endtimeCancelClick()
    {
        toTime.resignFirstResponder()
    }
    
    func pickUp(_ textField : UITextField)
    {
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(statuscancelClick))
        
        toolBar.setItems([cancelButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        statusTxtField.inputView = picker
        statusTxtField.inputAccessoryView = toolBar
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return statusPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return statusPicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.statusLabel.text = statusPicker[row]
    }
    
    @objc func statuscancelClick()
    {
        statusTxtField.resignFirstResponder()
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
