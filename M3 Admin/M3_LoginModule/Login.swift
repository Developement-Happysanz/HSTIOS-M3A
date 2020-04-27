//
//  ViewController.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 18/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//


import UIKit
import Alamofire
import MBProgressHUD

class Login: UIViewController,UITextFieldDelegate
{
    var activeField: UITextField?
    var eyeisClicked = true

    override func viewDidLoad()
    {
        super.viewDidLoad()
        NavigationBarTitleColor.navbar_TitleColor
        userName.delegate = self
        passWord.delegate = self
        LoginOutlet.layer.cornerRadius = 4
        eyeisClicked = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
   {
        if textField == userName
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 13
        }
        else
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount
            {
               return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 20
        }
   }
      
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == userName
        {
            passWord.becomeFirstResponder()
        }
        else
        {
            passWord.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            self.view.endEditing(true);
        }
    }
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var LoginOutlet: UIButton!
    
    @IBAction func passwordEyeButton(_ sender: Any)
    {
        if (eyeisClicked == true)
        {
            let image = UIImage(named: "unhide.png") as UIImage?
            passwordEyeOutlet.setBackgroundImage(image, for: UIControl.State.normal)
            passWord.isSecureTextEntry = false
            eyeisClicked = false
        }
        else
        {
            let image = UIImage(named: "hide.png") as UIImage?
            passwordEyeOutlet.setBackgroundImage(image, for: UIControl.State.normal)
            passWord.isSecureTextEntry = true
            eyeisClicked = true
        }
    }
    
    @IBOutlet weak var passwordEyeOutlet: UIButton!
    @IBAction func loginAction(_ sender: Any)
    {
        let name = userName.text
        let password = passWord.text
               
        if (name!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Username is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(password!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "Password is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (password!.count < 6)
        {
            let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (password!.count >= 12)
        {
                  let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
                  let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                     print("You've pressed default");
                  }
                  alertController.addAction(action1)
                  self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apimain/login/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_name": name!, "password": password!, "mobile_type": "2", "device_id": "23423423423"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
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
                        if (msg == "User loggedIn successfully")
                        {
                            // Mark : Parseing userData
                            let userData = JSON?["userData"] as? NSDictionary
                            let user_id = (userData!["user_id"] as! String)
                            let name = (userData!["name"] as! String)
                            let user_name = (userData!["user_name"] as! String)
                            let user_pic = (userData!["user_pic"] as! String)
                            let user_type = (userData!["user_type"] as! String)
                            let user_type_name = (userData!["user_type_name"] as! String)
                            
                            UserDefaults.standard.set(user_id, forKey: "userIdKey")
                            UserDefaults.standard.set(name, forKey: "nameKey")
                            UserDefaults.standard.set(user_name, forKey: "userNameKey")
                            UserDefaults.standard.set(user_pic, forKey: "userPicKey")
                            UserDefaults.standard.set(user_type, forKey: "userTypeKey")
                            UserDefaults.standard.set(user_type_name, forKey: "userTypeNameKey")
                            
                            GlobalVariables.user_id = (UserDefaults.standard.object(forKey: "userIdKey") as! String)
                            GlobalVariables.name = (UserDefaults.standard.object(forKey: "nameKey") as! String)
                            GlobalVariables.user_name = (UserDefaults.standard.object(forKey: "userNameKey") as! String)
                            GlobalVariables.user_pic = (UserDefaults.standard.object(forKey: "userPicKey") as! String)
                            GlobalVariables.user_type = (UserDefaults.standard.object(forKey: "userTypeKey") as! String)
                            GlobalVariables.user_type_name = (UserDefaults.standard.object(forKey: "userTypeNameKey") as! String)
                            
                            
                            //Mark: navigation to Dashboard
                            if GlobalVariables.user_type_name == "TNSRLM"
                            {
//                              Mark : Parseing dashboardData tnsrlm
                                let dashboardData = JSON?["dashboardData"] as? NSDictionary
                                
                                let centerCount = String(format: "%@",dashboardData!["center_count"] as! CVarArg)
                                let mobilizerCount = String(format: "%@",dashboardData!["mobilizer_count"] as! CVarArg)
                                let studentCount = String(format: "%@",dashboardData!["student_count"] as! CVarArg)
                                let piaCount = String(format: "%@",dashboardData!["pia_count"] as! CVarArg)
                                
                                UserDefaults.standard.set(centerCount, forKey: "centerCountKey")
                                UserDefaults.standard.set(mobilizerCount, forKey: "mobilizerCountKey")
                                UserDefaults.standard.set(studentCount, forKey: "studentCountKey")
                                UserDefaults.standard.set(piaCount, forKey: "piaCountKey")

                                GlobalVariables.center_count =  (UserDefaults.standard.object(forKey: "centerCountKey") as! String)
                                GlobalVariables.mobilizer_count = (UserDefaults.standard.object(forKey: "mobilizerCountKey") as! String)
                                GlobalVariables.student_count = (UserDefaults.standard.object(forKey: "studentCountKey") as! String)
                                GlobalVariables.pia_count = (UserDefaults.standard.object(forKey: "piaCountKey") as! String)
                                
                                self.performSegue(withIdentifier:"M3_TnsrlmDashboard", sender: self)
                            }
                            else
                            {
                                // Mark : Parseing dashboardData
                                let piaProfile = JSON?["piaProfile"] as? NSDictionary
                                let pia_unique_number  =  String(format: "%@",piaProfile!["pia_unique_number"] as! CVarArg)
                                UserDefaults.standard.set(pia_unique_number, forKey: "piaUniqueNumberKey")
                                GlobalVariables.pia_unique_number = (UserDefaults.standard.object(forKey: "piaUniqueNumberKey") as! String)
                                let scheme_id  =  String(format: "%@",piaProfile!["scheme_id"] as! CVarArg)
                                UserDefaults.standard.set(scheme_id, forKey: "scheme_idKey")
                                GlobalVariables.scheme_id = (UserDefaults.standard.object(forKey: "scheme_idKey") as! String)

//                              GlobalVariables.mobilizer_count = String(format: "%@",dashboardData!["mobilizer_count"]  as! CVarArg)
//                              GlobalVariables.student_count = String(format: "%@",dashboardData!["student_count"]  as! CVarArg)
//                              GlobalVariables.task_count = String(format: "%@",dashboardData!["task_count"]  as! CVarArg)
                                
                                //Mark: Project Period
//                              var project_period = dashboardData!["project_period"] as? [AnyHashable : Any]
//                              GlobalVariables.period_from = project_period?["period_from"] as? String
//                              GlobalVariables.period_to = project_period?["period_from"] as? String
                                
                                UserDefaults.standard.set("NO", forKey: "Tnsrlmstaff") //setObject
                                self.performSegue(withIdentifier:"dashboard", sender: self)
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
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
}
