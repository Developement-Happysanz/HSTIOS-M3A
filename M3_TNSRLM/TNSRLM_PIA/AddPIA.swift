//
//  AddPIA.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class AddPIA: UIViewController,UITextFieldDelegate
{

    @IBOutlet var sacrollView: UIScrollView!
    
    @IBOutlet var uniqueID: UITextField!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var address: UITextField!
    
    @IBOutlet var mail: UITextField!
    
    @IBOutlet var phone: UITextField!
    
    @IBOutlet var saveOutlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        let str = UserDefaults.standard.string(forKey: "pia_Creation")
        
        if str == "FromList"
        {
            updateDetails()
        }
        else
        {
            adddetails ()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uniqueID.delegate = self
        
        name.delegate = self

        address.delegate = self

        mail.delegate = self

        phone.delegate = self

        saveOutlet.layer.cornerRadius = 4
        
        let str = UserDefaults.standard.string(forKey: "pia_Creation")
        
        if str == "FromList"
        {
            showDetails ()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == uniqueID
        {
            name.becomeFirstResponder()
        }
        else if textField == name
        {
            address.becomeFirstResponder()

        }
        else if textField == address
        {
            mail.becomeFirstResponder()

        }
        else if textField == mail
        {
            phone.becomeFirstResponder()

        }
        else if textField == phone
        {
            phone.resignFirstResponder()
        }
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == uniqueID
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 50), animated: true)

        }
        else if textField == name
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)

        }
        else if textField == address
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)

        }
        else if textField == mail
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)

        }
        else if textField == phone
        {
            self.sacrollView.setContentOffset(CGPoint.init(x: 0, y: 150), animated: true)

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == uniqueID
        {
            name.becomeFirstResponder()
        }
        else if textField == name
        {
            address.becomeFirstResponder()
            
        }
        else if textField == address
        {
            mail.becomeFirstResponder()
            
        }
        else if textField == mail
        {
            phone.becomeFirstResponder()
            
        }
        else if textField == phone
        {
            phone.resignFirstResponder()
        }
    }
    
    func adddetails ()
    {
        if self.uniqueID.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.name.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.address.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mail.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.phone.text == ""
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
            let functionName = "apimain/create_pia"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "unique_number": self.uniqueID.text as Any, "name": self.name.text as Any, "address": self.address.text as Any, "phone": self.phone.text as Any, "email": self.mail.text as Any]
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
    
    func updateDetails ()
    {
        if self.uniqueID.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.name.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.address.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.mail.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.phone.text == ""
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
            let functionName = "apimain/create_pia"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "unique_number": self.uniqueID.text as Any, "name": self.name.text as Any, "address": self.address.text as Any, "phone": self.phone.text as Any, "email": self.mail.text as Any]
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
    
    func showDetails ()
    {
        let functionName = "apimain/pia_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["pia_id": GlobalVariables.user_master_id!]
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
                            self.address.text = (dict!["pia_address"] as! String)
                            self.mail.text = (dict!["pia_email"] as! String)
                            self.name.text = (dict!["pia_name"] as! String)
                            self.phone.text = (dict!["pia_phone"] as! String)
                            self.uniqueID.text = (dict!["pia_unique_number"] as! String)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
