//
//  TNSRLM_Mobiliser.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class TNSRLM_Mobiliser: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var name : NSMutableArray = NSMutableArray()
    
    var mobiliserID : NSMutableArray = NSMutableArray()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor

        self.title = "Mobilizer"
        
        webRequest ()
        
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
                        let userList = JSON?["userList"] as? [Any]
                        self.name.removeAllObjects()
                        //self.user_type_name.removeAllObjects()
                        //self.user_master_id.removeAllObjects()
                        for i in 0..<(userList?.count ?? 0)
                        {
                            let dict = userList?[i] as? [AnyHashable : Any]
                            let name = dict?["name"] as? String
                            let mobiliser_id = dict?["user_id"] as? String
                            //let usermaster_id = dict?["user_master_id"] as? String
                            
                            self.name.add(name!)
                            self.mobiliserID.add(mobiliser_id!)
                            //self.user_master_id.add(usermaster_id!)
                            
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        GlobalVariables.center_id = (centerID[indexPath.row] as! String)
//        self.performSegue(withIdentifier: "TNSRLM_CenterLIST_PiaCenterDetail", sender: self)
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
