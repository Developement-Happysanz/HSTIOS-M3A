//
//  SideMenuTableView.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/01/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenuTableView: UITableViewController
{
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBAction func imageAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "profile", sender: self)

    }
    @IBOutlet weak var userName: UILabel!
    
     var masterndexisClicked = true
    
    @IBOutlet weak var dropDown: UIImageView!
    
    @IBAction func schemeButton(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "Tnsrlmstaff")
        self.performSegue(withIdentifier: "sidemenu_Scheme", sender: self)
    }
    @IBAction func centerButton(_ sender: Any)
    {
         UserDefaults.standard.set("NO", forKey: "fromDashboard")
         self.performSegue(withIdentifier: "sidemenu_Center", sender: self)
    }
    @IBAction func projectButton(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "sidemenu_ProjectPeriod", sender: self)
    }
    @IBAction func tradeButton(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "sidemenu_Trade", sender: self)
    }
    @IBAction func timeButton(_ sender: Any)
    {
       self.performSegue(withIdentifier: "sidemenu_Time", sender: self)
    }
    @IBAction func prospectsButton(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "sidemenu_Prospects", sender: self)
    }
    @IBAction func userButton(_ sender: Any)
    {
        UserDefaults.standard.set("NO", forKey: "fromDashboard")
        self.performSegue(withIdentifier: "sidemenu_User", sender: self)
    }
    @IBAction func planButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "sidemenu_Plan", sender: self)
    }
    @IBAction func dashboard(_ sender: Any)
    {
       // self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logOut(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: "M3", message: "Do you really want to logout?", preferredStyle: UIAlertController.Style.alert)
                
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            GlobalVariables.deviceToken = ""
            GlobalVariables.user_id = ""
            GlobalVariables.name = ""
            GlobalVariables.user_name = ""
            GlobalVariables.user_pic = ""
            GlobalVariables.user_type = ""
            GlobalVariables.user_type_name = ""
                           
           /* Dashboard values */
   //        GlobalVariables.center_count = ""
   //        GlobalVariables.mobilizer_count = ""
   //        GlobalVariables.student_count = ""
   //        GlobalVariables.task_count = ""
   //
   //        /* Project Period */
   //        GlobalVariables.period_from = ""
   //        GlobalVariables.period_to = ""
           
           
           /* center */
           GlobalVariables.center_id = ""
                           
           /* student details Scaning */
           GlobalVariables.aadhaar_card_number = ""
           GlobalVariables.address = ""
           GlobalVariables.admission_date = ""
           GlobalVariables.admission_latitude = ""
           GlobalVariables.admission_location = ""
           GlobalVariables.admission_longitude = ""
           GlobalVariables.age = ""
           GlobalVariables.blood_group = ""
           GlobalVariables.city = ""
           GlobalVariables.community = ""
           GlobalVariables.community_class = ""
           GlobalVariables.created_at = ""
           GlobalVariables.created_by = ""
           GlobalVariables.disability = ""
           GlobalVariables.dob = ""
           GlobalVariables.email = ""
           GlobalVariables.enrollment = ""
           GlobalVariables.father_name = ""
           GlobalVariables.have_aadhaar_card = ""
           GlobalVariables.studentid = ""
           GlobalVariables.last_institute = ""
           GlobalVariables.last_studied = ""
           GlobalVariables.mobile = ""
           GlobalVariables.mother_name = ""
           GlobalVariables.mother_tongue = ""
           GlobalVariables.studentname = ""
           GlobalVariables.nationality = ""
           GlobalVariables.pia_id = ""
           GlobalVariables.preferred_timing = ""
           GlobalVariables.preferred_trade = ""
           GlobalVariables.qualified_promotion = ""
           GlobalVariables.religion = ""
           GlobalVariables.sec_mobile = ""
           GlobalVariables.sex = ""
           GlobalVariables.state = ""
           GlobalVariables.status = ""
           GlobalVariables.student_pic = ""
           GlobalVariables.transfer_certificate = ""
           GlobalVariables.updated_at = ""
           GlobalVariables.updated_by = ""
           GlobalVariables.pincode = ""
           
           /* user details */
           GlobalVariables.role = ""
           GlobalVariables.usersname = ""
           GlobalVariables.userssex = ""
           GlobalVariables.usersdob = ""
           GlobalVariables.usersnationality = ""
           GlobalVariables.usersreligion = ""
           GlobalVariables.userscommunity_class = ""
           GlobalVariables.userscommunity = ""
           GlobalVariables.usersaddress = ""
           GlobalVariables.usersemail = ""
           GlobalVariables.sec_email = ""
           GlobalVariables.phone = ""
           GlobalVariables.sec_phone = ""
           GlobalVariables.qualification = ""
           GlobalVariables.user_master_id = ""
           
           UserDefaults.standard.removeObject(forKey: "View")
           UserDefaults.standard.removeObject(forKey: "user_View")
           UserDefaults.standard.removeObject(forKey: "Tnsrlmstaff")
           UserDefaults.standard.removeObject(forKey: "userIdKey")
           UserDefaults.standard.removeObject(forKey: "nameKey")
           UserDefaults.standard.removeObject(forKey: "userNameKey")
           UserDefaults.standard.removeObject(forKey: "userPicKey")
           UserDefaults.standard.removeObject(forKey: "userTypeKey")
           UserDefaults.standard.removeObject(forKey: "userTypeNameKey")
            
            UserDefaults.standard.removeObject(forKey: "centerCountKey")
            UserDefaults.standard.removeObject(forKey: "mobilizerCountKey")
            UserDefaults.standard.removeObject(forKey: "studentCountKey")
            UserDefaults.standard.removeObject(forKey: "piaCountKey")
            UserDefaults.standard.removeObject(forKey: "piaUniqueNumberKey")
            UserDefaults.standard.removeObject(forKey: "scheme_idKey")
            
            UserDefaults.standard.removeObject(forKey: "Tnsrlmstaff")
            UserDefaults.standard.removeObject(forKey: "fromDashboard")



   //      let storyBoard : UIStoryboard = UIStoryboard(name: "M3_Login", bundle:nil)
   //      let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! Login
   //      self.present(nextViewController, animated:true, completion:nil)
           self.performSegue(withIdentifier: "logout", sender: self)
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    @IBAction func taskButton(_ sender: Any)
    {
      UserDefaults.standard.set("NO", forKey: "fromDashboard")
      self.performSegue(withIdentifier: "sidemenu_Task", sender: self)
    }

    @IBAction func tracking(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_Tracking", sender: self)
    }
    
    @IBAction func profileAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func aboutUsAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "aboutUs", sender: self)
    }
    
    @IBAction func changePaswrdAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "changePassword", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NavigationBarTitleColor.navbar_TitleColor
        print(GlobalVariables.user_pic!)
        masterndexisClicked = false
        self.userName.text = GlobalVariables.name
        self.userImageView.sd_setImage(with: URL(string: GlobalVariables.user_pic!), placeholderImage: UIImage(named: "profile photo-01.png"))
        self.userImageView.layer.borderWidth = 1
        self.userImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.masksToBounds = true;
        tableView.reloadData()
        self.tableView.backgroundColor = UIColor.white
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
                return 224
            }
            else
            {
                 return 60
            }
        }
        else if (indexPath.row == 8)
        {
            return 180
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
