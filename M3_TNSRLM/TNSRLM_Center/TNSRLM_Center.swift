//
//  TNSRLM_Center.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class TNSRLM_Center: UIViewController
{

    @IBOutlet var center_Logo: UIImageView!
    @IBOutlet var centerName: UILabel!
    @IBOutlet var centerDetail: UITextView!
    @IBOutlet var gallery: UIButton!
    @IBAction func galleryButton(_ sender: Any)
    {
         self.performSegue(withIdentifier: "tnsrlm_Gallery", sender: self)
    }
    @IBOutlet var video: UIButton!
    @IBAction func videButton(_ sender: Any)
    {
         self.performSegue(withIdentifier: "tnsrlm_Video", sender: self)
    }
    @IBOutlet var galleryView: UIView!
    @IBOutlet var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webRequest ()
        
        NavigationBarTitleColor.navbar_TitleColor

        navigationLeftButton ()

    }
    
    func navigationLeftButton ()
    {
        
        let navigationLeftButton = UIButton(type: .custom)
        navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
        navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
        self.navigationItem.setLeftBarButton(navigationButton, animated: true)
    }
    
    @objc func menuButtonclick()
    {
        self.performSegue(withIdentifier: "TNSRLM_DashBoard", sender: self)
    }
    
    func navigationRightButton ()
    {
        let navigationRightButton = UIButton(type: .custom)
        navigationRightButton.setImage(UIImage(named: "add"), for: .normal)
        navigationRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationRightButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationRightButton)
        self.navigationItem.setRightBarButtonItems([navigationButton], animated: true)
    }
    
    @objc func clickButton()
    {
        self.performSegue(withIdentifier: "TNSRL_CenterList_Pia_addCenter", sender: self)
    }
    
    func webRequest ()
    {
        let functionName = "apipia/center_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.pia_id!,"center_id": GlobalVariables.center_id!]
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
                        let centerList = JSON?["cenerDetails"] as? [Any]
                        for i in 0..<(centerList?.count ?? 0)
                        {
                            let dict = centerList?[i] as? [AnyHashable : Any]
                            self.centerName.text = dict?["center_name"] as? String
                            let centerdetails   = dict?["center_info"] as? String
                            self.centerDetail.text = centerdetails
                            let center_logo = dict?["center_logo"] as? String
                            
                            let url = URL(string:center_logo!)
                            if let data = try? Data(contentsOf: url!)
                            {
                                let image: UIImage = UIImage(data: data)!
                                self.center_Logo.image = image
                            }
                            
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
