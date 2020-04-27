//
//  SchemeList.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 24/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import SideMenu

class SchemeList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var schemeId = [String]()
    var schemeName = [String]()
    var strSchemeId = String()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Scheme"
        NavigationBarTitleColor.navbar_TitleColor
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.backgroundColor = UIColor.clear
        setupSideMenu()
        self.webServiceCall()
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
    
    func webServiceCall ()
    {
        let functionName = "apipia/list_scheme"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let json = JSON(response.result.value as Any)
                    let msg = json["msg"].string
                    let status = json["status"]
                    if (status == "success")
                    {
                        // Mark : Parseing userData
                        self.schemeId.removeAll()
                        self.schemeName.removeAll()
                        for schemeDetails in json["schemeDetails"].arrayValue
                        {
                            if  let scheme_name = schemeDetails["scheme_name"].string,
                                let scheme_id = schemeDetails["scheme_id"].string {
                                self.schemeId.append(scheme_id)
                                self.schemeName.append(scheme_name)
                           }
                            self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 41
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schemeName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! SchemeTableViewCell
        cell.schemeName.text = schemeName[indexPath.row]
        cell.serialNUmber.text = "\(indexPath.row + 1)"
//        cell.cellView.layer.cornerRadius = 5.0
//        cell.cellView.layer.borderWidth = 1.0
//        cell.cellView.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.strSchemeId = schemeId[indexPath.row]
        self.performSegue(withIdentifier: "schemeDetail", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "schemeDetail") {
            let vc = segue.destination as! Scheme
            vc.strSchemeId = self.strSchemeId
        }
    }
    

}
