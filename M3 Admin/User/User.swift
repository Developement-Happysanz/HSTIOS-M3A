//
//  User.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 19/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class User: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    var name : NSMutableArray = NSMutableArray()
    var user_type_name : NSMutableArray = NSMutableArray()
    var status : NSMutableArray = NSMutableArray()
    var user_master_id : NSMutableArray = NSMutableArray()
    var user_id : NSMutableArray = NSMutableArray()

    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func menuButton(_ sender: Any)
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.backgroundColor = UIColor.clear
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            webrequestAllUsersTNSRLM ()
        }
        else
        {
            let str = UserDefaults.standard.string(forKey: "fromDashboard")
            
            if str != "YES"
            {
                setupSideMenu()
            }
            webrequestAllUsers ()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         if GlobalVariables.user_type_name == "TNSRLM"
        {
            navigationLeftButton ()
            let str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
            if str == "YES"
            {
                self.title = "TNSRLM STAFF"
                navigationRightButton ()
                navigationLeftButton ()

            }
            else
            {
                self.title = "MOBILIZER"
                navigationLeftButton ()
            }
             webrequestAllUsersTNSRLM ()
        }
        else
        {
            self.title = "MOBILIZER"
            navigationRightButton ()
            webrequestAllUsers ()
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
            let str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
            if str == "YES"
            {
                self.performSegue(withIdentifier: "user_TNSRLM_Dashboard", sender: self)
            }
            else
            {
                self.performSegue(withIdentifier: "to_Dashboard", sender: self)
            }
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
        UserDefaults.standard.set("fromAdd", forKey: "user_View") //setObject
        self.performSegue(withIdentifier: "addUser", sender: self)
    }
    
    func webrequestAllUsers ()
    {
        let functionName = "apipia/user_list"
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
                        let studentList = JSON?["userList"] as? [Any]
                        
                        self.name.removeAllObjects()
                        self.user_type_name.removeAllObjects()
                        self.status.removeAllObjects()
                        self.user_master_id.removeAllObjects()
                        self.user_id.removeAllObjects()
                        
                        for i in 0..<(studentList?.count ?? 0)
                        {
                            let dict = studentList?[i] as? [AnyHashable : Any]
                            let name = dict?["name"] as? String
                            let usertypename = dict?["user_type_name"] as? String
                            let usermaster_id = dict?["user_master_id"] as? String
                            let Status = dict?["status"] as? String
                            let user_id = dict?["user_id"] as? String

                            self.name.add(name!)
                            self.user_type_name.add(usertypename!)
                            self.status.add(Status!)
                            self.user_master_id.add(usermaster_id!)
                            self.user_id.add(user_id!)

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
    
    func webrequestAllUsersTNSRLM ()
    {
        let str = UserDefaults.standard.string(forKey: "Tnsrlmstaff")
        if str == "YES"
        {
            let functionName = "apimain/user_list"
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
                            let studentList = JSON?["userList"] as? [Any]
                            self.name.removeAllObjects()
                            self.user_type_name.removeAllObjects()
                            self.status.removeAllObjects()
                            self.user_master_id.removeAllObjects()
                            self.user_id.removeAllObjects()

                            for i in 0..<(studentList?.count ?? 0)
                            {
                                let dict = studentList?[i] as? [AnyHashable : Any]
                                let name = dict?["name"] as? String
                                let usertypename = dict?["user_type_name"] as? String
                                let usermaster_id = dict?["user_master_id"] as? String
                                let Status = dict?["status"] as? String
                                let user_id = dict?["user_id"] as? String

                                self.name.add(name!)
                                self.user_type_name.add(usertypename!)
                                self.status.add(Status!)
                                self.user_master_id.add(usermaster_id!)
                                self.user_id.add(user_id!)

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
        else
        {
            let functionName = "apimain/pia_mob_list"
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
                            let studentList = JSON?["userList"] as? [Any]
                            self.name.removeAllObjects()
                            self.user_type_name.removeAllObjects()
                            self.status.removeAllObjects()
                            self.user_master_id.removeAllObjects()
                            self.user_id.removeAllObjects()

                            
                            for i in 0..<(studentList?.count ?? 0)
                            {
                                let dict = studentList?[i] as? [AnyHashable : Any]
                                let name = dict?["name"] as? String
                                let usertypename = dict?["user_type_name"] as? String
                                let usermaster_id = dict?["user_master_id"] as? String
                                let Status = dict?["status"] as? String
                                let user_id = dict?["user_id"] as? String

                                self.name.add(name!)
                                self.user_type_name.add(usertypename!)
                                self.status.add(Status!)
                                self.user_master_id.add(usermaster_id!)
                                self.user_id.add(user_id!)

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UserTableViewCell
        
        cell.name.text = (name[indexPath.row] as! String)
        //cell.role.text = (user_type_name[indexPath.row] as! String)
        cell.status.text = (status[indexPath.row] as! String)
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        GlobalVariables.user_master_id = (user_master_id[indexPath.row] as! String)
        GlobalVariables.mobilizer_id = (user_id[indexPath.row] as! String)
        GlobalVariables.selectedMobilizerName = (name[indexPath.row] as! String)
        UserDefaults.standard.set("fromList", forKey: "user_View") //setObject
        let str = UserDefaults.standard.object(forKey: "tnsrlmPia") as? String
        if GlobalVariables.user_type_name != "TNSRLM"
        {
            self.performSegue(withIdentifier: "addUser", sender: self)
        }
        else
        {
            if (str == "staff")
            {
               self.performSegue(withIdentifier: "addUser", sender: self)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
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
