//
//  VideoList.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 05/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import YouTubePlayer
import Alamofire

class VideoList: UIViewController,YouTubePlayerDelegate,UITableViewDataSource,UITableViewDelegate
{
   
    var videoTitle = [String]()
    var videoUrl = [String]()
    var video_id = [String]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // navigationRightButton ()
        
        self.title = "Video"
        
        webRequest ()
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
        self.performSegue(withIdentifier: "addvideo", sender: self)

    }
    func webRequest ()
    {
        let functionName = "apipia/center_videos/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "center_id": GlobalVariables.center_id!]
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
                        let centerVideos = JSON?["centerVideos"] as? [Any]
                        for i in 0..<(centerVideos?.count ?? 0)
                        {
                            let dict = centerVideos?[i] as? [AnyHashable : Any]
                            let video_title = dict?["video_title"] as? String
                            let video_url = dict?["video_url"] as? String
                            let videoID = dict?["video_id"] as? String

                            self.videoTitle.append(video_title ?? "")
                            self.videoUrl.append(video_url ?? "")
                            self.video_id.append(videoID ?? "")

                        }
                        
                            self.tableView.reloadData()
                    }
                    else
                    {
                        self.tableView.reloadData()
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
        return videoUrl.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)as! VideoTableViewCell

        let VideoUrlOne = videoUrl[indexPath.row]
        cell.playerView.delegate = self
        cell.playerView.loadVideoID(VideoUrlOne)
        cell.titleLabel.text = videoTitle[indexPath.row]

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 263
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
      {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let videoId = video_id[indexPath.row]
            print(videoId)
            self.webRequestRemoveFromList(VideoID: videoId)
        }
      }
        
      func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
      {
         return "Delete"
      }
    
    func webRequestRemoveFromList(VideoID:String)
    {
        let functionName = "apipia/center_video_delete"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["video_id":VideoID]
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
                        self.webRequest()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
