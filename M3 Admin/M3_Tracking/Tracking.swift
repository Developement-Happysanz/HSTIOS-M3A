//
//  Tracking.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 27/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import MapKit
import CoreLocation

class Tracking: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    
    var datePicker = UIDatePicker()

    var picker = UIPickerView()

    var name = [String]()
    
    var userid = [String]()
    
    var user_master_id = [String]()
    
    @IBOutlet var datetext: UITextField!
    
    @IBOutlet var mobiliserText: UITextField!
    
    @IBOutlet var trackOutlet: UIButton!
    
    @IBOutlet var dateImg: UIImageView!
    
    @IBOutlet var dateTitle: UILabel!
    
    @IBAction func trackButton(_ sender: Any)
    {
        if self.datetext.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mobiliserText.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            GlobalVariables.track_date = datetext.text!
            
            self.performSegue(withIdentifier: "to_Tracking", sender: self)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         self.title = "Track Mobiliser"
        
         NavigationBarTitleColor.navbar_TitleColor

         datetext.layer.borderWidth = 1.0
         datetext.layer.cornerRadius = 4
        
         mobiliserText.layer.borderWidth = 1.0
         mobiliserText.layer.cornerRadius = 4
        
         trackOutlet.layer.cornerRadius = 4
        
         webRequest ()
        
         datetext.delegate = self
        
         mobiliserText.delegate = self
        
        let str = UserDefaults.standard.string(forKey: "tracking_View")
        
        if str == "live"
        {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.datetext.text = formatter.string(from: date)
            self.datetext.isEnabled = false
            self.dateImg.isHidden = true
            self.dateTitle.text = "Date"
        }
        else
        {
            self.datetext.text = ""
            self.datetext.isEnabled = true
            self.dateImg.isHidden = false
            self.dateTitle.text = "Pick Up The Date"
        }
        
        navigationLeftButton ()

    }
    func navigationLeftButton ()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str == "YES"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
    }
    
    @objc func menuButtonclick()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str == "YES"
        {
            self.performSegue(withIdentifier: "track_MainPage", sender: self)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == datetext
        {
            self.pickStartDate(datetext)
        }
        else if textField == mobiliserText
        {
            self.pickerformobiliser(mobiliserText)
        }
    }
    
    
    func pickStartDate(_ textField : UITextField)
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        datetext.inputView = self.datePicker
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDateDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        datetext.inputAccessoryView = toolbar
        // add datepicker to textField
        datetext.inputView = datePicker
    }
    
    @objc func startDateDoneClick()
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        datetext.text = dateFormatter1.string(from: datePicker.date)
        datetext.resignFirstResponder()
    }
    
    @objc func cancelClick()
    {
        datetext.resignFirstResponder()
    }
    
    func webRequest ()
    {
        let functionName = "apimain/pia_mob_list"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["pia_id": GlobalVariables.user_id!   ]
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
                            let _name = dict?["name"] as? String
                            let user_id = dict?["user_id"] as? String
                            let usermasterid = dict?["user_master_id"] as? String

                            self.name.append(_name ?? "")
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
    
    func pickerformobiliser(_ textField : UITextField)
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
        
        mobiliserText.inputView = picker
        mobiliserText.inputAccessoryView = toolBar
        
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
        return name[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.mobiliserText.text = name[row]
    }
    
    @objc func genderpickerdoneClick ()
    {
        let selectedIndex = picker.selectedRow(inComponent: 0)
        mobiliserText.text = name[selectedIndex]
        GlobalVariables.track_name = mobiliserText.text
        GlobalVariables.track_mob_id = userid[selectedIndex]
        print(GlobalVariables.track_mob_id! as Any)
        mobiliserText.resignFirstResponder()
    }
    
    @objc func genderpickercancelClick ()
    {
        mobiliserText.resignFirstResponder()
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
