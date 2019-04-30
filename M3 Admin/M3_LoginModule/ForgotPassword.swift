//
//  ForgotPassword.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 26/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ForgotPassword: UIViewController,UITextFieldDelegate
{
    
    var activeField: UITextField?
    
    var lastOffset: CGPoint!
    
    var keyboardHeight: CGFloat!

    @IBAction func backAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "M3_Login", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "login") as! Login
        self.present(login, animated: true, completion: nil)
    }
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var submitOutlet: UIButton!
    
    @IBAction func submitAction(_ sender: Any)
    {
        let user_Name = userName.text
        if (user_Name == "")
        {
            let alertController = UIAlertController(title: "M3", message: "username cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let functionName = "apimain/forgot_password/"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_name": user_Name!]
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
                        if (msg == "Password Updated")
                        {
                            
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                self.userName.text = ""
                                
                                let storyboard = UIStoryboard(name: "M3_Login", bundle: nil)
                                let login = storyboard.instantiateViewController(withIdentifier: "login") as! Login
                                self.present(login, animated: true, completion: nil)
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor
        
        userName.delegate = self
    
        submitOutlet.layer.cornerRadius = 4
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)

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
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
        self.view.endEditing(true);
    }
    
}
