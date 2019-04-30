//
//  Scheme.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 03/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import YouTubePlayer
import SideMenu
import Alamofire

class Scheme: UIViewController,YouTubePlayerDelegate
{
    
    var scheme_name = [String]()
    
    var scheme_video = [String]()
    
    var scheme_info = [String]()
    
    var scheme_id = [String]()

    
    @IBOutlet var schemeTextview: UITextView!
    
    @IBOutlet var schemeTitle: UILabel!
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    @IBAction func backBtn(_ sender: Any)
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor
        
        setupSideMenu()
        
        webRequest ()
                
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
    
    func  webRequest ()
    {
        let functionName = "apipia/list_scheme"
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
                        var centerList = JSON?["schemeDetails"] as? [Any]
                        for i in 0..<(centerList?.count ?? 0)
                        {
                            var dict = centerList?[i] as? [AnyHashable : Any]
                            let schemeid = dict?["scheme_id"] as? String
                            print(schemeid as Any)
                            let schemeinfo = dict?["scheme_info"] as? String
                            let schemename = dict?["scheme_name"] as? String
                           // let schemevideo = dict?["scheme_video"] as? String

//                            self.scheme_id.append(schemeid ?? "")
//                            self.scheme_info.append(schemeinfo ?? "")
//                            self.scheme_name.append(schemename ?? "")
                            //self.scheme_video.append(schemevideo ?? "")

                            self.schemeTitle.text = schemename
                            self.schemeTextview.text = schemeinfo
                            self.videoPlayer.delegate = self
                            self.videoPlayer.loadVideoID(dict?["scheme_video"] as! String)
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
    func playerReady(_ videoPlayer: YouTubePlayerView)
    {
        
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState)
    {
         print("playerReady")
    }
}
