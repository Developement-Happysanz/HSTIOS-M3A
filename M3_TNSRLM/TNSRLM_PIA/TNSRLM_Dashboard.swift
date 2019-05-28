//
//  TNSRLM_Dashboard.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 20/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu

class TNSRLM_Dashboard: UIViewController {
    
    @IBOutlet weak var viewOne: UIView!
    
    @IBOutlet weak var viewTwo: UIView!
    
    @IBOutlet weak var viewThree: UIView!
    
    @IBOutlet weak var viewFour: UIView!
    
    @IBOutlet weak var viewFive: UIView!
    
    @IBOutlet weak var PIALabel: UILabel!
    
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var mobiliserLabel: UILabel!
    
    @IBOutlet weak var studentLabel: UILabel!
    
    @IBOutlet weak var GraphLabel: UILabel!
    
    @IBOutlet weak var bell_Image: UIBarButtonItem!
    
    @IBAction func piaButton(_ sender: Any)
    {
        UserDefaults.standard.set("YES", forKey: "tnsrlmPia")
        self.performSegue(withIdentifier: "TNSRLM_Dashboard_Pia", sender: self)
    }
    @IBAction func centerButton(_ sender: Any)
    {
        UserDefaults.standard.set("center", forKey: "tnsrlmPia")
        self.performSegue(withIdentifier: "TNSRLM_Dashboard_Pia", sender: self)
    }
    
    @IBAction func mobiliserButton(_ sender: Any)
    {
        UserDefaults.standard.set("mobiliser", forKey: "tnsrlmPia")
        self.performSegue(withIdentifier: "TNSRLM_Dashboard_Pia", sender: self)
    }
    
    @IBAction func syudentsButton(_ sender: Any)
    {
        UserDefaults.standard.set("prospects", forKey: "tnsrlmPia")
        self.performSegue(withIdentifier: "TNSRLM_Dashboard_Pia", sender: self)
    }
    
    @IBAction func graphButton(_ sender: Any)
    {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        NavigationBarTitleColor.navbar_TitleColor
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        roundedCorners ()
        
        setupSideMenu()
        
        loadValues ()
        
    }
    func loadValues()
    {
//        mobiliserLabel.text = "Mobiliser" + " " + "-" +  " " + GlobalVariables.mobilizer_count!
//        
//        centerLabel.text = "Center Information" + " " + "-" +  " " + GlobalVariables.center_count!
////
//        studentLabel.text = "Prospects" + " " + "-" +  " " + GlobalVariables.student_count!
//
//        taskLabel.text = "Task" + " " + "-" +  " " + GlobalVariables.task_count!
        
        
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
    fileprivate func roundedCorners ()
    {
        viewOne.layer.cornerRadius = 4.0
        viewOne.layer.shadowColor = UIColor.gray.cgColor
        viewOne.layer.shadowOpacity = 2
        viewOne.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewOne.layer.shadowRadius = 3
        
        viewTwo.layer.cornerRadius = 4.0
        viewTwo.layer.shadowColor = UIColor.gray.cgColor
        viewTwo.layer.shadowOpacity = 2
        viewTwo.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewTwo.layer.shadowRadius = 3
        
        viewThree.layer.cornerRadius = 4.0
        viewThree.layer.shadowColor = UIColor.gray.cgColor
        viewThree.layer.shadowOpacity = 2
        viewThree.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewThree.layer.shadowRadius = 3
        
        viewFour.layer.cornerRadius = 4.0
        viewFour.layer.shadowColor = UIColor.gray.cgColor
        viewFour.layer.shadowOpacity = 2
        viewFour.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewFour.layer.shadowRadius = 3
        
        viewFive.layer.cornerRadius = 4.0
        viewFive.layer.shadowColor = UIColor.gray.cgColor
        viewFive.layer.shadowOpacity = 2
        viewFive.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewFive.layer.shadowRadius = 3
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
