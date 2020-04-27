//
//  AboutUs.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 20/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {

    @IBOutlet weak var aboutUsText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "About Us"
        NavigationBarTitleColor.navbar_TitleColor
        self.aboutUsText.text = "Mobilizing and Monitoring Management (M3) is an easy-to-use field workforce tracking and management application.\n\nKeeping up with the evolving Software as a Service (SaaS) paradigm, M3 is a combination of technology and strategy aimed at eliminating the troubles faced by field staffs as well as their management.\n\nM3 comes as web and mobile application which operates independently but in a synchronized manner.\n\nM3 is optimized in a way that this application can be deployed for any kind of initiatives that involves field work."
        
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
