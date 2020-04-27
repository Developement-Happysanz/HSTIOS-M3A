//
//  ChangePassword.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 03/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ChangePassword: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var oldPaswrd: UITextField!
    @IBOutlet weak var newPawrd: UITextField!
    @IBOutlet weak var confirmPaswrd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*Setting Delegates*/
        self.oldPaswrd.delegate = self
        self.newPawrd.delegate = self
        self.confirmPaswrd.delegate = self
        self.tapToDismissKeypad()


    }
    
    func tapToDismissKeypad ()
       {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tap)
       }
       
       @objc func dismissKeyboard() {
              //Causes the view (or one of its embedded text fields) to resign the first responder status.
              self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
              view.endEditing(true)
          }
    
    /*Textfield Delegate Methods */
      
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
      if textField == oldPaswrd
      {
          newPawrd.becomeFirstResponder()
      }
      else if textField == newPawrd
      {
          confirmPaswrd.becomeFirstResponder()
      }
      else if textField == confirmPaswrd
      {
          self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
          confirmPaswrd.resignFirstResponder()
      }
     
      return true
  }
      
  func textFieldDidBeginEditing(_ textField: UITextField)
  {
      if textField == oldPaswrd
      {
          self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
      }
      else if textField == newPawrd
      {
          self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
      }
      else if textField == confirmPaswrd
      {
          self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
      }

  }
    
    @IBAction func submitAction(_ sender: Any)
    {
        if self.oldPaswrd.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "Old Password cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (self.oldPaswrd.text!.count < 6)
        {
            let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.newPawrd.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "New Password cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (self.newPawrd.text!.count < 6)
        {
            let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if confirmPaswrd.text == ""
        {
            let alertController = UIAlertController(title: "M3", message: "Confirm Password cannot be empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (self.confirmPaswrd.text!.count < 6)
        {
            let alertController = UIAlertController(title: "M3", message: "Short passwords are easy to guess!\nTry one with atleast 6 characters", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
               print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if self.newPawrd.text != self.confirmPaswrd.text
        {
            let alertController = UIAlertController(title: "M3", message: "Password mismatch", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.changePassword(oldpassword: self.oldPaswrd.text!,newpassword: self.newPawrd.text!)
        }
    }
    
    func changePassword (oldpassword:String,newpassword:String)
    {
        let functionName = "apimain/change_password/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"old_password":oldpassword,"new_password":newpassword]
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
                    if (msg == "Password Updated")
                    {
                        //Mark : Parseing userData
                       let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                       let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           print("You've pressed default");
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
