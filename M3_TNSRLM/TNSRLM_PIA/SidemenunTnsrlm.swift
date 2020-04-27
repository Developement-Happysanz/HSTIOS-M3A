//
//  SidemenunTnsrlm.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class SidemenunTnsrlm: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            return 191
        }
        else if (indexPath.row == 6)
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
        if indexPath.row == 2
        {
            self.performSegue(withIdentifier: "piaList", sender: self)
        }
        else if indexPath.row == 3
        {
            UserDefaults.standard.set("mobiliserPlan", forKey: "tnsrlmPia")
            self.performSegue(withIdentifier: "piaList", sender: self)
        }
        else if indexPath.row == 4
        {
            UserDefaults.standard.set("YES", forKey: "Tnsrlmstaff")
            UserDefaults.standard.set("staff", forKey: "tnsrlmPia")
            self.performSegue(withIdentifier: "TNSRLM_Sidemenu_User", sender: self)
        }
        else if indexPath.row == 5
        {
            UserDefaults.standard.set("YES", forKey: "Tnsrlmstaff")
            self.performSegue(withIdentifier: "to_Scheme", sender: self)
        }
    }
    
    @IBAction func aboutUs(_ sender: Any)
    {
        self.performSegue(withIdentifier: "aboutUs", sender: self)
    }
    
    @IBAction func changePaswrd(_ sender: Any)
    {
        self.performSegue(withIdentifier: "changePassword", sender: self)
    }
    
    @IBAction func profileAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_Profile", sender: self)
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
            // GlobalVariables.center_count = ""
            // GlobalVariables.mobilizer_count = ""
            // GlobalVariables.student_count = ""
            // GlobalVariables.task_count = ""
            //
            /* Project Period */
            // GlobalVariables.period_from = ""
            // GlobalVariables.period_to = ""
                                    
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
            UserDefaults.standard.removeObject(forKey: "pia_Creation")
            
           self.performSegue(withIdentifier: "tnsrlmLogout", sender: self)
          }
          let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
                            UIAlertAction in
          }
          
          alertController.addAction(okAction)
          alertController.addAction(cancelAction)
          self.present(alertController, animated: true, completion: nil)
        
    }
    
}
