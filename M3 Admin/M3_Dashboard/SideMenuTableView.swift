//
//  SideMenuTableView.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class SideMenuTableView: UITableViewController
{

     var masterndexisClicked = true
    
    @IBOutlet weak var dropDown: UIImageView!
    
    @IBAction func schemeButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "sidemenu_Scheme", sender: self)
    }
    @IBAction func centerButton(_ sender: Any)
    {
         self.performSegue(withIdentifier: "sidemenu_Center", sender: self)
    }
    @IBAction func projectButton(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "M3_Dashboard", bundle: nil)
        let project = storyBoard.instantiateViewController(withIdentifier: "project") as! Project
        self.navigationController?.pushViewController(project, animated: true)
    }
    @IBAction func tradeButton(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "M3_Dashboard", bundle: nil)
        let trade = storyBoard.instantiateViewController(withIdentifier: "trade") as! Trade
        self.navigationController?.pushViewController(trade, animated: true)
    }
    @IBAction func batchButton(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "M3_Dashboard", bundle: nil)
        let batch = storyBoard.instantiateViewController(withIdentifier: "batch") as! Batch
        self.navigationController?.pushViewController(batch, animated: true)
    }
    @IBAction func trade_batchButton(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "M3_Dashboard", bundle: nil)
        let tradeBatch = storyBoard.instantiateViewController(withIdentifier: "tradeBatch") as! TradeBatch
        self.navigationController?.pushViewController(tradeBatch, animated: true)
    }
    @IBAction func timeButton(_ sender: Any)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "M3_Dashboard", bundle: nil)
        let time = storyBoard.instantiateViewController(withIdentifier: "time") as! Time
        self.navigationController?.pushViewController(time, animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NavigationBarTitleColor.navbar_TitleColor
        
        masterndexisClicked = false
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if (indexPath.row == 0)
        {
             return 191
        }
        else if (indexPath.row == 2)
        {
            if (masterndexisClicked == true)
            {
                return 360
            }
            else
            {
                 return 60
            }
        }
        else
        {
              return 60
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.row == 2)
        {
            if (masterndexisClicked == false)
            {
                masterndexisClicked = true
                
                tableView.reloadData()
            }
            else
            {
                masterndexisClicked = false
                
                tableView.reloadData()
            }
        }
    }

}
