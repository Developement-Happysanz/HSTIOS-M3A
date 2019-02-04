//
//  CenterDetail.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 01/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import YouTubePlayer
import Alamofire


class CenterDetail: UIViewController,YouTubePlayerDelegate,UITextViewDelegate
{
    var centerPhoto = [String]()
    var galleryId = [String]()
    
    var videoId = [String]()
    var videoTitle = [String]()
    var videoUrl = [String]()

    @IBOutlet weak var imageviewOne: UIImageView!
    
    @IBOutlet weak var imageviewTwo: UIImageView!
    
    @IBOutlet weak var imageviewThree: UIImageView!
    
    @IBOutlet weak var videoplayerOne: YouTubePlayerView!
    
    @IBOutlet weak var videoplayerTwo: YouTubePlayerView!
    
    @IBOutlet weak var videoplayerThree: YouTubePlayerView!
    
    @IBOutlet weak var centerLogo: UIImageView!
    
    @IBOutlet weak var centerName: UILabel!
    
    @IBOutlet weak var centerDetail: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webRequest ()
        
        webRequest_Gallery ()
        
        webRequest_Video ()
        
        centerDetail.delegate = self
        
    }
    func webRequest ()
    {
        let functionName = "apipia/center_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"center_id": GlobalVariables.center_id!]
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
                        var centerList = JSON?["cenerDetails"] as? [Any]
                        for i in 0..<(centerList?.count ?? 0)
                        {
                            var dict = centerList?[i] as? [AnyHashable : Any]
                            self.centerName.text = dict?["center_name"] as? String
                            let centerdetails   = dict?["center_info"] as? String
                            self.centerDetail.text = centerdetails
                            let center_logo = dict?["center_logo"] as? String
                            
                            let url = URL(string:center_logo!)
                            if let data = try? Data(contentsOf: url!)
                            {
                                let image: UIImage = UIImage(data: data)!
                                self.centerLogo.image = image
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
    func webRequest_Gallery ()
    {
        let functionName = "apipia/center_gallery"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"center_id": GlobalVariables.center_id!]
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
                        var centerGallery = JSON?["centerGallery"] as? [Any]
                        for i in 0..<(centerGallery?.count ?? 0)
                        {
                            var dict = centerGallery?[i] as? [AnyHashable : Any]
                            let center_photo = dict?["center_photo"] as? String
                            let gallery_id = dict?["gallery_id"] as? String
                    
                            self.centerPhoto.append(center_photo ?? "")
                            self.galleryId.append(gallery_id ?? "")
                        }
                            self.loadGallery ()
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
    func loadGallery ()
    {
        let isIndexOne = videoUrl.indices.contains(0)
        if (isIndexOne == true)
        {
            let urlImageOne = centerPhoto[0]
            let url = URL(string:urlImageOne)
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                self.imageviewOne.image = image
            }
        }
        else
        {
            
        }
        
        let isIndexTwo = videoUrl.indices.contains(1)
        if (isIndexTwo == true)
        {
            let urlImageOne = centerPhoto[1]
            let url = URL(string:urlImageOne)
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                self.imageviewTwo.image = image
            }
        }
        else
        {
            
        }
        
        let isIndexThree = videoUrl.indices.contains(2)
        if (isIndexThree == true)
        {
            let urlImageOne = centerPhoto[2]
            let url = URL(string:urlImageOne)
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                self.imageviewThree.image = image
            }
        }
        else
        {
            
        }
    }
    
    func webRequest_Video ()
    {
        let functionName = "apipia/center_videos"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!,"center_id": GlobalVariables.center_id!]
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
                        var centerVideos = JSON?["centerVideos"] as? [Any]
                        for i in 0..<(centerVideos?.count ?? 0)
                        {
                            var dict = centerVideos?[i] as? [AnyHashable : Any]
                            let video_id = dict?["video_id"] as? String
                            let video_title   = dict?["video_title"] as? String
                            let video_url  = dict?["video_url"] as? String
                            
                            
                            self.videoId.append(video_id ?? "")
                            self.videoTitle.append(video_title ?? "")
                            self.videoUrl.append(video_url ?? "")
                        }
                            self.loadVideos ()
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
    func loadVideos ()
    {
        let isIndexOne = videoUrl.indices.contains(0)
        if (isIndexOne == true)
        {
            let VideoUrlOne = videoUrl[0]
            videoplayerOne.delegate = self
            videoplayerOne.loadVideoID(VideoUrlOne)
        }
        else
        {
            videoplayerOne.delegate = self
            videoplayerOne.loadVideoID("WNeLUngb-Xg")
        }
        
        let isIndexTwo = videoUrl.indices.contains(1)
        if (isIndexTwo == true)
        {
            let VideoUrlTwo = videoUrl[1]
            videoplayerTwo.delegate = self
            videoplayerTwo.loadVideoID(VideoUrlTwo)
        }
        else
        {
            videoplayerTwo.delegate = self
            videoplayerTwo.loadVideoID("WNeLUngb-Xg")
        }

        let isIndexThree = videoUrl.indices.contains(2)
        if (isIndexThree == true)
        {
            let VideoUrlThree = videoUrl[2]
            videoplayerThree.delegate = self
            videoplayerThree.loadVideoID(VideoUrlThree)
        }
        else
        {
            videoplayerThree.delegate = self
            videoplayerThree.loadVideoID("WNeLUngb-Xg")
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
