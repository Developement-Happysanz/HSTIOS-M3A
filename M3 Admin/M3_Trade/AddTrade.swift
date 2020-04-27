//
//  AddTrade.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 11/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class AddTrade: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    var statusArr = [String]()
    var picker = UIPickerView()
    var _title = String()
    var _status = String()
    var pageFrom = String()
    var trade_ID = String()
    
    override func viewDidLoad()
    {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
       self.title = "Add Title"
       titleText.delegate = self
       statusTxtfiled.delegate = self
       okOutlet.layer.cornerRadius = 4
       statusArr = ["Active","Inactive"]
        
        if pageFrom == "list"
        {
            self.titleText.text = _title
            self.statusTxtfiled.text = _status
        }
        else
        {
            self.titleText.text = ""
            self.statusTxtfiled.text = ""
        }
       
    }

    @IBOutlet var titleText: UITextField!
    @IBOutlet var okOutlet: UIButton!
    @IBOutlet weak var statusTxtfiled: UITextField!
    @IBAction func okButton(_ sender: Any)
    {
        if pageFrom == "list"
        {
            self.webRequestForUpdate (trade_id:trade_ID)
        }
        else
        {
            self.webRequestForCreate ()
        }
    }
    
    func webRequestForCreate ()
    {
       let title = self.titleText.text
       let status_text = self.statusTxtfiled.text
       
       if (title!.isEmpty)
       {
           let alertController = UIAlertController(title: "M3", message: "Title cannot be empty", preferredStyle: .alert)
           let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
           }
           alertController.addAction(action1)
           self.present(alertController, animated: true, completion: nil)
       }
       else if (status_text!.isEmpty)
       {
          let alertController = UIAlertController(title: "M3", message: "Status Cannot be empty", preferredStyle: .alert)
          let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
              print("You've pressed default");
          }
          alertController.addAction(action1)
          self.present(alertController, animated: true, completion: nil)
       }
       else
       {
           let functionName = "apipia/create_trade"
           let baseUrl = Baseurl.baseUrl + functionName
           let url = URL(string: baseUrl)!
           let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"trade_name": title!,"status":status_text!]
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
                       break
                   case .failure(let error):
                       print(error)
                   }
           }
       }
    }
    
    func webRequestForUpdate (trade_id : String)
    {
        let title = self.titleText.text
        let status_text = self.statusTxtfiled.text
        
        if (title!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Title cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (status_text!.isEmpty)
        {
           let alertController = UIAlertController(title: "M3", message: "Status Cannot be empty", preferredStyle: .alert)
           let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
           }
           alertController.addAction(action1)
           self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apipia/update_trade"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"trade_id":trade_id,"trade_name": title!,"status":status_text!]
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
                        break
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == titleText
        {
            statusTxtfiled.becomeFirstResponder()
        }
        else
        {
            statusTxtfiled.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == statusTxtfiled
        {
            self.pickerforStatus(self.statusTxtfiled)
        }
    }
    
    func pickerforStatus(_ textField : UITextField)
    {
           picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
           picker.setValue(UIColor.black, forKey: "textColor")
           picker.backgroundColor = .white
           
           //picker.showsSelectionIndicator = true
           picker.delegate = self
           picker.dataSource = self
           
           let toolBar = UIToolbar()
           toolBar.sizeToFit()
           
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(statuspickerdoneClick))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(statuspickercancelClick))
           
           toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
           toolBar.isUserInteractionEnabled = true
           
           statusTxtfiled.inputView = picker
           statusTxtfiled.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return statusArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return statusArr[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {
            
            if statusTxtfiled.isFirstResponder
            {
              self.statusTxtfiled.text = statusArr[row]
            }
        }
        
        @objc func statuspickerdoneClick ()
        {
            
            if statusTxtfiled.isFirstResponder
            {
                let selectedIndex = picker.selectedRow(inComponent: 0)
                statusTxtfiled.text = statusArr[selectedIndex]
                statusTxtfiled.resignFirstResponder()
            }

        }
        
        @objc func statuspickercancelClick ()
        {
            if statusTxtfiled.isFirstResponder
            {
                statusTxtfiled.resignFirstResponder()
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
