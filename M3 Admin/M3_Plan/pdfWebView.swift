//
//  pdfWebView.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 09/04/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import WebKit

class pdfWebView: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let str = UserDefaults.standard.string(forKey:"pdfKey")
        
        let url = URL (string: str!)
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
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
