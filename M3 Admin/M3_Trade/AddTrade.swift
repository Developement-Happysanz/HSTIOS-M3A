//
//  AddTrade.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 11/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire

class AddTrade: UIViewController,UITextFieldDelegate
{

    @IBOutlet var titleText: UITextField!
    
    @IBOutlet var okOutlet: UIButton!
    
    @IBAction func okButton(_ sender: Any)
    {
        let title = self.titleText.text
        
        if (title!.isEmpty)
        {
            let alertController = UIAlertController(title: "M3", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let functionName = "apipia/create_trade"
            let baseUrl = Baseurl.baseUrl + functionName
            let url = URL(string: baseUrl)!
            let parameters: Parameters = ["user_id": GlobalVariables.user_id!, "trade_name": title!]
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
                            // Mark : Parseing userData
                            let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                
                                self.titleText.text = ""
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Add Title"
        
        titleText.delegate = self
        
        okOutlet.layer.cornerRadius = 4
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == titleText
        {
            titleText.resignFirstResponder()
        }
        
        return true
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
