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

class Scheme: UIViewController,YouTubePlayerDelegate
{
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
        
        videoPlayer.delegate = self
        videoPlayer.loadVideoID("WNeLUngb-Xg")
        
        setupSideMenu()
                
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
    func playerReady(_ videoPlayer: YouTubePlayerView)
    {
        
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState)
    {
         print("playerReady")
    }
}
