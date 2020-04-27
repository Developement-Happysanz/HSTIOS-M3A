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
import SwiftyJSON
import MBProgressHUD

class Scheme: UIViewController,YouTubePlayerDelegate
{
    var scheme_name = [String]()
    var scheme_gallery = [String]()
    var scheme_galleryID = [String]()
    var scheme_video = [String]()
    var scheme_info = [String]()
    var scheme_id = [String]()
    var strSchemeId = String()

    @IBOutlet var schemeTextview: UITextView!
    @IBOutlet var schemeTitle: UILabel!
    @IBOutlet var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var videosOutlet: UIButton!
    @IBOutlet weak var galleryOutlet: UIButton!
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NavigationBarTitleColor.navbar_TitleColor
        self.schemeTextview.backgroundColor = UIColor.clear
        
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            webRequestTnrilm ()
        }
        else
        {
            setupSideMenu()
            webRequest()
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
    
    func webRequestTnrilm ()
    {
        let functionName = "apipia/scheme_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"scheme_id":self.strSchemeId]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let json =  JSON(response.result.value as Any)
                    let msg = json["msg"].string
                    let status = json["status"]
                    if (status == "success")
                    {
                        let scheme_name = json["scheme_details"]["schemeDetails"]["scheme_name"].stringValue
                        let scheme_info = json["scheme_details"]["schemeDetails"]["scheme_info"].stringValue
                        let scheme_video = json["scheme_details"]["schemeDetails"]["scheme_video"].stringValue
                        self.updateUI(name: scheme_name, info: scheme_info, video: scheme_video)
                        
                        self.scheme_galleryID.removeAll()
                        self.scheme_gallery.removeAll()
                        for scheme_photo in json["scheme_photo"]["scheme_gallery"].arrayValue
                        {
                            if let gallery_id = scheme_photo["gallery_id"].string,
                            let scheme_photo = scheme_photo["scheme_photo"].string
                            {
                                self.scheme_id.append(gallery_id)
                                self.scheme_gallery.append(scheme_photo)
                            }
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)

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
        let functionName = "apipia/scheme_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"scheme_id":GlobalVariables.scheme_id!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let json =  JSON(response.result.value as Any)
                    let msg = json["msg"].string
                    let status = json["status"]
                    if (status == "success")
                    {
                        let scheme_name = json["scheme_details"]["schemeDetails"]["scheme_name"].stringValue
                        let scheme_info = json["scheme_details"]["schemeDetails"]["scheme_info"].stringValue
                        let scheme_video = json["scheme_details"]["schemeDetails"]["scheme_video"].stringValue
                        self.updateUI(name: scheme_name, info: scheme_info, video: scheme_video)
                        
                        self.scheme_galleryID.removeAll()
                        self.scheme_gallery.removeAll()
                        for scheme_photo in json["scheme_photo"]["scheme_gallery"].arrayValue
                        {
                            if let gallery_id = scheme_photo["gallery_id"].string,
                            let scheme_photo = scheme_photo["scheme_photo"].string
                            {
                                self.scheme_id.append(gallery_id)
                                self.scheme_gallery.append(scheme_photo)
                            }
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)

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
    
    func updateUI(name:String,info:String,video:String)
    {
        self.schemeTitle.text = name
        self.schemeTextview.text = info
        videoPlayer.loadVideoID(video)
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView)
    {
        
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState)
    {
         print("playerReady")
    }
        
    @IBAction func galleryAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_Gallery", sender: self)
    }
    
    
    // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           if (segue.identifier == "to_Gallery") {
               let vc = segue.destination as! GalleryList
               vc.centerPhoto = self.scheme_gallery
               vc.fromScheme = "YES"
           }
       }
       

    
}
