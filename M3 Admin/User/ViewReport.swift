//
//  ViewReport.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 25/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ViewReport: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!

    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    
    @IBOutlet weak var fieldworkLabe: UILabel!
    @IBOutlet weak var officeWorkLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var leavesLabel: UILabel!
    @IBOutlet weak var holidaysLabel: UILabel!
    
    var year_id = [String]()
    var month_id = [String]()
    var month_name = [String]()
    var monthID = String()
    var picker = UIPickerView()
    
    var count = [String]()
    var work_type = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.yearTextField.delegate = self
        self.monthTextField.delegate = self
        
        let myColor = UIColor.black
        yearTextField.layer.cornerRadius = 5.0
        yearTextField.layer.borderColor = myColor.cgColor
        yearTextField.layer.borderWidth = 2.0
        yearTextField.clipsToBounds = true
        
        monthTextField.layer.cornerRadius = 5.0
        monthTextField.layer.borderColor = myColor.cgColor
        monthTextField.layer.borderWidth = 2.0
        monthTextField.clipsToBounds = true
        
        let myCok = UIColor.gray

        viewOne.layer.cornerRadius = 5.0
        viewOne.layer.borderColor = myCok.cgColor
        viewOne.layer.borderWidth = 1.0
        viewOne.clipsToBounds = true
        
        viewTwo.layer.cornerRadius = 5.0
        viewTwo.layer.borderColor = myCok.cgColor
        viewTwo.layer.borderWidth = 1.0
        viewTwo.clipsToBounds = true
        
        viewThree.layer.cornerRadius = 5.0
        viewThree.layer.borderColor = myCok.cgColor
        viewThree.layer.borderWidth = 1.0
        viewThree.clipsToBounds = true
        
        viewFour.layer.cornerRadius = 5.0
        viewFour.layer.borderColor = myCok.cgColor
        viewFour.layer.borderWidth = 1.0
        viewFour.clipsToBounds = true
        
        viewFive.layer.cornerRadius = 5.0
        viewFive.layer.borderColor = myCok.cgColor
        viewFive.layer.borderWidth = 1.0
        viewFive.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        webRequestForYears ()
    }
    
    func webRequestForYears ()
    {
        let functionName = "apipia/get_year_list_attendance/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.mobilizer_id!,"user_id": GlobalVariables.user_id!]
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
                        let year_id = JSON?["result"] as? [Any]
                        self.year_id.removeAll()
                        for i in 0..<(year_id?.count ?? 0)
                        {
                            let dict = year_id?[i] as? [AnyHashable : Any]
                            let _year_id = dict?["year_id"] as? String
                            
                            self.year_id.append(_year_id!)
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
    
    func webRequestForMonths (yearId:String)
    {
        let functionName = "apipia/get_month_list_attendance/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.mobilizer_id!,"user_id": GlobalVariables.user_id!,"year_id": yearId]
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
                        let result = JSON?["result"] as? [Any]
                        
                        self.month_id.removeAll()
                        self.month_name.removeAll()
                        
                        for i in 0..<(result?.count ?? 0)
                        {
                            let dict = result?[i] as? [AnyHashable : Any]
                            let monthId = dict?["month_id"] as? String
                            let monthName = dict?["month_name"] as? String

                            self.month_id.append(monthId!)
                            self.month_name.append(monthName!)
                        }
                        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if yearTextField.isFirstResponder
        {
            self.pickerforYears(yearTextField)
        }
        else if monthTextField.isFirstResponder
        {
            if yearTextField.text == "Select Year"
            {
                let alertController = UIAlertController(title: "M3", message: "Select Year", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                   // print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                self.pickerforYears(monthTextField)
            }
        }
        
    }
    
    func pickerforYears(_ textField : UITextField)
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(yearpickerdoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(yearpickercancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        yearTextField.inputView = picker
        yearTextField.inputAccessoryView = toolBar
        
        monthTextField.inputView = picker
        monthTextField.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if yearTextField.isFirstResponder
        {
            return year_id.count
        }
        else
        {
            return month_name.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if yearTextField.isFirstResponder
        {
            return year_id[row]
        }
        else
        {
            return month_name[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if yearTextField.isFirstResponder
        {
            self.yearTextField.text = year_id[row]
        }
        else
        {
            self.monthTextField.text = month_name[row]
        }
    }
    
    @objc func yearpickerdoneClick ()
    {
        if yearTextField.isFirstResponder
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            yearTextField.text = year_id[selectedIndex]
            yearTextField.resignFirstResponder()
            if yearTextField.text != "Select Year"
            {
                webRequestForMonths (yearId:yearTextField.text!)
            }
        }
        else
        {
            let selectedIndex = picker.selectedRow(inComponent: 0)
            monthTextField.text = month_name[selectedIndex]
            self.monthID = month_id[selectedIndex]
            self.getDetailedReport(month_id: self.monthID, year_id: yearTextField.text!)
            monthTextField.resignFirstResponder()
        }
    }
    
    @objc func yearpickercancelClick ()
    {
        if yearTextField.isFirstResponder
        {
            yearTextField.resignFirstResponder()
        }
        else
        {
            monthTextField.resignFirstResponder()
        }
    }
    
    func getDetailedReport (month_id:String,year_id:String)
    {
        let functionName = "apipia/get_month_attendance_report/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.mobilizer_id!,"user_id": GlobalVariables.user_id!,"month_id": month_id,"year_id": year_id]
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
                        let result = JSON?["result"] as? [Any]
                        let km_result = JSON?["km_result"] as? String
                        self.distanceLabel.text = km_result! + "Days"
                        self.count.removeAll()
                        self.work_type.removeAll()

                        for i in 0..<(result?.count ?? 0)
                        {
                            let dict = result?[i] as? [AnyHashable : Any]
                            let work_type = dict?["work_type"] as? String
                            let count = dict?["count"] as? String
                            
                            if work_type == "Office Work"
                            {
                                self.officeWorkLabel.text = count! + "Days"
                            }
                            else if work_type == "Fieldwork"
                            {
                                self.fieldworkLabe.text = count! + "Days"
                            }
                            else if work_type == "Hoilday"
                            {
                                self.holidaysLabel.text = count! + "Days"
                            }
                            else if work_type == "Leave"
                            {
                                self.leavesLabel.text = count! + "Days"
                            }

                        }
                    
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
    
    @IBAction func detailedButton(_ sender: Any)
    {
        if yearTextField.text != "Select Year" && monthTextField.text != "Select Month"
        {
            self.performSegue(withIdentifier: "detailedReport", sender: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailedReport")
        {
           let vc = segue.destination as! DetailReport
           vc.monthId = self.monthID
           vc.year_id = self.yearTextField.text!
        }
    }
    

}
