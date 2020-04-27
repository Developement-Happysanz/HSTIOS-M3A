//
//  Paln.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 22/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import WebKit
import MBProgressHUD

class Plan: UIViewController,UITableViewDelegate,UITableViewDataSource, UIDocumentInteractionControllerDelegate
{
    var doc_name : NSMutableArray = NSMutableArray()
    
    var doc_month_year : NSMutableArray = NSMutableArray()
    
    var plan_id : NSMutableArray = NSMutableArray()

    var doc_url : NSMutableArray = NSMutableArray()

    // Creating UIDocumentInteractionController instance.
    let documentInteractionController = UIDocumentInteractionController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Mobilization Plan"
        NavigationBarTitleColor.navbar_TitleColor
        documentInteractionController.delegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.backgroundColor = UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            navigationLeftButton ()
            webRequestTnsrlm ()

        }
        else
        {
            navigationRightButton ()
//          setupSideMenu()
            webRequest ()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    func navigationLeftButton ()
    {
        if GlobalVariables.user_type_name == "TNSRLM"
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
            self.performSegue(withIdentifier: "tnsrlmPiaList", sender: self)
        }
        else
        {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
        self.performSegue(withIdentifier: "plan_addPlan", sender: self)
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
    
    func webRequestTnsrlm ()
    {
        let functionName = "apipia/mobilization_plan_list"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.pia_id!]
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
                        let planDetails = JSON?["planDetails"] as? [Any]
                        self.doc_name.removeAllObjects()
                        self.doc_month_year.removeAllObjects()
                        self.plan_id.removeAllObjects()
                        self.doc_url.removeAllObjects()
                        for i in 0..<(planDetails?.count ?? 0)
                        {
                            let dict = planDetails?[i] as? [AnyHashable : Any]
                            let docname = dict?["doc_name"] as? String
                            let docmonth_year = dict?["doc_month_year"] as? String
                            let planid = dict?["plan_id"] as? String
                            let docurl = dict?["doc_url"] as? String


                            self.doc_name.add(docname!)
                            self.doc_month_year.add(docmonth_year!)
                            self.plan_id.add(planid!)
                            self.doc_url.add(docurl!)

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
    
    func webRequest ()
    {
        let functionName = "apimain/pia_plan_list"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["pia_id": GlobalVariables.user_id!]
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
                        let planDetails = JSON?["planList"] as? [Any]
                        self.doc_name.removeAllObjects()
                        self.doc_month_year.removeAllObjects()
                        self.plan_id.removeAllObjects()
                        self.doc_url.removeAllObjects()
                        
                        for i in 0..<(planDetails?.count ?? 0)
                        {
                            let dict = planDetails?[i] as? [AnyHashable : Any]
                            let docname = dict?["doc_name "] as? String
                            let docmonth_year = dict?["doc_month_year "] as? String
                            let planid = dict?["pia_id"] as? String
                            let docurl = dict?["doc_file"] as? String

                            self.doc_name.add(docname!)
                            self.doc_month_year.add(docmonth_year!)
                            self.plan_id.add(planid!)
                            self.doc_url.add(docurl!)

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
        return doc_name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UserTableViewCell
        
        cell.name.text = (doc_name[indexPath.row] as! String)
        cell.role.text = (doc_month_year[indexPath.row] as! String)
        cell.downloadOutlet.tag = indexPath.row
        cell.downloadOutlet.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        
        cell.subView.layer.cornerRadius = 3.0

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
      {
          return 83
      }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        let rowNumber : Int = indexPath!.row
//        let _url = doc_url[rowNumber]
//        storeAndShare(withURLString: _url as! String)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      // MBProgressHUD.showAdded(to: self.view, animated: true)
      
    }
}
//extension Plan {
//
//    func share(url: URL) {
//        documentInteractionController.url = url
//        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
//        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
//        documentInteractionController.presentPreview(animated: true)
//    }
//
//    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
//    func storeAndShare(withURLString: String)
//    {
//        guard let url = URL(string: withURLString) else { return }
//        /// START YOUR ACTIVITY INDICATOR HERE
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            let tmpURL = FileManager.default.temporaryDirectory
//                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
//            do {
//                try data.write(to: tmpURL)
//            } catch {
//                print(error)
//            }
//            DispatchQueue.main.async {
//                /// STOP YOUR ACTIVITY INDICATOR HERE
//                MBProgressHUD.hide(for: self.view, animated: true)
//                self.share(url: tmpURL)
//            }
//            }.resume()
//    }
//}
//
//extension Plan: UIDocumentInteractionControllerDelegate
//{
//    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
//    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        guard let navVC = self.navigationController else {
//            return self
//        }
//        return navVC
//    }
//}
//
//extension URL
//{
//    var typeIdentifier: String? {
//        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
//    }
//    var localizedName: String? {
//        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
//    }
//}
