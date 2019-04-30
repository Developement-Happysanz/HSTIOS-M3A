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
            self.performSegue(withIdentifier: "TNSRLM_Sidemenu_User", sender: self)
        }
        else if indexPath.row == 6
        {
            GlobalVariables.deviceToken = ""
            GlobalVariables.user_id = ""
            GlobalVariables.name = ""
            GlobalVariables.user_name = ""
            GlobalVariables.user_pic = ""
            GlobalVariables.user_type = ""
            GlobalVariables.user_type_name = ""
            
            /* Dashboard values */
            GlobalVariables.center_count = ""
            GlobalVariables.mobilizer_count = ""
            GlobalVariables.student_count = ""
            GlobalVariables.task_count = ""
            
            /* Project Period */
            GlobalVariables.period_from = ""
            GlobalVariables.period_to = ""
            
            
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
    }

}
