//
//  PIAList.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class PIAList: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var name : NSMutableArray = NSMutableArray()
    
    var user_type_name : NSMutableArray = NSMutableArray()
    
    var user_master_id : NSMutableArray = NSMutableArray()
   
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor

        navigationLeftButton ()
        
        let str = UserDefaults.standard.string(forKey: "tnsrlmPia")
        
        if str == "YES"
        {
             navigationRightButton ()
        }
    
        self.title = "PIA LIST"
        
        webRequest ()
        
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
       self.performSegue(withIdentifier: "tnsrlm_Dashbaord", sender: self)
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
        UserDefaults.standard.set("FromAdd", forKey: "pia_Creation")
        self.performSegue(withIdentifier: "addPIA", sender: self)
    }
    
    func webRequest ()
    {
        let functionName = "apimain/pia_list"
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
                        var studentList = JSON?["userList"] as? [Any]
                        self.name.removeAllObjects()
                        self.user_type_name.removeAllObjects()
                        self.user_master_id.removeAllObjects()
                        for i in 0..<(studentList?.count ?? 0)
                        {
                            var dict = studentList?[i] as? [AnyHashable : Any]
                            let name = dict?["name"] as? String
                            let usertypename = dict?["user_type_name"] as? String
                            let usermaster_id = dict?["user_id"] as? String

                            self.name.add(name!)
                            self.user_type_name.add(usertypename!)
                            self.user_master_id.add(usermaster_id!)

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! PIAListTableViewCell
        
        cell.serilaNumber.text =  "\(indexPath.row + 1)."
        
        cell.academyName.text = (name[indexPath.row] as! String)
        
        cell.editOutlet.tag = indexPath.row;
        
        cell.editOutlet.addTarget(self, action: #selector(editbuttonClicked), for: .touchUpInside)

        return cell
    }
    
    @objc func editbuttonClicked(sender:UIButton)
    {
        let buttonRow = Int(sender.tag)
        GlobalVariables.pia_id = (user_master_id[buttonRow] as! String)
        UserDefaults.standard.set("FromList", forKey: "pia_Creation")
        self.performSegue(withIdentifier: "addPIA", sender: self)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        GlobalVariables.pia_id = (user_master_id[indexPath.row] as! String)
        
        let str = UserDefaults.standard.string(forKey: "tnsrlmPia")
        
        if str == "YES"
        {
            // self.performSegue(withIdentifier: "M3_Dashbaord", sender: self)
        }
        else if str == "center"
        {
             self.performSegue(withIdentifier: "tnsrlm_Piacenter", sender: self)
        }
        else if str == "mobiliser"
        {
            UserDefaults.standard.set("NO", forKey: "Tnsrlmstaff")
            self.performSegue(withIdentifier: "TNSRLM_pia_user", sender: self)
        }
        else if str == "prospects"
        {
            self.performSegue(withIdentifier: "TNSRLM_pia_prospect", sender: self)
        }
        else if str == "mobiliserPlan"
        {
            self.performSegue(withIdentifier: "M3MobiliserPlan", sender: self)
        }
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 56
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
