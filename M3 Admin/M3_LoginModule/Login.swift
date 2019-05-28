//
//  ViewController.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 18/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//


import UIKit
import Alamofire

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
        else
        {
            let functionName = "apimain/login/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_name": name!, "password": password!, "mobile_type": "2", "device_id": "23423423423"]
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
                            
                            // Mark : Parseing userData
                            let userData = JSON?["userData"] as? NSDictionary
                            GlobalVariables.user_id = (userData!["user_id"] as! String)
                            GlobalVariables.name = (userData!["name"] as! String)
                            GlobalVariables.user_name = (userData!["user_name"] as! String)
                            GlobalVariables.user_pic = (userData!["user_pic"] as! String)
                            GlobalVariables.user_type = (userData!["user_type"] as! String)
                            GlobalVariables.user_type_name = (userData!["user_type_name"] as! String)
                            
                            //Mark: navigation to Dashboard
                            if GlobalVariables.user_type_name == "TNSRLM"
                            {
                                // Mark : Parseing dashboardData tnsrlm
                                ///let dashboardData = JSON?["dashboardData"] as? NSDictionary
//                                GlobalVariables.center_count =  String(format: "%@",dashboardData!["center_count"] as! CVarArg)
//                                GlobalVariables.mobilizer_count = String(format: "%@",dashboardData!["mobilizer_count"]  as! CVarArg)
//                                GlobalVariables.student_count = String(format: "%@",dashboardData!["student_count"]  as! CVarArg)
//
                                self.performSegue(withIdentifier:"M3_TnsrlmDashboard", sender: self)
                            }
                            else
                            {
                                // Mark : Parseing dashboardData
                               //let dashboardData = JSON?["dashboardData"] as? NSDictionary
//                                GlobalVariables.center_count =  String(format: "%@",dashboardData!["center_count"] as! CVarArg)
//                                GlobalVariables.mobilizer_count = String(format: "%@",dashboardData!["mobilizer_count"]  as! CVarArg)
//                                GlobalVariables.student_count = String(format: "%@",dashboardData!["student_count"]  as! CVarArg)
//                                GlobalVariables.task_count = String(format: "%@",dashboardData!["task_count"]  as! CVarArg)
                                
                                //Mark: Project Period
//                                var project_period = dashboardData!["project_period"] as? [AnyHashable : Any]
//                                GlobalVariables.period_from = project_period?["period_from"] as? String
//                                GlobalVariables.period_to = project_period?["period_from"] as? String
                                
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
