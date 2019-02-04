//
//  Dashboard.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 26/12/18.
//  Copyright © 2018 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu

class Dashboard: UIViewController
{

    @IBOutlet weak var viewOne: UIView!
    
    @IBOutlet weak var viewTwo: UIView!
    
    @IBOutlet weak var viewThree: UIView!
    
    @IBOutlet weak var viewFour: UIView!
    
    @IBOutlet weak var viewFive: UIView!
    
    @IBOutlet weak var mobiliserLabel: UILabel!
    
    @IBOutlet weak var studentsLabel: UILabel!
    
    @IBOutlet weak var centerinfoLabel: UILabel!
    
    @IBOutlet weak var tradeLabel: UILabel!
    
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var bell_Image: UIBarButtonItem!
    
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
        mobiliserLabel.text = "Mobiliser" + " " + "-" +  " " + GlobalVariables.mobilizer_count!
        
        centerinfoLabel.text = "Center Information" + " " + "-" +  " " + GlobalVariables.center_count!
        
        studentsLabel.text = "Students" + " " + "-" +  " " + GlobalVariables.student_count!
        
        taskLabel.text = "Task" + " " + "-" +  " " + GlobalVariables.task_count!


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
}
