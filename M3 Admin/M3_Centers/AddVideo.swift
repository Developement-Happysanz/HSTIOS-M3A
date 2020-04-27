//
//  AddVideo.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 08/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddVideo: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var videoTitleLabel: UITextField!
    @IBOutlet weak var videoLink: UITextField!
    @IBOutlet weak var saveOtlet: UIButton!
    
    @IBAction func saveButton(_ sender: Any)
    {
        let videoTitle = videoTitleLabel.text
        let videolink = videoLink.text
        
        if (videoTitle!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "videoTitle is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(videolink!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "videolink is empty", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let functionName = "apipia/add_center_videos"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id":GlobalVariables.user_id!, "center_id":GlobalVariables.center_id as Any, "video_title":videoTitleLabel.text!, "video_link":videoLink.text!]
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
                        let status = JSON?["status"] as? String
                        if (status == "success")
                        {
                            self.videoTitleLabel.text = ""
                            self.videoLink.text = ""
                            self.performSegue(withIdentifier: "addVideo_videoList", sender: self)
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Add Video"
        videoTitleLabel.delegate = self
        videoLink.delegate = self
        saveOtlet.layer.cornerRadius = 4
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationLeftButton ()
    }
    
    @objc func dismissKeyboard()
    {
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
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if textField == videoTitleLabel
        {
            videoLink.becomeFirstResponder()
        }
        else
        {
            videoLink.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            self.view.endEditing(true);
        }
        
    }
    
    func navigationLeftButton ()
    {
        let navigationLeftButton = UIButton(type: .custom)
        navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLeftButton.addTarget(self, action: #selector(backButtonclick), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func backButtonclick()
    {
        self.performSegue(withIdentifier: "addVideo_videoList", sender: self)
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
