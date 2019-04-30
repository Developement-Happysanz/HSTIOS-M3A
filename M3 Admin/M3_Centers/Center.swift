//
//  Center.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 08/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class Center: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var centerName = [String]()
    var centerAddress = [String]()
    var centerId = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func menuButton(_ sender: Any)
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      
        
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            navigationLeftButton ()
            webRequestTnsrlm ()
        }
        else
        {
            navigationLeftButton ()
            navigationRightButton ()
            webRequest ()
        }
        
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str != "YES"
        {
            setupSideMenu()
        }
        
    }
    fileprivate func setupSideMenu()
    {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }
    func navigationLeftButton ()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")

        if GlobalVariables.user_type_name == "TNSRLM" || str == "YES"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
        else
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "sidemenu_button"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
    }
    
    @objc func menuButtonclick()
    {
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            self.performSegue(withIdentifier: "tnsrlm_piaList", sender: self)
            
        }
        else
        {
            let str = UserDefaults.standard.string(forKey: "fromDashboard")
            
            if str == "YES"
            {
                self.performSegue(withIdentifier: "to_Dashboard", sender: self)
            }
            else
            {
                present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
            }
        }
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
        self.performSegue(withIdentifier: "center_AddCenter", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return centerName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)as! CenterTableViewCell
        cell.centerName.text = centerName[indexPath.row]
        cell.centerLocation.text = centerAddress[indexPath.row]

        cell.subView.layer.cornerRadius = 3.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        GlobalVariables.center_id = centerId[indexPath.row]
        
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            self.performSegue(withIdentifier: "tnsrlm_Center", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "centerDetail", sender: self)

        }
        
    }
    
    func webRequest ()
    {
        let functionName = "apipia/center_list"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
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
                        var centerList = JSON?["centerList"] as? [Any]
                        for i in 0..<(centerList?.count ?? 0)
                        {
                            var dict = centerList?[i] as? [AnyHashable : Any]
                            let center_name = dict?["center_name"] as? String
                            let center_address = dict?["center_address"] as? String
                            let center_id = dict?["id"] as? String
                            
                            self.centerName.append(center_name ?? "")
                            self.centerAddress.append(center_address ?? "")
                            self.centerId.append(center_id ?? "")

                        }
                        
                            self.tableView.reloadData()
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
    
    func webRequestTnsrlm ()
    {
        let functionName = "apimain/pia_center_list"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["pia_id": GlobalVariables.pia_id!]
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
                        var centerList = JSON?["centerList"] as? [Any]
                        for i in 0..<(centerList?.count ?? 0)
                        {
                            var dict = centerList?[i] as? [AnyHashable : Any]
                            let center_name = dict?["center_name"] as? String
                            let center_address = dict?["center_address"] as? String
                            let center_id = dict?["id"] as? String
                            
                            self.centerName.append(center_name ?? "")
                            self.centerAddress.append(center_address ?? "")
                            self.centerId.append(center_id ?? "")
                            
                        }
                        
                        self.tableView.reloadData()
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
