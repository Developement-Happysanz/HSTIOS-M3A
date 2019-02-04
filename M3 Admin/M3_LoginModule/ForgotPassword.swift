//
//  ForgotPassword.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 26/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//

import UIKit

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
